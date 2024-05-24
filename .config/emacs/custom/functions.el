;;  CUSTOM FUNCTIONS

;;; Code:
(defun my/copy-filename-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message filename))))

(defun doom/toggle-line-numbers ()
  "Toggle line numbers.
Cycles through regular, relative and no line numbers. The order depends on what
`display-line-numbers-type' is set to. If you're using Emacs 26+, and
visual-line-mode is on, this skips relative and uses visual instead.
See `display-line-numbers' for what these values mean."
  (interactive)
  (defvar doom--line-number-style display-line-numbers-type)
  (let* ((styles `(t ,(if visual-line-mode 'visual 'relative) nil))
         (order (cons display-line-numbers-type (remq display-line-numbers-type styles)))
         (queue (memq doom--line-number-style order))
         (next (if (= (length queue) 1)
                   (car order)
                 (car (cdr queue)))))
    (setq doom--line-number-style next)
    (setq display-line-numbers next)
    (message "Switched to %s line numbers"
             (pcase next
               (`t "normal")
               (`nil "disabled")
               (_ (symbol-name next))))))


(defun doom/toggle-indent-style ()
  "Switch between tabs and spaces indentation style in the current buffer."
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode))
  (message "Indent style changed to %s" (if indent-tabs-mode "tabs" "spaces")))

(defun my/org-roam-insert-node-link(node)
  (save-excursion
    (goto-char (point-max))
      (insert
        "\n"
        (org-link-make-string
          (concat "id:" (org-roam-node-id node))
          (org-roam-node-formatted node)))))


(defun my/org-roam-filter-by-tag (tag)
  "Filters all roam-notes by TAG."
  (lambda (node)
    (member tag (org-roam-node-tags node))))


(defun my/org-roam-get-nodes-by-tag(tag)
  (seq-filter
    (lambda (node) (member tag (org-roam-node-tags node)))
    (org-roam-node-list)))

(defun my/org-roam-list-notes-by-tag (tag)
  "Return a list with all roam notes matching TAG."
 (mapcar #'org-roam-node-file
         (seq-filter
           (my/org-roam-filter-by-tag tag)
           (org-roam-node-list))))

(defun my/refresh-roam-gitignore()
  "Create a new .gitignore file at the org-roam directory excluding the notes matching
the criteria."
  (interactive)
  (let (
     (notes (mapcar
             (lambda (filepath)
               (file-relative-name filepath org-roam-directory))
             (my/org-roam-list-notes-by-tag "work")))
     )
    (when notes
      (my/save-lines-to-file
       (expand-file-name ".gitignore" org-roam-directory)
       (cons ".gitignore" notes)))))

(defun my/org-roam-node-is-untagged(node)
  "Check if a single NODE is untagged."
  (lambda (node))
  (null (org-roam-node-tags node)))

(defun my/org-roam-get-untagged()
  "Get all untagged notes"
  (interactive)
  (org-roam-node-find nil nil 'my/org-roam-node-is-untagged))

(defun my/save-lines-to-file (filename lines)
 "Insert LINES into FILENAME, each on a new line."
 (with-temp-file filename
   (dolist (line lines)
     (insert line "\n"))))

(defun my/insert-lines-to-buffer-end(lines)
 (save-excursion
   (goto-char (point-max))
   (dolist (match lines)
     (insert "\n" match))))


;; An "advice" function in emacs is like a python decorator, a wrapper.
;; this one is to highlight on yank
(defun my/evil-yank-advice (orig-fn beg end &rest args)
  (pulse-momentary-highlight-region beg end)
  (apply orig-fn beg end args))




;; Stuff from doom emacs for org-mode automation

(defun +org/dwim-at-point (&optional arg)
  "Do-what-I-mean at point.

If on a:
- checkbox list item or todo heading: toggle it.
- citation: follow it
- headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
  subtree; update statistics cookies/checkboxes and ToCs.
- clock: update its time.
- footnote reference: jump to the footnote's definition
- footnote definition: jump to the first reference of this footnote
- timestamp: open an agenda view for the time-stamp date/range at point.
- table-row or a TBLFM: recalculate the table's formulas
- table-cell: clear it and go into insert mode. If this is a formula cell,
  recaluclate it instead.
- babel-call: execute the source block
- statistics-cookie: update it.
- src block: execute it
- latex fragment: toggle it.
- link: follow it
- otherwise, refresh all inline images in current tree."
  (interactive "P")
  (if (button-at (point))
      (call-interactively #'push-button)
    (let* ((context (org-element-context))
           (type (org-element-type context)))
      ;; skip over unimportant contexts
      (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
        (setq context (org-element-property :parent context)
              type (org-element-type context)))
      (pcase type
        ((or `citation `citation-reference)
         (org-cite-follow context arg))

        (`headline
         (cond ((memq (bound-and-true-p org-goto-map)
                      (current-active-maps))
                (org-goto-ret))
               ((and (fboundp 'toc-org-insert-toc)
                     (member "TOC" (org-get-tags)))
                (toc-org-insert-toc)
                (message "Updating table of contents"))
               ((string= "ARCHIVE" (car-safe (org-get-tags)))
                (org-force-cycle-archived))
               ((or (org-element-property :todo-type context)
                    (org-element-property :scheduled context))
                (org-todo
                 (if (eq (org-element-property :todo-type context) 'done)
                     (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
                         'todo)
                   'done))))
         ;; Update any metadata or inline previews in this subtree
         (org-update-checkbox-count)
         (org-update-parent-todo-statistics)
         (when (and (fboundp 'toc-org-insert-toc)
                    (member "TOC" (org-get-tags)))
           (toc-org-insert-toc)
           (message "Updating table of contents"))
         (let* ((beg (if (org-before-first-heading-p)
                         (line-beginning-position)
                       (save-excursion (org-back-to-heading) (point))))
                (end (if (org-before-first-heading-p)
                         (line-end-position)
                       (save-excursion (org-end-of-subtree) (point))))
                (overlays (ignore-errors (overlays-in beg end)))
                (latex-overlays
                 (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
                             overlays))
                (image-overlays
                 (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
                             overlays)))
           (+org--toggle-inline-images-in-subtree beg end)
           (if (or image-overlays latex-overlays)
               (org-clear-latex-preview beg end)
             (org--latex-preview-region beg end))))

        (`clock (org-clock-update-time-maybe))

        (`footnote-reference
         (org-footnote-goto-definition (org-element-property :label context)))

        (`footnote-definition
         (org-footnote-goto-previous-reference (org-element-property :label context)))

        ((or `planning `timestamp)
         (org-follow-timestamp-link))

        ((or `table `table-row)
         (if (org-at-TBLFM-p)
             (org-table-calc-current-TBLFM)
           (ignore-errors
             (save-excursion
               (goto-char (org-element-property :contents-begin context))
               (org-call-with-arg 'org-table-recalculate (or arg t))))))

        (`table-cell
         (org-table-blank-field)
         (org-table-recalculate arg)
         (when (and (string-empty-p (string-trim (org-table-get-field)))
                    (bound-and-true-p evil-local-mode))
           (evil-change-state 'insert)))

        (`babel-call
         (org-babel-lob-execute-maybe))

        (`statistics-cookie
         (save-excursion (org-update-statistics-cookies arg)))

        ((or `src-block `inline-src-block)
         (org-babel-execute-src-block arg))

        ((or `latex-fragment `latex-environment)
         (org-latex-preview arg))

        (`link
         (let* ((lineage (org-element-lineage context '(link) t))
                (path (org-element-property :path lineage)))
           (if (or (equal (org-element-property :type lineage) "img")
                   (and path (image-type-from-file-name path)))
               (+org--toggle-inline-images-in-subtree
                (org-element-property :begin lineage)
                (org-element-property :end lineage))
             (org-open-at-point arg))))

        ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
         (org-toggle-checkbox))

        (`paragraph
         (+org--toggle-inline-images-in-subtree))

        (_
         (if (or (org-in-regexp org-ts-regexp-both nil t)
                 (org-in-regexp org-tsr-regexp-both nil  t)
                 (org-in-regexp org-link-any-re nil t))
             (call-interactively #'org-open-at-point)
           (+org--toggle-inline-images-in-subtree
            (org-element-property :begin context)
            (org-element-property :end context))))))))

(defun +org--toggle-inline-images-in-subtree (&optional beg end refresh)
  "Refresh inline image previews in the current heading/tree."
  (let* ((beg (or beg
                  (if (org-before-first-heading-p)
                      (save-excursion (point-min))
                    (save-excursion (org-back-to-heading) (point)))))
         (end (or end
                  (if (org-before-first-heading-p)
                      (save-excursion (org-next-visible-heading 1) (point))
                    (save-excursion (org-end-of-subtree) (point)))))
         (overlays (cl-remove-if-not (lambda (ov) (overlay-get ov 'org-image-overlay))
                                     (ignore-errors (overlays-in beg end)))))
    (dolist (ov overlays nil)
      (delete-overlay ov)
      (setq org-inline-image-overlays (delete ov org-inline-image-overlays)))
    (when (or refresh (not overlays))
      (org-display-inline-images t t beg end)
      t)))

;; ;;; Code:
;; (defun my/popup-scratch-buffer nil
;;   "Popup a scratch buffer."
;;   (interactive)
;;   (evil-window-split 20)
;;   (switch-to-buffer (get-buffer-create "*scratch*"))
;;   (lisp-interaction-mode))

;; (defun my/close-all-buffers ()
;;   "Closes all buffers."
;;   (interactive)
;;   ;; (kill-matching-buffers ".*"))
;;   (cl-loop for buf in (buffer-list)
;; 	       if (not (or (string-match "^*dashboard" (buffer-name buf))
;; 				       (string-match "^*Messages" (buffer-name buf))
;; 				       (string-match "^*scratch" (buffer-name buf))
;; 				       (string-match "^ " (buffer-name buf))))
;; 	       do (kill-buffer buf))
;;   (dashboard-refresh-buffer))

;; (defun my/delete-trailing-newlines ()
;;   "Deletes trailing newlines."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-max))
;;     (delete-blank-lines)))

;; (defun my/copy-filename-to-clipboard ()
;;   "Copy the current buffer file name to the clipboard."
;;   (interactive)
;;   (let ((filename (if (equal major-mode 'dired-mode)
;;                       default-directory
;;                     (buffer-file-name))))
;;     (when filename
;;       (kill-new filename)
;;       (message filename))))


;; (defun +org/dwim-at-point (&optional arg)
;;   "Do-what-I-mean at point.

;; *got this from doom emacs*

;; If on a:
;; - checkbox list item or todo heading: toggle it.
;; - clock: update its time.
;; - headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
;;   subtree; update statistics cookies/checkboxes and ToCs.
;; - footnote reference: jump to the footnote's definition
;; - footnote definition: jump to the first reference of this footnote
;; - table-row or a TBLFM: recalculate the table's formulas
;; - table-cell: clear it and go into insert mode. If this is a formula cell,
;;   recaluclate it instead.
;; - babel-call: execute the source block
;; - statistics-cookie: update it.
;; - latex fragment: toggle it.
;; - link: follow it
;; - otherwise, refresh all inline images in current tree."
;;   (interactive "P")
;;   (let* ((context (org-element-context))
;;          (type (org-element-type context)))
;;     ;; skip over unimportant contexts
;;     (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
;;       (setq context (org-element-property :parent context)
;;             type (org-element-type context)))
;;     (pcase type
;;       (`headline
;;        (cond ((memq (bound-and-true-p org-goto-map)
;;                     (current-active-maps))
;;               (org-goto-ret))
;;              ((and (fboundp 'toc-org-insert-toc)
;;                    (member "TOC" (org-get-tags)))
;;               (toc-org-insert-toc)
;;               (message "Updating table of contents"))
;;              ((string= "ARCHIVE" (car-safe (org-get-tags)))
;;               (org-force-cycle-archived))
;;              ((or (org-element-property :todo-type context)
;;                   (org-element-property :scheduled context))
;;               (org-todo
;;                (if (eq (org-element-property :todo-type context) 'done)
;;                    (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
;;                        'todo)
;;                  'done))))
;;        ;; Update any metadata or inline previews in this subtree
;;        (org-update-checkbox-count)
;;        (org-update-parent-todo-statistics)
;;        (when (and (fboundp 'toc-org-insert-toc)
;;                   (member "TOC" (org-get-tags)))
;;          (toc-org-insert-toc)
;;          (message "Updating table of contents"))
;;        (let* ((beg (if (org-before-first-heading-p)
;;                        (line-beginning-position)
;;                      (save-excursion (org-back-to-heading) (point))))
;;               (end (if (org-before-first-heading-p)
;;                        (line-end-position)
;;                      (save-excursion (org-end-of-subtree) (point))))
;;               (overlays (ignore-errors (overlays-in beg end)))
;;               (latex-overlays
;;                (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
;;                            overlays))
;;               (image-overlays
;;                (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
;;                            overlays)))
;;          (+org--toggle-inline-images-in-subtree beg end)
;;          (if (or image-overlays latex-overlays)
;;              (org-clear-latex-preview beg end)
;;            (org--latex-preview-region beg end))))

;;       (`clock (org-clock-update-time-maybe))

;;       (`footnote-reference
;;        (org-footnote-goto-definition (org-element-property :label context)))

;;       (`footnote-definition
;;        (org-footnote-goto-previous-reference (org-element-property :label context)))

;;       ((or `planning `timestamp)
;;        (org-follow-timestamp-link))

;;       ((or `table `table-row)
;;        (if (org-at-TBLFM-p)
;;            (org-table-calc-current-TBLFM)
;;          (ignore-errors
;;            (save-excursion
;;              (goto-char (org-element-property :contents-begin context))
;;              (org-call-with-arg 'org-table-recalculate (or arg t))))))

;;       (`table-cell
;;        (org-table-blank-field)
;;        (org-table-recalculate arg)
;;        (when (and (string-empty-p (string-trim (org-table-get-field)))
;;                   (bound-and-true-p evil-local-mode))
;;          (evil-change-state 'insert)))

;;       (`babel-call
;;        (org-babel-lob-execute-maybe))

;;       (`statistics-cookie
;;        (save-excursion (org-update-statistics-cookies arg)))

;;       ((or `src-block `inline-src-block)
;;        (org-babel-execute-src-block arg))

;;       ((or `latex-fragment `latex-environment)
;;        (org-latex-preview arg))

;;       (`link
;;        (let* ((lineage (org-element-lineage context '(link) t))
;;               (path (org-element-property :path lineage)))
;;          (if (or (equal (org-element-property :type lineage) "img")
;;                  (and path (image-type-from-file-name path)))
;;              (+org--toggle-inline-images-in-subtree
;;               (org-element-property :begin lineage)
;;               (org-element-property :end lineage))
;;            (org-open-at-point arg))))

;;       ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
;;        (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
;;          (org-toggle-checkbox (if (equal match "[ ]") '(16)))))

;;       (_
;;        (if (or (org-in-regexp org-ts-regexp-both nil t)
;;                (org-in-regexp org-tsr-regexp-both nil  t)
;;                (org-in-regexp org-link-any-re nil t))
;;            (call-interactively #'org-open-at-point)
;;          (+org--toggle-inline-images-in-subtree
;;           (org-element-property :begin context)
;;           (org-element-property :end context)))))))


;; (defun doom/toggle-line-numbers ()
;;   "Toggle line numbers.
;; Cycles through regular, relative and no line numbers. The order depends on what
;; `display-line-numbers-type' is set to. If you're using Emacs 26+, and
;; visual-line-mode is on, this skips relative and uses visual instead.
;; See `display-line-numbers' for what these values mean."
;;   (interactive)
;;   (defvar doom--line-number-style display-line-numbers-type)
;;   (let* ((styles `(t ,(if visual-line-mode 'visual 'relative) nil))
;;          (order (cons display-line-numbers-type (remq display-line-numbers-type styles)))
;;          (queue (memq doom--line-number-style order))
;;          (next (if (= (length queue) 1)
;;                    (car order)
;;                  (car (cdr queue)))))
;;     (setq doom--line-number-style next)
;;     (setq display-line-numbers next)
;;     (message "Switched to %s line numbers"
;;              (pcase next
;;                (`t "normal")
;;                (`nil "disabled")
;;                (_ (symbol-name next))))))


;; (defun doom/toggle-indent-style ()
;;   "Switch between tabs and spaces indentation style in the current buffer."
;;   (interactive)
;;   (setq indent-tabs-mode (not indent-tabs-mode))
;;   (message "Indent style changed to %s" (if indent-tabs-mode "tabs" "spaces")))
