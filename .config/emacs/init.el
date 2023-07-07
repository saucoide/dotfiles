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

;; Basic UI settings
(setq inhibit-startup-screen t
      initial-scratch-message nil
      sentence-end-double-space nil
      ring-bell-function 'ignore
      frame-resize-pixelwise t)

;; Personal information
(setq user-full-name "saucoide"
      user-mail-address "saucoide@gmail.com")

;; Auth sources, this us used for authentication
;; including mu4e, etc.
(setq auth-sources '(password-store))
(auth-source-pass-enable)

;; Change how much data emacs can read in one chunk
(setq read-process-output-max (* 1024 1024))

;; Answer with y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)    

;; Default to utf-8 for everything
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(set-language-environment "UTF-8")

;; write over selected text on input... like all modern editors do
(delete-selection-mode t)

;; I don't want ESC as a modifier
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Delete to trash
(setq-default delete-by-moving-to-trash t)

;; Org mode by default on new buffers
(setq-default major-mode 'org-mode)

;; Undo settings
(setq undo-limit 60000000                   ; Raise undo limit to 60mb
      evil-want-fine-undo t)                ; A more granular undo

;; Indentation
(setq-default indent-tabs-mode nil)         ; use spaces
(setq-default tab-width 4)                  ; 4 spaces is the right tab width

;; Line length
(setq-default fill-column 79)

;; visual-line
(global-visual-line-mode -1)

;; Change the default directory to store backups
(setq backup-directory-alist '(("." . "~/.local/emacs/backups")))

;; Or just stop emacs from making them altogether
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file t)

(use-package gcmh
    :demand
    :config
    (gcmh-mode 1))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-shell-name "fish")
  (exec-path-from-shell-initialize))
;; ;; for eshell mostly
;; (setenv "PATH"
;;         (concat ":~/.cargo/bin"
;;                 ":~/.poetry/bin"
;;                 ":~/.config/emacs/bin"
;;                 ":~/.local/bin"
;;                 ":/usr/local/bin"
;;                 ":/usr/bin"
;;                 ":/bin"
;;                 ":/usr/local/sbin"
;;                 ":/usr/lib/jvm/default/bin"
;;                 ":$HOME/google-cloud-sdk/bin"))

;; ;; for emacs to find binaries
;; (setq exec-path
;;       (append exec-path '("~/.cargo/bin"
;;                           "~/.poetry/bin"
;;                           "~/.config/emacs/bin"
;;                           "~/.local/bin"
;;                           "/usr/local/bin"
;;                           "/usr/bin"
;;                           "/bin"
;;                           "/usr/local/sbin"
;;                           "/usr/lib/jvm/default/bin"
;;                           "$HOME/google-cloud-sdk/bin")))

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
    (setq evil-undo-system "undo-fu")
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

(scroll-bar-mode -1)	; disable visible scrollbar
(tool-bar-mode -1)		; disable toolbar
(tooltip-mode -1)		; disable tooltips
(set-fringe-mode 3) 	; margins
(menu-bar-mode -1) 		; disable menu bar

