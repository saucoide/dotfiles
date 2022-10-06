
;;; Code:
(defvar mu4e-bulk-saved-attachments-dir mu4e-attachment-dir)

(defun my/mu4e-save-attachments-dired (&optional destination)
  "Save all attachments and open a dired buffer.

DESTINATION optional argument to specify download location

Save all MIME parts from current mu4e gnus view buffer.
and open a dired buffer on the saved location"
  ;; Copied from mu4e-view-save-attachments
  (interactive "P")
  (cl-assert (and (eq major-mode 'mu4e-view-mode)
                  (derived-mode-p 'gnus-article-mode)))
  ;; get message info
  (let* ((msg (mu4e-message-at-point))
         (subject (my/mu4e-clean-subject (mu4e-message-field msg :subject)))
         (output-dir (concat mu4e-bulk-saved-attachments-dir "/" subject))
	     (mime-parts (mu4e~view-gather-mime-parts))
         (handles '())
         (files '())
         dir)

    ;; create destination directory
    (mkdir output-dir t)
    ;; get filenames & handles for all attachments
    (dolist (part mime-parts)
      (let ((filename (or
		               (cdr (assoc 'filename (assoc "attachment" (cdr part))))
                       (seq-find #'stringp
                                 (mapcar (lambda (item) (cdr (assoc 'name item)))
                                         (seq-filter 'listp (cdr part)))))))
        (when filename
          (push `(,filename . ,(cdr part)) handles)
          (push filename files))))
    ;; process the list of files
    (if files
        (progn
          ;; set destination dir
          (setq dir
		        (if destination
                    (read-directory-name "Save to directory: ")
                  output-dir))
          ;; save files
          (cl-loop for (file . handle) in handles
                   when (member file files)
                   do (mm-save-part-to-file handle
                                            (my/mu4e-next-free-filename
                                             (expand-file-name file dir))))
          ;; launch dired
          (dired dir)
          (revert-buffer)
          )
      (mu4e-message "No attached files found"))))

(defun my/mu4e-next-free-filename (file)
  "Return name of next unique 'free' FILE.
If /tmp/foo.txt and /tmp/foo-1.txt exist, when this is called
with /tmp/foo.txt, return /tmp/foo-2.txt."
  ;; base case is easy; does file exist already?
  (if (not  (file-exists-p file))
      file
    ;; othwerwise need to iterate  until we dont find a file.
    (let ((prefix (file-name-sans-extension file))
	      (suffix (file-name-extension file))
	      (looking t)
	      (n 0)
	      (filename)
	      )
      (while looking
	    (setq n (1+ n))
	    (setq filename (concat prefix "-" (number-to-string n) "." suffix))
	    (setq looking (file-exists-p filename)))
      filename
      )))

(defun my/mu4e-clean-subject (sub)
  (replace-regexp-in-string
   "[^A-Z0-9]+"
   "-"
   (downcase sub)))

;;;
