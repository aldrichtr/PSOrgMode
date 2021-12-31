
;;; Parsing Element Starting At Point
;;
;; `org-element--current-element' is the core function of this section.
;; It returns the Lisp representation of the element starting at
;; point.

(defun org-element--current-element (limit &optional granularity mode structure)
  "Parse the element starting at point.

  Return value is a list like (TYPE PROPS) where TYPE is the type
  of the element and PROPS a plist of properties associated to the
  element.

  Possible types are defined in `org-element-all-elements'.

  LIMIT bounds the search.

  Optional argument GRANULARITY determines the depth of the
  recursion.  Allowed values are `headline', `greater-element',
  `element', `object' or nil.  When it is broader than `object' (or
  nil), secondary values will not be parsed, since they only
  contain objects.

  Optional argument MODE, when non-nil, can be either
  `first-section', `item', `node-property', `planning',
  `property-drawer', `section', `table-row', or `top-comment'.


  If STRUCTURE isn't provided but MODE is set to `item', it will be
  computed.

  This function assumes point is always at the beginning of the
  element it has to parse."
  (save-excursion
    (let
      (
        (case-fold-search t)
        ;; Determine if parsing depth allows for secondary strings
        ;; parsing.  It only applies to elements referenced in
        ;; `org-element-secondary-value-alist'.
        (raw-secondary-p
          (and
            granularity
            (not
              (eq granularity 'object)
            )
          )
        )
      )
      (cond
        ;; Item.
        ((eq mode 'item) (org-element-item-parser limit structure raw-secondary-p))
        ;; Table Row.
        ((eq mode 'table-row) (org-element-table-row-parser limit))
        ;; Node Property.
        ((eq mode 'node-property) (org-element-node-property-parser limit))
        ;; Headline.
        ((org-with-limited-levels (org-at-heading-p))
         (org-element-headline-parser limit raw-secondary-p)
        )
        ;; Sections (must be checked after headline).
        ((eq mode 'section) (org-element-section-parser limit))
        ((eq mode 'first-section)
          (org-element-section-parser
            (or
              (save-excursion
                (org-with-limited-levels (outline-next-heading))
              )
              limit
            )
          )
        )
        ;; Comments.
        ((looking-at "^[ \t]*#\\(?: \\|$\\)")
         (org-element-comment-parser limit)
        )
        ;; Planning.
        ((and
           (eq mode 'planning)
           (eq ?* (char-after (line-beginning-position 0)))
           (looking-at org-planning-line-re)
         )
         (org-element-planning-parser limit)
        )
        ;; Property drawer.
        ((and
          (pcase mode
            (`planning (eq ?* (char-after (line-beginning-position 0))))
            ((or `property-drawer `top-comment)
             (save-excursion
               (beginning-of-line 0)
               (not (looking-at "[[:blank:]]*$"))
             )
            )
            (_ nil)
          )
          (looking-at org-property-drawer-re)
         )
         (org-element-property-drawer-parser limit)
        )
        ;; When not at bol, point is at the beginning of an item or
        ;; a footnote definition: next item is always a paragraph.
        ((not (bolp)) (org-element-paragraph-parser limit (list (point))))
        ;; Clock.
        ((looking-at org-clock-line-re) (org-element-clock-parser limit))
        ;; Inlinetask.
        ((looking-at "^\\*+ ")
         (org-element-inlinetask-parser limit raw-secondary-p)
        )
        ;; From there, elements can have affiliated keywords.
        (t
          (let
            (
             (affiliated (org-element--collect-affiliated-keywords
               limit (memq granularity '(nil object))))
            )
            (cond
              ;; Jumping over affiliated keywords put point off-limits.
              ;; Parse them as regular keywords.
              (
                 (and (cdr affiliated) (>= (point) limit))
                 (goto-char (car affiliated))
                 (org-element-keyword-parser limit nil)
              )
              ;; LaTeX Environment.
              (
                 (looking-at org-element--latex-begin-environment)
                 (org-element-latex-environment-parser limit affiliated)
              )
              ;; Drawer.
              (
                 (looking-at org-drawer-regexp)
                 (org-element-drawer-parser limit affiliated)
              )
              ;; Fixed Width
              (
                 (looking-at "[ \t]*:\\( \\|$\\)")
                 (org-element-fixed-width-parser limit affiliated)
              )
              ;; Inline Comments, Blocks, Babel Calls, Dynamic Blocks and
              ;; Keywords.
              (
                 (looking-at "[ \t]*#\\+")
                 (goto-char (match-end 0))
                 (cond
                    (
                       (looking-at "BEGIN_\\(\\S-+\\)")
                       (beginning-of-line)
                       (funcall
                         (pcase
                           (upcase (match-string 1))
                           ("CENTER"  #'org-element-center-block-parser)
                           ("COMMENT" #'org-element-comment-block-parser)
                           ("EXAMPLE" #'org-element-example-block-parser)
                           ("EXPORT"  #'org-element-export-block-parser)
                           ("QUOTE"   #'org-element-quote-block-parser)
                           ("SRC"     #'org-element-src-block-parser)
                           ("VERSE"   #'org-element-verse-block-parser)
                           (_         #'org-element-special-block-parser)
                         )
                         limit
                         affiliated
                       )
                    )
                    (
                       (looking-at "CALL:")
                       (beginning-of-line)
                       (org-element-babel-call-parser limit affiliated)
                    )
                    (
                       (looking-at "BEGIN:? ")
                       (beginning-of-line)
                       (org-element-dynamic-block-parser limit affiliated)
                    )
                    (
                       (looking-at "\\S-+:")
                       (beginning-of-line)
                       (org-element-keyword-parser limit affiliated)
                    )
                    (t
                       (beginning-of-line)
                       (org-element-paragraph-parser limit affiliated)
                    )
                 )
            )
            ;; Footnote Definition.
            ((looking-at org-footnote-definition-re)
          (org-element-footnote-definition-parser limit affiliated))
         ;; Horizontal Rule.
         ((looking-at "[ \t]*-\\{5,\\}[ \t]*$")
          (org-element-horizontal-rule-parser limit affiliated))
         ;; Diary Sexp.
         ((looking-at "%%(")
          (org-element-diary-sexp-parser limit affiliated))
         ;; Table.
         ((or (looking-at "[ \t]*|")
          ;; There is no strict definition of a table.el
          ;; table.  Try to prevent false positive while being
          ;; quick.
          (let ((rule-regexp
             (rx (zero-or-more (any " \t"))
                 "+"
                 (one-or-more (one-or-more "-") "+")
                 (zero-or-more (any " \t"))
                 eol))
            (non-table.el-line
             (rx bol
                 (zero-or-more (any " \t"))
                 (or eol (not (any "+| \t")))))
            (next (line-beginning-position 2)))
            ;; Start with a full rule.
            (and
             (looking-at rule-regexp)
             (< next limit)	;no room for a table.el table
             (save-excursion
               (end-of-line)
               (cond
            ;; Must end with a full rule.
            ((not (re-search-forward non-table.el-line limit 'move))
             (if (bolp) (forward-line -1) (beginning-of-line))
             (looking-at rule-regexp))
            ;; Ignore pseudo-tables with a single
            ;; rule.
            ((= next (line-beginning-position))
             nil)
            ;; Must end with a full rule.
            (t
             (forward-line -1)
             (looking-at rule-regexp)))))))
          (org-element-table-parser limit affiliated))
         ;; List.
         ((looking-at (org-item-re))
          (org-element-plain-list-parser
           limit affiliated
           (or structure (org-element--list-struct limit))))
         ;; Default element: Paragraph.
         (t (org-element-paragraph-parser limit affiliated)))))))))