(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 125) 
(set-face-attribute 'fixed-pitch nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 125)
(set-face-attribute 'variable-pitch nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 125)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type t)

;; modes to skip
(dolist (mode '(term-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
        (add-hook mode (lambda ()
                         (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
    :hook
    (prog-mode . rainbow-delimiters-mode))

(use-package doom-themes
    :init
    ;; (load-theme 'doom-tomorrow-night t))  
    ;; (load-theme 'doom-material-dark t))  
    ;; (load-theme 'doom-monokai-octagon t))  
    (load-theme 'doom-monokai-pro t))  
    ;; (load-theme 'doom-material t))  
    ;; (load-theme 'doom-palenight t))  
    ;; (load-theme 'doom-dracula t))

;; all the icons is needed for doom-modeline
;; run M-x all-the-icons-install-fonts 
;; in WINDOWS that will only download the fonts, and then you need to install
;; them manually

(use-package all-the-icons)

;; doom-modeline to replace the standard modeline
(use-package doom-modeline
  :config
  (setq doom-modeline-unicode-fallback t
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
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-heading-icons t)
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

(use-package dired-hide-dotfiles)

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package dired
    :ensure nil
    ;; :commands (dired dired-jump)
    :config
    (setq insert-directory-program "/usr/local/bin/gls")
    (setq dired-listing-switches "-algho --group-directories-first --time-style \"+%Y-%m-%d %H:%M\"")
    (all-the-icons-dired-mode 1)
    (dired-hide-dotfiles-mode 1)
    (evil-define-key 'normal dired-mode-map
    (kbd "H") 'dired-hide-dotfiles-mode
    (kbd "l") 'dired-single-buffer
    (kbd "<right>") 'dired-single-buffer
    (kbd "h") 'dired-single-up-directory
    (kbd "<left>") 'dired-single-up-directory))


(use-package dired-single)

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

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x X-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

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
  :diminish projectile-mode
  :config (projectile-mode)
  (add-to-list 'projectile-globally-ignored-directories "*venv")
  (add-to-list 'projectile-globally-ignored-directories "venv")
  (add-to-list 'projectile-globally-ignored-directories "*.venv")
  (add-to-list 'projectile-globally-ignored-directories ".venv")
  (add-to-list 'projectile-globally-ignored-file-suffixes "*.pyc")
  :bind-keymap
  ("C-c p" . projectile-command-map)
  ;; ("SPC P" . projectile-command-map))
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  ;; action that triggers on switching projects (eg open dired)
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package rg
  :config
  (rg-enable-menu))

;; (use-package lsp-pyright)

;; (use-package pyvenv
;;   :init
;;   (setenv "WORKON_HOME" "~/.pyenv/versions")
;;     (defun try/pyvenv-workon ()
;;     (when (buffer-file-name)
;;       (let* ((python-version ".python-version")
;;              (project-dir (locate-dominating-file (buffer-file-name) python-version)))
;;         (when project-dir
;;           (pyvenv-workon
;;             (with-temp-buffer
;;               (insert-file-contents (expand-file-name python-version project-dir))
;;              (car (split-string (buffer-string)))))))))
;;   :config
;;   (pyvenv-mode 1)
;;   :hook
;;   (python-mode . try/pyvenv-workon))

(use-package cider
    :mode "\\.clj[sc]?\\'"
    :config
    (evil-collection-cider-setup))

(use-package scala-mode
  :interpreter ("scala" . scala-mode))

;; (use-package lsp-metals
;;   :ensure t
;;   :custom
;;   ;; Metals claims to support range formatting by default but it supports range
;;   ;; formatting of multiline strings only. You might want to disable it so that
;;   ;; emacs can use indentation provided by scala-mode.
;;   (lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"))
;;   :hook (scala-mode . lsp))

(use-package rustic
  :config
  (setq rustic-lsp-client 'eglot)
  (setq rustic-format-on-save t))

(use-package elm-mode
  :hook
  (elm-mode . elm-indent-simple-mode)
  (elm-mode . elm-format-on-save-mode))

(use-package terraform-mode
  :hook
  (terraform-mode . terraform-format-on-save-mode))

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package eval-in-repl
  :config
  (setq eir-repl-placement 'right)
  (setq eir-jump-after-eval nil)
  (setq eir-always-split-script-window t)
  (setq eir-use-python-shell-send-string nil)
  ;;; Emacs-lisp
  (require 'eval-in-repl-ielm)
  (setq eir-ielm-eval-in-current-buffer t)
  (define-key emacs-lisp-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
  (define-key lisp-interaction-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
  (define-key Info-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
  ;;; Clojure
  (require 'eval-in-repl-cider)
  (define-key clojure-mode-map (kbd "<C-return>") 'eir-eval-in-cider)
  ;;; Python
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")
  (require 'eval-in-repl-python)
  (add-hook 'python-mode-hook
            '(lambda ()
               (local-set-key (kbd "<C-return>") 'eir-eval-in-python)))
  ;;; Shell
  (require 'eval-in-repl-shell)
    (add-hook 'sh-mode-hook
              '(lambda()
                 (local-set-key (kbd "C-<return>") 'eir-eval-in-shell)))
  )

;; (add-to-list 'load-path "~/dotfiles/.config/emacs/local-packages/kubectl")
;; (require 'kubectl)

(use-package kubernetes)
(use-package kubernetes-evil
  :ensure t
  :after kubernetes)

(use-package flycheck
  :init (global-flycheck-mode))
    ;; :defer t
    ;; :hook (lsp-mode . flycheck-mode))

;; Reformatter
(use-package reformatter)

;; Defining reformatters
;; python
(reformatter-define black-format
  :program "black"
  :args '("-"))
(reformatter-define prettier-format
  :program "prettier"
  :args '("--parser" "json"))
;; terraform
(reformatter-define terraform-format
  :program "terraform"
  :args '("fmt" "-"))
;; terraform
(reformatter-define pg-format
  :program "pg_format"
  :args '("-"))

;; This function acts as entrypoint / dispatcher
;; depending on the mode
(defun my/reformat-buffer()
    "Reformat the current buffer if there is
 a reformatter configured for the active major mode."
  (interactive)
  (pcase major-mode
    ('python-mode (black-format-buffer))
    ('terraform-mode (terraform-format-buffer))
    ('js-mode (prettier-format-buffer))
    ('sql-mode (pg-format-buffer))
    (_ (message "No reformatted configured for `%s`" major-mode))
    )
  )
  
(defun my/reformat-region (beg end)
    "Reformat the current buffer if there is
 a reformatter configured for the active major mode."
  (interactive "r")
  (pcase major-mode
    ;; ('python-mode (black-format-buffer))
    ;; ('terraform-mode (terraform-format-buffer))
    ('js-mode (prettier-format-region beg end))
    (_ (message "No reformatted configured for `%s`" major-mode))
    )
  )

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(use-package magit
  ;; commands that make magit load
  :defer t
  :commands (magit-status magit-get-current-branch))

;; (use-package forge)

(use-package hydra)
(use-package smerge-mode
  :config
  (defhydra unpackaged/smerge-hydra
    (:color pink :hint nil :post (smerge-auto-leave))
    "
^Move^       ^Keep^               ^Diff^                 ^Other^
^^-----------^^-------------------^^---------------------^^-------
_n_ext       _b_ase               _<_: upper/base        _C_ombine
_p_rev       _u_pper              _=_: upper/lower       _r_esolve
^^           _l_ower              _>_: base/lower        _k_ill current
^^           _a_ll                _R_efine
^^           _RET_: current       _E_diff
"
    ("n" smerge-next)
    ("p" smerge-prev)
    ("b" smerge-keep-base)
    ("u" smerge-keep-upper)
    ("l" smerge-keep-lower)
    ("a" smerge-keep-all)
    ("RET" smerge-keep-current)
    ("\C-m" smerge-keep-current)
    ("<" smerge-diff-base-upper)
    ("=" smerge-diff-upper-lower)
    (">" smerge-diff-base-lower)
    ("R" smerge-refine)
    ("E" smerge-ediff)
    ("C" smerge-combine-with-next)
    ("r" smerge-resolve)
    ("k" smerge-kill-current)
    ("ZZ" (lambda ()
            (interactive)
            (save-buffer)
            (bury-buffer))
     "Save and bury buffer" :color blue)
    ("q" nil "cancel" :color blue))
  :hook (magit-diff-visit-file . (lambda ()
                                   (when smerge-mode
                                     (unpackaged/smerge-hydra/body)))))

;; TODO doesnt work well with org mode buffers for me
(use-package git-gutter
  :defer t
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode)))

(use-package magit-todos
  :hook (magit-mode . magit-todos-mode)
  :config
  (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?"))

;; TODO
  ;; (use-package eglot)

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-l")
  :config
  (setq lsp-modeline-diagnostics-enable t)
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (elm-mode . lsp)
         (python-mode . lsp)
         (clojure-mode . lsp)
         (rustic-mode . lsp)
         (scala-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-python)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(use-package company
    :init
    (add-hook 'after-init-hook 'global-company-mode)
    :bind (:map company-active-map
           ("<tab>" . company-complete-common-or-cycle)) ; tab completes the selection instead next
    :custom
    (company-minimum-prefix-lenght 1)
    (company-idle-delay 0.1)
    (company-show-numbers nil))

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
  (smartparens-global-mode t)
  (require 'smartparens-config))

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/yasnippets"))
  (yas-global-mode 1))

(use-package vterm
  :after evil-collection
  :config
  (setq vterm-shell "/usr/local/bin/fish")
  (setq term-prompt-regexp "➜ *")
  (evil-define-minor-mode-key 'normal 'vterm-mode (kbd "_") 'evil-collection-vterm-first-non-blank)
  ;; (evil-define-key 'normal 'vterm-mode-map (kbd "cc") 'evil-collection-vterm-change-line)
  )

(use-package eshell-toggle
    :custom
    (eshell-toggle-size-fraction 3)
    (eshell-toggle-use-projectile-root t)
    (eshell-toggle-run-command nil))

(defun my/org-mode-setup()
    (org-indent-mode)
    ;;(visual-line-mode 1)
    )

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
          org-todo-keywords '((sequence "TODO"
                                        "WIP"
                                        "BLOCKED"
                                        "REVIEW"
                                        "|"
                                        "DONE"
                                        "ARCHIVED"))
          org-todo-keyword-faces '(("TODO" . "GreenYellow")
                                   ("WIP" . "Gold")
                                   ("BLOCKED" . "FireBrick")
                                   ("REVIEW" . "Violet"))
          org-return-follows-link t))

(use-package evil-org
  :after org
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode)
		 (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
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

;; (defun my/org-mode-visual-fill ()
;;     (setq visual-fill-column-width 79)
;;     (visual-fill-column-mode 1))

;; (defun my/org-mode-center-text ()
;;  "toggle centering text in buffer"
;;     (interactive)
;;     (setq visual-fill-column-center-text (not visual-fill-column-center-text)))

;; (use-package visual-fill-column 
;;     :hook (org-mode . my/org-mode-visual-fill))

(org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (clojure . t)
      (shell . t)
      (sql . t)))

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

(use-package general
    :config
    (general-evil-setup t)
    (general-create-definer my/leader-key-def
        :states '(normal insert visual emacs)
        :keymaps 'override
        :prefix "SPC"
        :global-prefix "C-SPC"))

(defun my/find-file()
  (interactive)
  (if (projectile-project-p)
      (counsel-projectile-find-file)
    (counsel-find-file)))

(my/leader-key-def
  ;; actions
  "DEL" '(evil-switch-to-windows-last-buffer :which-key "Last buffer")
  "RET" '(counsel-bookmark :which-key "Bookmarks")
  "SPC" '(my/find-file :which-key "Find file")
  "<home>" '(dashboard-refresh-buffer :which-key "Switch to Dashboard")
  "'" '(ivy-resume :which-key "Resume last search")
  "," '(projectile-switch-to-buffer :which-key "Switch project buffer")
  "." '(counsel-M-x :which-key "M-x")
  ":" '(counsel-find-file :which-key "Find file")
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
    "c <return>" '(lsp-execute-code-action :which-key "Code Actions")
    "cc" '(counsel-compile :which-key "Compile")
    "cd" '(lsp-find-definition :which-key "Jump to definition")
    "cr" '(lsp-find-references :which-key "Jump to references")
    "cf" '(my/reformat-buffer :which-key "Format buffer")
    "cl" '(flycheck-list-errors :which-key "List errors")
    "cn" '(flycheck-next-error :which-key "Next error"))

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

(my/leader-key-def
  "d"  '(counsel-find-file :which-key "Here"))
  ;; "dh"  `(,(my/dired-in "~") :which-key "Home")
  ;; "do"  `(,(my/dired-in "~/org") :which-key "Org")
  ;; "dD"  `(,(my/dired-in "~/downloads") :which-key "Downloads")
  ;; "dv"  `(,(my/dired-in "~/videos") :which-key "Videos")
  ;; "d."  `(,(my/dired-in "~/dotfiles") :which-key "dotfiles")
  ;; "dp"  `(,(my/dired-in "~/projects") :which-key "projects")
  ;; "de"  `(,(my/dired-in "~/.config/emacs") :which-key "emacs"))

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
    "h <return>" '(info-emacs-manual :which-key "Emacs manual")
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

(defun my/vterm-toggle()
  (interactive)
  (if (projectile-project-p)
      (projectile-run-vterm-other-window)
    (vterm-other-window)))

(defun my/vterm-here()
  (interactive)
  (vterm-other-window vterm-buffer-name))

(my/leader-key-def
    "o"  '(:ignore t :which-key "open")
    "o-" '(dired-jump :which-key "Dired")
    "ob" '(browse-url-of-file :which-key "Browser")
    ;o; "d" '(org :which-key "debugger")
    "of" '(make-frame :which-key "New frame")
    "om" '(mu4e :which-key "Mu4e")
    ;o; "r" '(org :which-key "REPL")
    "oe" '(eshell-toggle :which-key "eshell")
    "ot" '(my/vterm-toggle :which-key "toggle-vterm")
    "oT" '(my/vterm-here :which-key "vterm-here")
    )

(defun my/switch-project-dired()
  (interactive)
    (counsel-projectile-switch-project 'counsel-projectile-switch-project-action-dired))

(my/leader-key-def
    "p"  '(:ignore t :which-key "projects")
    "p!" '(projectile-run-shell-command-in-root :which-key "Run cmd in project root")
    "p." '(projectile-recentf :which-key "Recent files in project")
    "pa" '(projectile-add-known-project :which-key "Add project")
    "pb" '(counsel-projectile-switch-to-buffer :which-key "Switch to project buffer")
    "pd" '(projectile-dired :which-key "dired in project")
    "pf" '(counsel-projectile-find-file :which-key "Find file in project")
    "pk" '(projectile-kill-buffers :which-key "Kill project buffers")
    "pp" '(my/switch-project-dired :which-key "Switch project") 
    "pr" '(projectile-recentf :which-key "Recent files in project")
    "ps" '(projectile-ripgrep :which-key "ripgrep on project")
    "pt" '(magit-todos-list :which-key "Project TODOs")
    "pD" '(projectile-remove-known-project :which-key "Delete project")
    "pR" '(projectile-run-project :which-key "Run project"))

(my/leader-key-def
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "Quit"))

(my/leader-key-def
    "s"  '(:ignore t :which-key "search")
    "ss" '(rg-menu :which-key "ripgrep-menu")
    "sp" '(projectile-ripgrep :which-key "projectile -ipgrep")
    "sr" '(rg--transient :which-key "ripgrep-regex"))

 ;; TODO add bindings to search in project, etc

(my/leader-key-def
    "t"  '(:ignore t :which-key "toggle")
    "tf" '(flycheck-mode :which-key "Flycheck")
    "tl" '(doom/toggle-line-numbers :which-key "Line numbers")
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
    :states 'insert
    "<home>" 'beginning-of-line
    "<end>"  'end-of-line)

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

(use-package envrc
  :config
  (envrc-global-mode))

(defun my/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config)))
