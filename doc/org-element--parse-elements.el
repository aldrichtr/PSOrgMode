(defun org-element--parse-elements
  (beg end mode structure granularity visible-only acc)
  "Parse elements between BEG and END positions.

  MODE prioritizes some elements over the others.  It can be set to
  `first-section', `item', `node-property', `planning',
  `property-drawer', `section', `table-row', `top-comment', or nil.

  When value is `item', STRUCTURE will be used as the current list
  structure.

  GRANULARITY determines the depth of the recursion.  See
  `org-element-parse-buffer' for more information.

  When VISIBLE-ONLY is non-nil, don't parse contents of hidden
  elements.

  Elements are accumulated into ACC."
  (save-excursion
    (goto-char beg)
    ;; When parsing only headlines, skip any text before first one.
    (when
      (and
        (eq granularity 'headline)
        (not (org-at-heading-p))
      )
      (org-with-limited-levels (outline-next-heading))
    )

    (let (elements)

      ;;; TRA: here is the actual "parse part"
      (while (< (point) end)
        ;; Visible only: skip invisible parts due to folding.
        (if (and
              visible-only
              (org-invisible-p nil t)
            )
            (progn
              (goto-char (org-find-visible))
              (when
                (and (eolp) (not (eobp)))
                (forward-char)
              )
            )

            ;; Find current element's type and parse it accordingly to
            ;; its category.
            (let*
              (
               ;;; TRA: now here in the parsing, throw the contents at the "current-element"
               ;;;      parser, telling it where the end is, the mode, etc.
                (element
                  (org-element--current-element end granularity mode structure)
                )
                (type (org-element-type element))
                (cbeg (org-element-property :contents-begin element))
              )
              ;;; TRA: after we make an element jump to the end of it and continue
              (goto-char (org-element-property :end element))
                ;; Fill ELEMENT contents by side-effect.
                (cond
                  ;; If element has no contents, don't modify it.
                  ((not cbeg))
                  ;; Greater element: parse it between `contents-begin' and
                  ;; `contents-end'.  Ensure GRANULARITY allows recursion,
                  ;; or ELEMENT is a headline, in which case going inside
                  ;; is mandatory, in order to get sub-level headings.
                  ((and
                     (memq type org-element-greater-elements)
                     (or
                       (memq granularity '(element object nil))
                       (and
                         (eq granularity 'greater-element)
                         (eq type 'section)
                       )
                       (eq type 'headline)
                     )
                   )
                   (org-element--parse-elements
                      cbeg (org-element-property :contents-end element)
                    ;; Possibly switch to a special mode.
                      (org-element--next-mode mode type t)
                      (and
                        (memq type '(item plain-list))
                        (org-element-property :structure element)
                      )
                      granularity visible-only element)
                  )
                  ;; ELEMENT has contents.  Parse objects inside, if
                  ;; GRANULARITY allows it.
                  ((memq granularity '(object nil))
                   (org-element--parse-objects
                     cbeg (org-element-property :contents-end element) element
                     (org-element-restriction type)
                   )
                  )
                )
                (push (org-element-put-property element :parent acc) elements)
                ;; Update mode.
                (setq mode (org-element--next-mode mode type nil))
            )
        )
      )
      ;; Return result.
      (apply #'org-element-set-contents acc (nreverse elements))
    )
  )
)
