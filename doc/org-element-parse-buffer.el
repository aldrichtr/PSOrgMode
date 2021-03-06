;;; The Org Parser
;;
;; The two major functions here are `org-element-parse-buffer', which
;; parses Org syntax inside the current buffer, taking into account
;; region, narrowing, or even visibility if specified, and
;; `org-element-parse-secondary-string', which parses objects within
;; a given string.
;;
;; The (almost) almighty `org-element-map' allows applying a function
;; on elements or objects matching some type, and accumulating the
;; resulting values.  In an export situation, it also skips unneeded
;; parts of the parse tree.

(defun org-element-parse-buffer
  (&optional granularity visible-only)
  "Recursively parse the buffer and return structure.
  If narrowing is in effect, only parse the visible part of the
  buffer.

  Optional argument GRANULARITY determines the depth of the
  recursion.  It can be set to the following symbols:

  `headline'          Only parse headlines.
  `greater-element'   Don't recurse into greater elements except
  		    headlines and sections.  Thus, elements
  		    parsed are the top-level ones.
  `element'           Parse everything but objects and plain text.
  `object'            Parse the complete buffer (default).

  When VISIBLE-ONLY is non-nil, don't parse contents of hidden
  elements.

  An element or object is represented as a list with the
  pattern (TYPE PROPERTIES CONTENTS), where :

    TYPE is a symbol describing the element or object.  See
    `org-element-all-elements' and `org-element-all-objects' for an
    exhaustive list of such symbols.  One can retrieve it with
    `org-element-type' function.

    PROPERTIES is the list of attributes attached to the element or
    object, as a plist.  Although most of them are specific to the
    element or object type, all types share `:begin', `:end',
    `:post-blank' and `:parent' properties, which respectively
    refer to buffer position where the element or object starts,
    ends, the number of white spaces or blank lines after it, and
    the element or object containing it.  Properties values can be
    obtained by using `org-element-property' function.

    CONTENTS is a list of elements, objects or raw strings
    contained in the current element or object, when applicable.
    One can access them with `org-element-contents' function.

  The Org buffer has `org-data' as type and nil as properties.
  `org-element-map' function can be used to find specific elements
  or objects within the parse tree.

  This function assumes that current major mode is `org-mode'."
  (save-excursion
    (goto-char (point-min))
    (org-skip-whitespace)
    (org-element--parse-elements
      (point-at-bol) (point-max)
      ;; Start in `first-section' mode so text before the first
      ;; headline belongs to a section.
      'first-section
      nil
      granularity
      visible-only
      (list 'org-data nil)
    )
  )
)
