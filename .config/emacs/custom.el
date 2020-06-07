;;  CUSTOM FUNCTIONS

;;; Code:
(defun my/popup-scratch-buffer nil
  "Popup a scratch buffer."
  (interactive)
  (evil-window-split 20)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun my/close-all-buffers ()
  "Closes all buffers."
  (interactive)
  ;; (kill-matching-buffers ".*"))
  (cl-loop for buf in (buffer-list)
	if (not (or (string-match "^*dashboard" (buffer-name buf))
				(string-match "^*Messages" (buffer-name buf))
				(string-match "^*scratch" (buffer-name buf))
				(string-match "^ " (buffer-name buf))))
	do (kill-buffer buf))
  (dashboard-refresh-buffer))

(defun my/delete-trailing-newlines ()
  "Deletes trailing newlines."
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (delete-blank-lines)))

(defun my/copy-filename-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message filename))))


(defun +org/dwim-at-point (&optional arg)
  "Do-what-I-mean at point.

*got this from doom emacs*

If on a:
- checkbox list item or todo heading: toggle it.
- clock: update its time.
- headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
  subtree; update statistics cookies/checkboxes and ToCs.
- footnote reference: jump to the footnote's definition
- footnote definition: jump to the first reference of this footnote
- table-row or a TBLFM: recalculate the table's formulas
- table-cell: clear it and go into insert mode. If this is a formula cell,
  recaluclate it instead.
- babel-call: execute the source block
- statistics-cookie: update it.
- latex fragment: toggle it.
- link: follow it
- otherwise, refresh all inline images in current tree."
  (interactive "P")
  (let* ((context (org-element-context))
         (type (org-element-type context)))
    ;; skip over unimportant contexts
    (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
      (setq context (org-element-property :parent context)
            type (org-element-type context)))
    (pcase type
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
       (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
         (org-toggle-checkbox (if (equal match "[ ]") '(16)))))

      (_
       (if (or (org-in-regexp org-ts-regexp-both nil t)
               (org-in-regexp org-tsr-regexp-both nil  t)
               (org-in-regexp org-link-any-re nil t))
           (call-interactively #'org-open-at-point)
         (+org--toggle-inline-images-in-subtree
          (org-element-property :begin context)
          (org-element-property :end context)))))))


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



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-show-quick-access t nil nil "Customized with use-package company")
 '(custom-safe-themes
   '("24168c7e083ca0bbc87c68d3139ef39f072488703dcdd82343b8cab71c0f62a7" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" "b6269b0356ed8d9ed55b0dcea10b4e13227b89fd2af4452eee19ac88297b0f99" "b02eae4d22362a941751f690032ea30c7c78d8ca8a1212fdae9eecad28a3587f" "4b0e826f58b39e2ce2829fab8ca999bcdc076dec35187bf4e9a4b938cb5771dc" "846b3dc12d774794861d81d7d2dcdb9645f82423565bfb4dad01204fa322dbd5" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "e2c926ced58e48afc87f4415af9b7f7b58e62ec792659fcb626e8cba674d2065" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "6f4421bf31387397f6710b6f6381c448d1a71944d9e9da4e0057b3fe5d6f2fad" "1bddd01e6851f5c4336f7d16c56934513d41cc3d0233863760d1798e74809b4b" "e19ac4ef0f028f503b1ccafa7c337021834ce0d1a2bca03fcebc1ef635776bea" "1278c5f263cdb064b5c86ab7aa0a76552082cf0189acf6df17269219ba496053" "5f19cb23200e0ac301d42b880641128833067d341d22344806cdad48e6ec62f6" "028c226411a386abc7f7a0fba1a2ebfae5fe69e2a816f54898df41a6a3412bb5" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "e8df30cd7fb42e56a4efc585540a2e63b0c6eeb9f4dc053373e05d774332fc13" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "82ef0ab46e2e421c4bcbc891b9d80d98d090d9a43ae76eb6f199da6a0ce6a348" "824d07981667fd7d63488756b6d6a4036bae972d26337babf7b56df6e42f2bcd" "2c49d6ac8c0bf19648c9d2eabec9b246d46cb94d83713eaae4f26b49a8183fc4" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" default))
 '(package-selected-packages
   '(vterm dired-hide-dotfiles-mode terraform-mode monokai-pro-theme lsp-pyright rg mu4e-views dap-python dap-mode lsp-treemacs lsp-ivy lsp-ui elm-mode org-roam dracula-theme yasnippet range rustic mm-util evil-org-agenda doct elpher cider mu4e evil-snipe evil magit projectile counsel ivy all-the-icons eshell-toggle eglot git-gutter openwith all-the-icons-dired drag-stuff evil-org smartparens python-mode dired-hide-dotfiles dired-single company-box company evil-nerd-commenter typescript-mode lsp-mode visual-fill-column neotree treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil treemacs magit-todos toc-org which-key use-package undo-fu smex rotate rainbow-delimiters org-bullets ivy-rich helpful general format-all flycheck evil-magit evil-collection doom-themes doom-modeline dashboard counsel-projectile))
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
