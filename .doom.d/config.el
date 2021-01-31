(setq undo-limit 80000000         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t)       ; By default while in insert all changes are one big blob. Be more granular

(map! :leader
      :desc "Dired"
      "d d" #'dired
      :leader
      :desc "Dired jump to current"
      "d j" #'dired-jump
      (:after dired
        (:map dired-mode-map
         :leader
         :desc "Peep-dired image previews"
         "d p" #'peep-dired
         :leader
         :desc "Dired view file"
         "d v" #'dired-view-file)))
;; Make 'h' and 'l' go back and forward in dired. Much faster to navigate the directory structure!
(evil-define-key 'normal dired-mode-map
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
;; If peep-dired is enabled, you will get image previews as you go up/down with 'j' and 'k'
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(setq doom-theme 'doom-palenight)
(map! :leader
      :desc "Load new theme"
      "h t" #'counsel-load-theme)

(map! :leader
      :desc "Evaluate elisp in buffer"
      "e b" #'eval-buffer
      :leader
      :desc "Evaluate defun"
      "e d" #'eval-defun
      :leader
      :desc "Evaluate elisp expression"
      "e e" #'eval-expression
      :leader
      :desc "Evaluate last sexpression"
      "e l" #'eval-last-sexp
      :leader
      :desc "Evaluate elisp in region"
      "e r" #'eval-region)

;;(setq doom-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 15)
;;      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 15)
;;      doom-big-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 24))
;;(after! doom-themes
;;  (setq doom-themes-enable-bold t
;;        doom-themes-enable-italic t))
;;(custom-set-faces!
;;  '(font-lock-comment-face :slant italic)
;;  '(font-lock-keyword-face :slant italic))

(require 'ivy-posframe)
(setq ivy-posframe-display-functions-alist
      '((swiper                     . ivy-posframe-display-at-point)
        (complete-symbol            . ivy-posframe-display-at-point)
        (counsel-M-x                . ivy-display-function-fallback)
        (counsel-esh-history        . ivy-posframe-display-at-window-center)
        (counsel-describe-function  . ivy-display-function-fallback)
        (counsel-describe-variable  . ivy-display-function-fallback)
        (counsel-find-file          . ivy-display-function-fallback)
        (counsel-recentf            . ivy-display-function-fallback)
        (counsel-register           . ivy-posframe-display-at-frame-bottom-window-center)
        (dmenu                      . ivy-posframe-display-at-frame-top-center)
        (nil                        . ivy-posframe-display))
      ivy-posframe-height-alist
      '((swiper . 20)
        (dmenu . 20)
        (t . 10)))
(ivy-posframe-mode 1) ; 1 enables posframe-mode, 0 disables it.

(map! :leader
      :desc "Ivy push view"
      "v p" #'ivy-push-view
      :leader
      :desc "Ivy switch view"
      "v s" #'ivy-switch-view)

(setq display-line-numbers-type t)
(map! :leader
      :desc "Toggle truncate lines"
      "t t" #'toggle-truncate-lines)

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer"
      "t n" #'neotree-toggle)

(after! org
  (require 'org-bullets)  ; Nicer bullets in org-mode
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-directory "~/org/")
;;        org-agenda-files '("~/org/agenda.org")
;;        org-default-notes-file (expand-file-name "notes.org" org-directory)
;;        )
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . nil)
      (python . t)
      (sh . t)
      (sqlite . t)))
 )

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed

  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-view-auto-mark-as-read nil)


  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval 600)
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/mail/gmail")

  ;; I find it very annoying when the reply to a thread un-archives all other emails
  (setq mu4e-headers-include-related nil)

  ;; US date format is no good
  (setq mu4e-headers-date-format "%Y/%m/%d")

  ;; When html emails are very large compared to the text one, mu4e blocks
  ;; toggling between plaintext and html which is annoying
  (setq mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum)

  (add-hook 'mu4e-view-mode-hook #'visual-line-mode)
 ;; (setq mu4e-view-use-gnus t)


  ;; Account settings
  (setq user-full-name "saucoide")
  (setq user-mail-address "saucoide@gmail.com")

  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder  "/[Gmail]/Bin")

  ;; For sending emails
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq smtpmail-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-user "saucoide@gmail.com")
  (setq smtpmail-smtp-service 587)
  (setq smtpmail-stream-type 'starttls)

  ;; Shortcuts
  (setq mu4e-maildir-shortcuts
    '((:maildir "/Inbox"    :key ?i)
      (:maildir "/ReadInbox" :key ?r)
      (:maildir "/[Gmail]/Sent Mail" :key ?s)
      (:maildir "/[Gmail]/Bin"     :key ?t)
      (:maildir "/[Gmail]/Drafts"    :key ?d)
      (:maildir "/[Gmail]/All Mail"  :key ?a)))

  ;; Bookmarks
  (setq mu4e-bookmarks
    '(
     ;; (:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?i)
     ;; (:name "Today's messages" :query "date:today..now AND NOT flag:trashed" :key ?t)
      (:name "Inbox" :query "maildir:/Inbox" :key ?b)
      (:name "ReadInbox" :query "maildir:/ReadInbox" :key ?r)
     ;; (:name "with Attachments" :query "flag:attach" :key ?a)
     ;; (:name "Last 7 days" :query "date:7d..now AND NOT flag:trashed" :key ?w)
      ))

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; (setq mu4e-sent-messages-behavior 'delete)

;; (setq mu4e-compose-format-flowed t)

;; (setq mu4e-compose-signature "Thanks\nsauco")

(auth-source-pass-enable)
(setq auth-sources '(password-store))

;; (setq mail-user-agent 'mu4e-user-agent)

;; (require 'org-msg)
 (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t"
       org-msg-startup "hidestars indent inlineimages"
       org-msg-greeting-fmt ""
       org-msg-greeting-name-limit 3
       org-msg-default-alternatives '(text html)
       org-msg-convert-citation t
       org-msg-signature "


 #+begin_signature
 thanks,
 --
 sauco
 #+end_signature")
;; (org-msg-mode) ;; im leaving it disabled for now as i dont really use
