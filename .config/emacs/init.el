;; generated from config.org

;; `file-name-handler-alist' is consulted on every `require', `load' and various
;; path/io functions. You get a minor speed up by nooping this. However, this
;; may cause problems on builds of Emacs where its site lisp files aren't
;; byte-compiled and we're forced to load the *.el.gz files (e.g. on Alpine)
(unless (daemonp)
    (defvar doom--initial-file-name-handler-alist file-name-handler-alist)
    (setq file-name-handler-alist nil)
    ;; Restore `file-name-handler-alist' later, because it is needed for handling
    ;; encrypted or compressed files, among other things.
    (defun doom-reset-file-handler-alist-h ()
        ;; Re-add rather than `setq', because changes to `file-name-handler-alist'
        ;; since startup ought to be preserved.
        (dolist (handler file-name-handler-alist)
            (add-to-list 'doom--initial-file-name-handler-alist handler))
        (setq file-name-handler-alist doom--initial-file-name-handler-alist))
    (add-hook 'emacs-startup-hook #'doom-reset-file-handler-alist-h)
    (add-hook 'after-init-hook '(lambda ()
                                    ;; restore after startup
                                    (setq gc-cons-threshold 16777216
                                        gc-cons-percentage 0.1))))

;; Ensure Doom is running out of this file's directory
(setq user-emacs-directory (file-truename (file-name-directory load-file-name)))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package emacs
    :init
    (setq inhibit-startup-screen t
          initial-scratch-message nil
          sentence-end-double-space nil
          ring-bell-function 'ignore
          frame-resize-pixelwise t)

    ;; personal information
    (setq user-full-name "saucoide"
          user-mail-address "saucoide@gmail.com")

	;; Auth sources, this us used for authentication
	;; including mu4e, etc.
    (setq auth-sources '(password-store))
    (auth-source-pass-enable)

    (setq read-process-output-max (* 1024 1024))

    (defalias 'yes-or-no-p 'y-or-n-p)    ; Answer with y/n instead of yes/no

    ;; default to utf-8 for all the things
    (set-charset-priority 'unicode)
    (setq locale-coding-system 'utf-8
          coding-system-for-read 'utf-8
          coding-system-for-write 'utf-8)
    (set-terminal-coding-system 'utf-8)
    (set-keyboard-coding-system 'utf-8)
    (set-selection-coding-system 'utf-8)
    (prefer-coding-system 'utf-8)
    (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
    (set-language-environment "UTF-8")     ; I like utf-8 as my default

    ;; write over selected text on input... like all modern editors do
    (delete-selection-mode t)

    ;; don't want ESC as a modifier
    (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

    (setq-default delete-by-moving-to-trash t          ; Delete to trash
                  major-mode 'org-mode)                ; Org mode by default on new buffers

    (setq undo-limit 60000000              ; Raise undo limit to 60mb
          evil-want-fine-undo t)           ; A more granular undo

    (setq-default indent-tabs-mode nil)      ; use spaces
    (setq-default tab-width 4)             ; 4 spaces is the right tab width
    (setq-default fill-column  90))        ; line length

(use-package emacs
    :init
    (setq backup-directory-alist '(("." . "~/.config/emacs/backups")))
    ;; or to stop emacs from making them altogether
    (setq make-backup-files nil
          auto-save-default nil
          create-lockfiles nil))

;; emacs custom-file to save customizations
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file t)

;; custom modules with convenience functions i use
(with-eval-after-load (load-file "~/.config/emacs/custom/general_functions.el"))
(with-eval-after-load 'mu4e (load-file "~/.config/emacs/custom/mu4e_functions.el"))

(use-package gcmh
    :demand
    :config
    (gcmh-mode 1))

(setq my/is-windows (eq system-type 'windows-nt))

;; for eshell mostly
(setenv "PATH"
	(concat ":~/.cargo/bin"
            ":~/.poetry/bin"
            ":~/.config/emacs/bin"
            ":~/.local/bin"
            "~/.local/share/coursier/bin"
            ":/usr/local/bin"
            ":/usr/bin"
            ":/bin"
            ":/usr/local/sbin"
            ":/usr/lib/jvm/default/bin"))

;; for emacs to find binaries
(setq exec-path
	  (append exec-path '("~/.cargo/bin"
						  "~/.poetry/bin"
						  "~/.config/emacs/bin"
						  "~/.local/bin"
						  "~/.local/share/coursier/bin"
						  "/usr/local/bin"
						  "/usr/bin"
						  "/bin"
						  "/usr/local/sbin"
						  "/usr/lib/jvm/default/bin")))

(use-package evil
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-C-i-jump nil)
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state))

(use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

 ;; using undo-fu to get redo functionality
(use-package undo-fu
    :config
    (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
    (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))

(use-package evil-org
    :hook (org-mode . evil-org-mode))

(use-package evil-snipe
    :after evil
    :demand
    :config
    (evil-snipe-mode +1)
    (evil-snipe-override-mode +1)
    (setq evil-snipe-scope 'buffer))

;; (evil-define-key 'normal dired-mode-map
;;     (kbd "zh") 'dired-hide-dotfiles-mode
;;     (kbd "l") 'dired-find-file
;;     (kbd "<right>") 'dired-find-file
;;     (kbd "h") 'dired-up-directory
;;     (kbd "<left>") 'dired-up-directory)

(use-package emacs
    :init
    (scroll-bar-mode -1)		; disable visible scrollbar
    (tool-bar-mode -1)		; disable toolbar
    (tooltip-mode -1)	        ; disable tooltips
    (set-fringe-mode 3) 		; margins
    (menu-bar-mode -1)) 		; disable menu bar

(use-package emacs
    :config
    (if my/is-windows
        (progn
            ;; Windows
            (set-face-attribute 'default nil :font "Consolas" :height 100) ; default font
            (set-face-attribute 'fixed-pitch nil :font "Consolas" :height 100) ; monospace font 
            (set-face-attribute 'variable-pitch nil :font "Consolas" :height 100)) ; variable width font
        ;; Linux
        (set-face-attribute 'default nil :font "Source Code Pro" :height 100) ; default font
        (set-face-attribute 'fixed-pitch nil :font "Source Code Pro" :height 100) ; monospace font
        (set-face-attribute 'variable-pitch nil :font "Source Code Pro" :height 100))) ; variable width font

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 't)
(setq truncate-lines nil)            ; truncate lines

;; modes to skip
(dolist (mode '(term-mode-hook
                eshell-mode-hook
                image-mode-hook
                pdf-view-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
    :hook
    (prog-mode . rainbow-delimiters-mode))

(use-package doom-themes
    :init
    (load-theme 'doom-one t))
    ;; (load-theme 'doom-material t))  
    ;; (load-theme 'doom-palenight t))  
    ;; (load-theme 'doom-dracula t))

;; all the icons is needed for doom-modeline
;; run M-x all-the-icons-install-fonts 
;; in WINDOWS that will only download the fonts, and then you need to install them manually
(use-package all-the-icons)

;; doom-modeline to replace the standard modeline
(use-package doom-modeline
    :config
    (if my/is-windows
      (setq doom-modeline-icon nil)
      (setq doom-modeline-unicode-fallback t)
            doom-modeline-icon t)
    :init
    (column-number-mode)
    (doom-modeline-mode 1))

(use-package dashboard
    :config
    (dashboard-setup-startup-hook)
    ;; :requires page-break-lines
    :config
    (setq dashboard-startup-banner "~/.config/emacs/logo.png")
    ;; (setq dashboard-startup-banner "~/.config/emacs/logo.txt")
	;; (setq dashboard-center-content t)
    (setq dashboard-set-navigator t)
	(setq dashboard-agenda-time-string-format "%Y-%m-%d %a")
	(setq dashboard-match-agenda-entry "CATEGORY={TODO}")
	(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
	;; (setq dashboard-agenda-release-buffers t)
    (unless my/is-windows
        (setq dashboard-set-file-icons t)
        (setq dashboard-set-heading-icons t))
    ;; (setq dashboard-footer-icon nil)
    (setq dashboard-items '((recents  . 5)
                            (bookmarks . 5)
                            (projects . 5)
                            (agenda . 10))))

;; Set dashboard to be the initial buffer that opens when using emacsclient
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(setq frame-title-format
      '(""
        (:eval "%b")
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " * %s" " - %s") project-name))))))

;; show icons on dired
(use-package all-the-icons-dired
    :hook (dired-mode . all-the-icons-dired-mode))

;; dired-single forces a single dired buffer instead of a new one everytime
(use-package dired-single)
(use-package dired-hide-dotfiles)

(defun my/open-externally ()
  (interactive)
  (let ((filename (dired-get-filename))
        (text-types '("application/vnd.lotus-organizer"
                      "text/plain"
                      "text/markdown")))
     (if (or (file-directory-p filename)
             (member (mailcap-file-name-to-mime-type filename) text-types))
        (dired-single-buffer)
        (dwim-shell-commands-open-externally))))


(use-package dired
    :ensure nil
    ;; :commands (dired dired-jump)
    :config
    (setq dired-listing-switches "-algho --group-directories-first --time-style \"+%Y-%m-%d %H:%M\"")
    (setq dired-dwim-target t)
    (all-the-icons-dired-mode 1)
    (dired-hide-dotfiles-mode 1)
    (evil-define-key 'normal dired-mode-map
    (kbd "H") 'dired-hide-dotfiles-mode
    ;; (kbd "RET") 'dwim-shell-commands-open-externally
    (kbd "RET") 'my/open-externally
    (kbd "l") 'dired-single-buffer
    (kbd "<right>") 'dired-single-buffer
    (kbd "h") 'dired-single-up-directory
    (kbd "<left>") 'dired-single-up-directory)
    )

(defun my/dired-customizations()
  "Custom behaviours for `dired-mode'."
  (setq truncate-lines t))

(add-hook 'dired-mode-hook #'my/dired-customizations)

;; Add some colors to the output
(use-package diredfl
  :hook (dired-mode . diredfl-mode))

;; TODO
(use-package transient
  :init
   (with-eval-after-load 'transient
    (transient-bind-q-to-quit)))

(use-package which-key
    :init (which-key-mode)
    :diminish which-key-mode
    :config
    (setq which-key-idle-delay 0.3))

(use-package counsel
    :bind (("M-x" . counsel-M-x)
           ("C-x b" . counsel-ibuffer)
           ("C-x X-f" . counsel-find-file)
           :map minibuffer-local-map
                ("C-r" . 'counsel-minibuffer-history))
    :config
    (setq ivy-initial-inputs-alist nil))

(use-package ivy
    :diminish
    :bind (("C-s" . swiper)
        :map ivy-minibuffer-map
        ("TAB" . ivy-alt-done)
        ("C-l" . ivy-alt-done)
        ("C-j" . ivy-next-line)
        ("C-k" . ivy-previous-line)
        :map ivy-switch-buffer-map
        ("C-k" . ivy-previous-line)
        ("C-l" . ivy-done)
        ("C-d" . ivy-switch-buffer-kill)
        :map ivy-reverse-i-search-map
        ("C-k" . ivy-previous-line)
        ("C-d" . ivy-reverse-i-search-kill))
    :config
    (ivy-mode 1))

(use-package ivy-rich
    :init
    (ivy-rich-mode 1))

(use-package smex
    :config (smex-initialize))

(use-package helpful
    :after evil
    :init
    (setq evil-lookup-func #'helpful-at-point)
    :custom
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
    :bind
    ([remap describe-function] . counsel-describe-function)
    ([remap describe-command] . helpful-command)
    ([remap describe-variable] . counsel-describe-variable)
    ([remap describe-key] . helpful-key))

(use-package projectile
    :diminish projecttile-mode
    :config (projectile-mode)
    :bind-keymap
    ("C-c p" . projectile-command-map)
    ;; ("SPC P" . projectile-command-map))
   :init
   (if my/is-windows
       (when (file-directory-p "C:\\Users\\IEUser\\projects")
           (setq projectile-project-search-path '("C:\\Users\\IEUser\\projects")))
       (when (file-directory-p "~/projects")
           (setq projectile-project-search-path '("~/projects"))))
   ;; action that triggers on switching projects (eg open dired)
   (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
    :config (counsel-projectile-mode))

(use-package neotree
    :config
    (setq neo-smart-open t)
    (setq projectile-switch-project-action 'neotree-projectile-action))

(use-package dwim-shell-command
  :config
   (require 'dwim-shell-commands))

(use-package pdf-tools)

(use-package cider
    :mode "\\.clj[sc]?\\'"
    :config
    (evil-collection-cider-setup))

(use-package scala-mode
  :interpreter ("scala" . scala-mode))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false")))

(use-package lsp-metals)

(use-package rustic
  :config
  (setq rustic-lsp-client 'eglot)
  (setq rustic-format-on-save t))

(use-package elm-mode
  :hook
  (elm-mode . elm-indent-simple-mode)
  (elm-mode . elm-format-on-save-mode))

;;(use-package flycheck
;;  :defer t
;;  :hook (eglot-mode . flycheck-mode))

;; on windows dont enable it globally
;;(unless my/is-windows
;;  (global-flycheck-mode))

(use-package format-all)

(use-package evil-nerd-commenter
    :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(if my/is-windows
    (progn
        (setq exec-path (add-to-list 'exec-path "C:\Program Files\Git\bin"))
        (setenv "PATH" (concat "C:\Program Files\Git\bin;" (getenv "PATH")))))

(use-package magit
  ;; commands that make magit load
    :defer t
    :commands (magit-status magit-get-current-branch))

;; (use-package forge)

;; TODO doesnt work well with org mode buffers for me
 (use-package git-gutter
     :if (not my/is-windows)
     :defer t
     :hook ((text-mode . git-gutter-mode)
             (prog-mode . git-gutter-mode)))

(use-package magit-todos
  :if (not my/is-windows)
  :hook (magit-mode . magit-todos-mode)
  :init
  (unless (executable-find "nice")
    (setq magit-todos-nice nil)))

;; TODO
  ;; (use-package eglot
  ;;   :hook (scala-mode . eglot-ensure))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (elm-mode . lsp)
         (python-mode . lsp)
         (clojure-mode . lsp)
         (rustic-mode . lsp)
         (scala-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-python)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(use-package company
    :init
    (add-hook 'after-init-hook 'global-company-mode)
    :bind (:map company-active-map
           ("<tab>" . company-complete-common-or-cycle)) ; tab completes the selection instead next
           ;; ("<tab>" . company-complete-selection)) ; tab completes the selection instead next
    :custom
    (company-minimum-prefix-lenght 2)
    (company-idle-delay 0.3)
    (company-show-numbers t))

;; a little bit better interface
(use-package company-box
  :hook (company-mode . company-box-mode)
  :config
    (setq company-box-show-single-candidate t
          company-box-backends-colors nil
          company-box-max-candidates 50
          company-box-icons-alist 'company-box-icons-all-the-icons
          company-box-icons-all-the-icons
          (let ((all-the-icons-scale-factor 0.8))
            `((Unknown       . ,(all-the-icons-material "find_in_page"             :face 'all-the-icons-purple))
              (Text          . ,(all-the-icons-material "text_fields"              :face 'all-the-icons-green))
              (Method        . ,(all-the-icons-material "functions"                :face 'all-the-icons-red))
              (Function      . ,(all-the-icons-material "functions"                :face 'all-the-icons-red))
              (Constructor   . ,(all-the-icons-material "functions"                :face 'all-the-icons-red))
              (Field         . ,(all-the-icons-material "functions"                :face 'all-the-icons-red))
              (Variable      . ,(all-the-icons-material "adjust"                   :face 'all-the-icons-blue))
              (Class         . ,(all-the-icons-material "class"                    :face 'all-the-icons-red))
              (Interface     . ,(all-the-icons-material "settings_input_component" :face 'all-the-icons-red))
              (Module        . ,(all-the-icons-material "view_module"              :face 'all-the-icons-red))
              (Property      . ,(all-the-icons-material "settings"                 :face 'all-the-icons-red))
              (Unit          . ,(all-the-icons-material "straighten"               :face 'all-the-icons-red))
              (Value         . ,(all-the-icons-material "filter_1"                 :face 'all-the-icons-red))
              (Enum          . ,(all-the-icons-material "plus_one"                 :face 'all-the-icons-red))
              (Keyword       . ,(all-the-icons-material "filter_center_focus"      :face 'all-the-icons-red))
              (Snippet       . ,(all-the-icons-material "short_text"               :face 'all-the-icons-red))
              (Color         . ,(all-the-icons-material "color_lens"               :face 'all-the-icons-red))
              (File          . ,(all-the-icons-material "insert_drive_file"        :face 'all-the-icons-red))
              (Reference     . ,(all-the-icons-material "collections_bookmark"     :face 'all-the-icons-red))
              (Folder        . ,(all-the-icons-material "folder"                   :face 'all-the-icons-red))
              (EnumMember    . ,(all-the-icons-material "people"                   :face 'all-the-icons-red))
              (Constant      . ,(all-the-icons-material "pause_circle_filled"      :face 'all-the-icons-red))
              (Struct        . ,(all-the-icons-material "streetview"               :face 'all-the-icons-red))
              (Event         . ,(all-the-icons-material "event"                    :face 'all-the-icons-red))
              (Operator      . ,(all-the-icons-material "control_point"            :face 'all-the-icons-red))
              (TypeParameter . ,(all-the-icons-material "class"                    :face 'all-the-icons-red))
              (Template      . ,(all-the-icons-material "short_text"               :face 'all-the-icons-green))
              (ElispFunction . ,(all-the-icons-material "functions"                :face 'all-the-icons-red))
              (ElispVariable . ,(all-the-icons-material "check_circle"             :face 'all-the-icons-blue))
              (ElispFeature  . ,(all-the-icons-material "stars"                    :face 'all-the-icons-orange))
              (ElispFace     . ,(all-the-icons-material "format_paint"             :face 'all-the-icons-pink))))))

(use-package smartparens
    :config 
    (smartparens-global-mode t))

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/yasnippets"))
  (yas-global-mode 1))

(use-package vterm)

(defun my/org-mode-setup()
    (org-indent-mode)
    (visual-line-mode 1))

(use-package org
    :defer t
    :hook (org-mode . my/org-mode-setup)
    :config
    (setq org-ellipsis " ..."
          org-src-tab-acts-natively t
          org-edit-src-content-indentation 0   ;; src blocks won't get a min indentation automatically
          org-startup-folder 'content
          org-directory "~/org/"
          org-agenda-files (list org-directory)
		  org-default-notes-file "~/org/notes.org"
          org-return-follows-link t))

(use-package evil-org
  :after org
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode)
		 (evil-org-mode . (lambda ()
                            (evil-org-set-key-theme '(navigation
                                                      todo
                                                      insert
                                                      textobjects
                                                      additional)))))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package doct
  :commands (doct))

(setq org-capture-templates
	  (doct '(("Todo" :keys "t"
			   :icon ("checklist" :set "octicon" :color "green")
               :file (lambda () (concat org-directory "todo.org"))
               :prepend t
               :template ("* TODO %^{Description}"
                          ":PROPERTIES:"
                          ":CATEGORY: TODO"
                          ":CREATED: %U"
                          ":END:"
                          "%?"))
	         ("Notes" :keys "n"
			   :icon ("sticky-note-o" :set "octicon" :color "blue")
               :file (lambda () (concat org-directory "notes.org"))
               :prepend t
               :template ("* %^{Description}"
                          ":PROPERTIES:"
                          ":CATEGORY: NOTE"
                          ":CREATED: %U"
                          ":END:"
                          "%?")))))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◐" "○" "●" "✖" "✚")))

(defun my/org-mode-visual-fill ()
    (setq visual-fill-column-width 100)
    (visual-fill-column-mode 1))

(defun my/org-mode-center-text ()
 "toggle centering text in buffer"
    (interactive)
    (setq visual-fill-column-center-text (not visual-fill-column-center-text)))

(use-package visual-fill-column 
    :hook (org-mode . my/org-mode-visual-fill))

(org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (clojure . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(use-package toc-org
    :hook (org-mode . toc-org-mode))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/notes/roam/")
  (org-roam-completion-everywhere t)
  (org-roam-completion-system 'default)
  :config
  (org-roam-setup))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

(use-package mu4e
  :ensure nil  ;; tries to download from melpa otherwise, and fails
  :config
  (setq mu4e-attachment-dir "~/downloads")
  (evil-define-key 'normal mu4e-view-mode-map
    (kbd "p") 'my/mu4e-save-attachments-dired)
  
  (add-hook 'mu4e-view-mode-hook #'visual-line-mode)
  ;; Load org-mode integration
  ;; (require 'org-mu4e)

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; I want to refile to also mark the emails as read
  (setq mu4e-view-auto-mark-as-read nil)
  (add-to-list 'mu4e-marks
    '(refile
        :char ("r" . "▶")
        :prompt "refile"
        :dyn-target (lambda (target msg) (mu4e-get-refile-folder msg))
        :action (lambda (docid msg target)
                    (mu4e--server-move docid (mu4e--mark-check-target target) "+S-u-N"))))


  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval 600)
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/mail")

  ;; I find it very annoying when the reply to a thread un-archives all other emails
  (setq mu4e-headers-include-related nil)

  ;; US date format is no good
  (setq mu4e-headers-date-format "%Y-%m-%d")

  (add-to-list 'mu4e-view-actions '("View in browser" . mu4e-action-view-in-browser))

  ;; Prefer always the plaintext version if it exists
  (with-eval-after-load "mm-decode"
  (add-to-list 'mm-discouraged-alternatives "text/html")
  (add-to-list 'mm-discouraged-alternatives "text/richtext"))
  
  ;; When html emails are very large compared to the text one, mu4e blocks
  ;; toggling between plaintext and html which is annoying
  ;; (setq mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum)

  ;; Html messages in a dark theme are hard to read
  (setq shr-color-visible-luminance-min 80)

  ;; Account settings
  (setq user-full-name "saucoide")
  (setq user-mail-address "saucoide@gmail.com")

  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/ReadInbox")
  (setq mu4e-trash-folder  "/[Gmail]/Bin")

  ;; For sending emails
  (setq message-send-mail-function 'smtpmail-send-it
        message-kill-buffer-on-exit t)
  (setq smtpmail-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-user "saucoide@gmail.com")
  (setq smtpmail-smtp-service 587)
  (setq smtpmail-stream-type 'starttls)

  ;; Display Settings
  (setq mu4e-view-show-addresses t  ;; Show full email addreses for contacts
        mu4e-view-show-images t
        mu4e-view-image-max-width 800
        mu4e-headers-fields
          '((:from . 25)
            (:human-date . 12)
            (:flags . 4)
            (:subject)))

  ;; Use fancy icons
  (setq mu4e-use-fancy-chars t
          mu4e-headers-draft-mark '("D" . "")
          mu4e-headers-flagged-mark '("F" . "")
          mu4e-headers-new-mark '("N" . "!")
          mu4e-headers-passed-mark '("P" . "")
          mu4e-headers-replied-mark '("R" . "")
          mu4e-headers-seen-mark '("S" . ".")
          mu4e-headers-trashed-mark '("T" . "")
          mu4e-headers-encrypted-mark '("x" . "")
          mu4e-headers-signed-mark '("s" . "")
          mu4e-headers-unread-mark '("u" . "✉")
          mu4e-headers-attach-mark '("a" . ""))
  ;; (setq mu4e-headers-unread-mark    '("u" . "📩 "))
  ;; (setq mu4e-headers-draft-mark     '("D" . "🚧 "))
  ;; (setq mu4e-headers-flagged-mark   '("F" . "🚩 "))
  ;; (setq mu4e-headers-new-mark       '("N" . "✨ "))
  ;; (setq mu4e-headers-passed-mark    '("P" . "↪ "))
  ;; (setq mu4e-headers-replied-mark   '("R" . "↩ "))
  ;; (setq mu4e-headers-seen-mark      '("S" . " "))
  ;; (setq mu4e-headers-trashed-mark   '("T" . "🗑️"))
  ;; (setq mu4e-headers-attach-mark    '("a" . "📎 "))
  ;; (setq mu4e-headers-encrypted-mark '("x" . "🔑 "))
  ;; (setq mu4e-headers-signed-mark    '("s" . "🖊 "))


  
  ;; Shortcuts
  (setq mu4e-maildir-shortcuts
    '((:maildir "/Inbox"    :key ?i)
      (:maildir "/[Gmail]/Sent Mail" :key ?s)
      (:maildir "/[Gmail]/Bin"     :key ?t)
      (:maildir "/[Gmail]/Drafts"    :key ?d)))

  ;; Bookmarks
  (setq mu4e-bookmarks
    '(
     ;; (:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?i)
     ;; (:name "Today's messages" :query "date:today..now AND NOT flag:trashed" :key ?t)
      (:name "Inbox" :query "maildir:/Inbox" :key ?b)
      (:name "ReadInbox" :query "maildir:/ReadInbox" :key ?r)
     ;; (:name "Sent" :query "maildir:/Sent Mail" :key ?s)
     ;; (:name "All" :query "maildir:/All Mail" :key ?a)
     ;; (:name "with Attachments" :query "flag:attach" :key ?a)
     ;; (:name "Last 7 days" :query "date:7d..now AND NOT flag:trashed" :key ?w)
      )))

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; (setq mu4e-sent-messages-behavior 'delete)

;; (setq mu4e-compose-format-flowed t)

;; (setq mu4e-compose-signature "Thanks\nsauco")

(use-package general
    :config
    (general-evil-setup t)
    (general-create-definer my/leader-key-def
        :states '(normal insert visual emacs)
        :keymaps 'override
        :prefix "SPC"
        :global-prefix "C-SPC"))

(my/leader-key-def
    ;; actions
    "DEL" '(evil-switch-to-windows-last-buffer :which-key "Last buffer")
    "RET" '(counsel-bookmark :which-key "Bookmarks")
    "SPC" '(counsel-find-file :which-key "Find file")
    "<home>" '(dashboard-refresh-buffer :which-key "Switch to Dashboard")
    "'" '(ivy-resume :which-key "Resume last search")
    "," '(projectile-switch-to-buffer :which-key "Switch project buffer")
    "." '(counsel-find-file :which-key "Find file")
    ":" '(counsel-M-x :which-key "M-x")
    ";" '(eval-expression :which-key "Eval expression")
    "<" '(counsel-switch-buffer :which-key "Switch buffer (all)")
    "x" '(my/popup-scratch-buffer :which-key "Pop scratch buffer")
    "X" '(org-capture :which-key "Org Capture"))

(my/leader-key-def
    "a"  '(:ignore t :which-key "Org Agenda")
    "aa" '(org-agenda :which-key "Agenda")
    "at" '(org-todo-list :which-key "Todo list")
    "am" '(org-tags-view :which-key "Tags view")
    "av" '(org-search-view :which-key "Search view"))

(my/leader-key-def
    "b"  '(:ignore t :which-key "buffer")
    "bn" '(next-buffer :which-key "Next buffer")
    "bp" '(next-buffer :which-key "Previous buffer")
    "b>" '(next-buffer :which-key "Next buffer")
    "b<" '(previous-buffer :which-key "Previous buffer")
    "bb" '(projectile-switch-to-buffer :which-key "Switch project buffer")
    "bi" '(ibuffer :which-key "ibuffer")
    "bc" '(kill-current-buffer :which-key "Kill buffer")
    "bd" '(kill-current-buffer :which-key "Kill buffer")
    "bk" '(kill-current-buffer :which-key "Kill buffer")
    "bl" '(evil-switch-to-windows-last-buffer :which-key "Switch to last buffer")
    "bm" '(bookmark-set :which-key "Mark as bookmark")
    "bs" '(basic-save-buffer :which-key "Save buffer")
    ;; "u" '(:which-key "Save as root")
    "bz" '(bury-buffer :which-key "Bury buffer")
    "bm" '(bookmark-set :which-key "Mark as bookmark")
    "bM" '(bookmark-delete :which-key "Delete bookmark")
    "bR" '(revert-buffer :which-key "Revert buffer")
    "bB" '(counsel-switch-buffer :which-key "Switch buffer")
    "bT" '(ivy-switch-buffer :which-key "Switch buffer")
    "bK" '(my/close-all-buffers :which-key "Kill all buffers")
    "bN" '(evil-buffer-new :which-key "New buffer"))

;; TODO bK use doom's better function

(my/leader-key-def
    "c"  '(:ignore t :which-key "code")
    "cc" '(counsel-compile :which-key "Compile")
    "cd" '(evil-goto-definition :which-key "Jump to definition")
    "cf" '(format-all-buffer :which-key "Format buffer/region")
    "cx" '(flycheck-list-errors :which-key "List errors")
    "cn" '(flycheck-next-error :which-key "Next error")
    "cw" '(delete-trailing-whitespace :which-key "Delete trailing whitespace")
    "cW" '(my/delete-trailing-newlines :which-key "Delete trailing newlines"))

(my/leader-key-def
    "e"  '(:ignore t :which-key "eval")
    "eb" '(eval-buffer :which-key "Evaluate buffer")
    "ed" '(eval-defun :which-key "Evaluate defun")
    "ee" '(eval-expression :which-key "Evaluate expression")
    "el" '(eval-last-sexp :which-key "Evaluate last sexpression")
    "er" '(eval-region :which-key "Evaluate region"))

;; from system crafters's config
(eval-when-compile (require 'cl))
(defun my/dired-in (path)
  (lexical-let ((target path))
    (lambda () (interactive) (dired target))))

(if my/is-windows
    (my/leader-key-def
         "d"   '(:ignore t :which-key "dired")
         "dd"  '(dired :which-key "Here")
         "dh"  `(,(my/dired-in "~") :which-key "Home")
         "do"  `(,(my/dired-in "P:\\org") :which-key "Org")
         "dD"  `(,(my/dired-in "%USERPROFILE%'\\Downloads") :which-key "Downloads")
         "dp"  `(,(my/dired-in "P:\\SAUCO_PROJECTS\\") :which-key "projects")
         "de"  `(,(my/dired-in "~/.config/emacs") :which-key ".config/emacs"))
   (my/leader-key-def
         "d"   '(:ignore t :which-key "dired")
         "dd"  '(dired :which-key "Here")
         "dh"  `(,(my/dired-in "~") :which-key "Home")
         "do"  `(,(my/dired-in "~/org") :which-key "Org")
         "dD"  `(,(my/dired-in "~/downloads") :which-key "Downloads")
         "dv"  `(,(my/dired-in "~/videos") :which-key "Videos")
         "d."  `(,(my/dired-in "~/dotfiles") :which-key "dotfiles")
         "de"  `(,(my/dired-in "~/.config/emacs") :which-key ".config/emacs")))

(my/leader-key-def
    "f"  '(:ignore t :which-key "files")
    "fd" '(projectile-dired :which-key "Find directory")
    "ff" '(counsel-find-file :which-key "Find file")
    "fl" '(counsel-locate :which-key "Locate file")
    "fr" '(counsel-recentf :which-key "Recent files")
    "fs" '(save-buffer :which-key "Save file")
    "fy" '(my/copy-filename-to-clipboard :which-key "Yank filename")
    "fC" '(copy-file :which-key "Copy this file")
    "fD" '(delete-file :which-key "Delete this file")
    ;; "E" '(a :which-key "Browse emacs.d")
    ;; "F" '(a :which-key "Find file from here")
    "fR" '(rename-file :which-key "Rename/Move file")
    "fS" '(write-file :which-key "Save file as...")
    ;; "U" '(a :which-key "Sudo this file")
)

(my/leader-key-def
    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status :which-key "Magit status")
    "g/" '(magit-dispatch :which-key "Magit dispatch")
    "gb" '(magit-branch-checkout :which-key "Magit switch branch")
    "gC" '(magit-clone :which-key "Magit clone")
    "gD" '(magit-file-delete :which-key "Magit file delete")
    "gR" '(vc-revert :which-key "Revert file")
    "gS" '(magit-stage-file :which-key "Magit stage file")
    "gU" '(magit-unstage-file :which-key "Magit unstage file"))

(my/leader-key-def
    "h"  '(:ignore t :which-key "help")
    "hRET" '(info-emacs-manual :which-key "Emacs manual")
    "h'" '(describe-char :which-key "Describe char")
    "h." '(display-local-help :which-key "Local-help")
    "h?" '(help-for-help :which-key "Help for help")
    "ha" '(apropos :which-key "Apropos")
    "hc" '(describe-key-briefly :which-key "Describe key briefly")
    "he" '(view-echo-area-messages :which-key "View echo messages")
    "hf" '(counsel-describe-function :which-key "Describe function")
    "hi" '(info :which-key "Info")
    "hk" '(describe-key :which-key "Describe key")
    "hl" '(view-lossage :which-key "View lossage")
    "hm" '(describe-mode :which-key "Describe mode")
    "hs" '(counsel-describe-symbol :which-key "Describe symbol")
    "hq" '(help-quit :which-key "Help quit")
    "hv" '(counsel-describe-variable :which-key "Describe variable")
    "hw" '(where-is :which-key "Where is")
    "hA" '(apropos-documentation :which-key "Apropos docs")
    "hC" '(describe-coding-system :which-key "Describe coding system")
    "hF" '(counsel-describe-face :which-key "Describe face")
    "hV" '(set-variable :which-key "Set variable")
    "hH" '(help-for-help :which-key "Help for help"))

(my/leader-key-def
    "n"  '(:ignore t :which-key "notes")
    "nn" '(org-capture :which-key "Org Capture")
    "ni" '(org-roam-node-insert :which-key "org-roam-node-insert")
    "nf" '(org-roam-node-find :which-key "org-roam-node-find")
    "nl" '(org-roam-buffer-toggle :which-key "org-roam-buffer-toggle"))

(my/leader-key-def
    "o"  '(:ignore t :which-key "open")
    "o-" '(dired-jump :which-key "Dired")
    "ob" '(browse-url-of-file :which-key "Browser")
    ;o; "d" '(org :which-key "debugger")
    "of" '(make-frame :which-key "New frame")
    "om" '(mu4e :which-key "Mu4e")
    "op" '(neotree-toggle :which-key "Project sidebar")
    ;o; "r" '(org :which-key "REPL")
    "oe" '(eshell-toggle :which-key "eshell"))
    ;o; "t" '(org :which-key "Terminal")

(my/leader-key-def
    "p"  '(:ignore t :which-key "projects")
    "p!" '(projectile-run-shell-command-in-root :which-key "Run cmd in project root")
    "p." '(projectile-recentf :which-key "Recent files in project")
    "pa" '(projectile-add-known-project :which-key "Add project")
    "pb" '(counsel-projectile-switch-to-buffer :which-key "Switch to project buffer")
    "pd" '(projectile-dired :which-key "dired in project")
    "pf" '(counsel-projectile-find-file :which-key "Find file in project")
    "pk" '(projectile-kill-buffers :which-key "Kill project buffers")
    "pp" '(counsel-projectile-switch-project :which-key "Switch project") 
    "pr" '(projectile-recentf :which-key "Recent files in project")
    "ps" '(projectile-save-project-buffers :which-key "Save project files")
    "pt" '(magit-todos-list :which-key "Project TODOs")
    "pD" '(projectile-remove-known-project :which-key "Delete project")
    "pR" '(projectile-run-project :which-key "Run project"))

(my/leader-key-def
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "Quit"))

(my/leader-key-def
    "s"  '(:ignore t :which-key "search")
    "ss" '(swiper :which-key "Swiper")
    ;; "sr" '(swiper :which-key "ripgrep")

    )

 ;; TODO add bindings to search in project, etc

(my/leader-key-def
    "t"  '(:ignore t :which-key "toggle")
    "tf" '(flycheck-mode :which-key "Flycheck")
    "tl" '(doom/toggle-line-numbers :which-key "Line numbers")
    "tn" '(neotree-toggle :which-key "Neotree")
    "tt" '(toggle-truncate-lines :which-key "Truncate lines")
    "tI" '(doom/toggle-indent-style :which-key "Indentation"))

(use-package rotate)

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(my/leader-key-def
    "w"  '(:ignore t :which-key "window")
    "w+"  '(evil-window-increase-height :which-key "increase height")
    "w-"  '(evil-window-decrease-height :which-key "decrease height")
    "w>"  '(evil-window-increase-width :which-key "increase width")
    "w<"  '(evil-window-decrease-width :which-key "decrease width")
    "ww"  '(evil-window-next :which-key "next")
    "wW"  '(evil-window-prev :which-key "prev")
    "w_"  '(evil-window-set-height :which-key "set height")
    "wc"  '(evil-window-delete :which-key "delete")
    "wh"  '(evil-window-left :which-key "cursor left")
    "wj"  '(evil-window-down :which-key "cursor down")
    "wk"  '(evil-window-up :which-key "cursor up")
    "wl"  '(evil-window-right :which-key "cursor right")
    "wn"  '(evil-window-new :which-key "new")
    "wo"  '(delete-other-windows :which-key "delete others")
    "wq"  '(evil-quit- :which-key "quit")
    "ws"  '(evil-window-split :which-key "horizontal split")
    "wv"  '(evil-window-vsplit :which-key "vertical split")
    "ww"  '(evil-window-next :which-key "next")
    "w|"  '(evil-window-set-width :which-key "set width")
    "wp"  '(evil-window-prev :which-key "prev")
    "wSPC" '(rotate-layout :which-key "rotate layout")
    "wr" '(rotate-window :which-key "rotate windows")
    "w <up>" '(evil-window-up :which-key "cursor up")
    "w <down>" '(evil-window-down :which-key "cursor down")
    "w <left>" '(evil-window-left :which-key "cursor left")
    "w <right>" '(evil-window-right :which-key "cursor right")
    "w C-<up>" '(windmove-swap-states-up :which-key "move window up")
    "w C-<down>" '(windmove-swap-states-down :which-key "move window down")
    "w C-<left>" '(windmove-swap-states-left :which-key "move window left")
    "w C-<right>" '(windmove-swap-states-right :which-key "move window right"))

(use-package winner
    :after evil
    :config
    (winner-mode)
    (my/leader-key-def
        "<left>" '(winner-undo :which-key "winner undo")
        "<right>" '(winner-redo :which-key "winner redo")))

(general-define-key    
    :states 'normal
    "?" 'which-key-show-major-mode)

(general-define-key
    :states '(normal insert visual)
    "C-s" 'swiper-isearch)

(general-define-key
    :states '(normal visual)
    "/" 'swiper-isearch)

(use-package drag-stuff)
(drag-stuff-global-mode 1)

(general-define-key
    :states 'normal
    :keymaps 'org-mode-map
    "RET" '+org/dwim-at-point)

(defun my/org-babel-tangle-config ()
    (when (string-equal (file-name-directory (buffer-file-name))
              (expand-file-name user-emacs-directory))
          ;; Dynamic scoping to the rescue
          (let ((org-confirm-babel-evaluate nil))
    (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config)))
