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
(setq package-archives '(
          ("melpa" . "https://melpa.org/packages/")
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

;; save minibuffer history between sessions
(savehist-mode 1)

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
(setq-default fill-column 88)

;; visual-line
(set-default 'truncate-lines 't)
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

(use-package evil
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-C-i-jump nil)
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
    ;; highlight on yank
    (setq pulse-flag t)
    (advice-add 'evil-yank :around 'my/evil-yank-advice)
    ;; remap :W -> :w)
    (evil-ex-define-cmd "W" 'evil-write))

;; I use avy via evil-collection to jump around using `s`
(use-package avy)
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
  (define-key evil-normal-state-map "s" 'evil-avy-goto-char-timer))

 ;; using undo-fu to get redo functionality
(use-package undo-fu
    :config
    (setq evil-undo-system "undo-fu")
    (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
    (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))

(use-package evil-org
    :hook (org-mode . evil-org-mode))

(scroll-bar-mode -1)	; disable visible scrollbar
(tool-bar-mode -1)		; disable toolbar
(tooltip-mode -1)		; disable tooltips
(set-fringe-mode 3) 	; margins
(menu-bar-mode t) 		; disable menu bar 

(setq scroll-margin 10) ; minimum screen lines to keep above & below cursor
(setq scroll-conservatively 101)  ; scroll line-by-line instead of jumping to the center
(global-display-line-numbers-mode t)
(global-hl-line-mode 1)  ; highlight the current line globally (we disable it in specific modes later)

(add-to-list 'default-frame-alist '(undecorated-round  . t)) ; disable titlebar

(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 125) 
(set-face-attribute 'fixed-pitch nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 125)
(set-face-attribute 'variable-pitch nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 125)

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
	(setq dashboard-match-agenda-entry "+TODO=\"TODO\"|+TODO=\"WAIT\"")
	(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
	;; (setq dashboard-agenda-release-buffers t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-heading-icons t)
    ;; (setq dashboard-footer-icon nil)
    (setq dashboard-items '((recents  . 5)
                            (bookmarks . 5)
                            ;; (projects . 5)
                            (agenda . 10))))

;; Set dashboard to be the initial buffer that opens when using emacsclient
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

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

(use-package ready-player
  :config
  (ready-player-mode +1))

(use-package transient
  :config
  (define-key transient-map (kbd "<escape>") 'transient-quit-one)
  (transient-bind-q-to-quit))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package vertico
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         :map minibuffer-local-map
         ("C-r" . consult-history))
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  (consult-fd-args "fd --hidden")
  (consult-async-min-input 1)
  (consult-preview-key 'any))  ;'(:debounce 0.5 any)))  ;; delay previews

(use-package embark
  :bind (("C-l" . embark-act)
         :map minibuffer-local-map
         ("C-l" . embark-act))
  :config
  ;; Show Embark actions via which-key
  (setq embark-action-indicator
        (lambda (map)
          (which-key--show-keymap "Embark" map nil nil 'no-paging)
          #'which-key--hide-popup-ignore-command)
        embark-become-indicator embark-action-indicator)
  (setopt embark-verbose-indicator-display-action
          '(display-buffer-at-bottom)))
  
(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . conult-preview-at-point-mode))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :init
  (global-corfu-mode)
  :config
  (setq completion-cycle-threshold 4)
  (setq tab-always-indent 'complete))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package smex
  :config (smex-initialize))

(use-package helpful
  :after evil
  :init
  (setq evil-lookup-func #'helpful-at-point)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package rg
  :config
  (rg-enable-menu))

; use tree-sitter
; Install it first by M-x treesit-install-language-grammar
(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)))

(use-package nix-mode)

(use-package cider
    :mode "\\.clj[sc]?\\'"
    :config
    (evil-collection-cider-setup))

(use-package scala-mode
  :interpreter ("scala" . scala-mode))

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
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode)))

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

;; (use-package kele
;;   :config
;;   (kele-mode 1)
;;   (bind-key (kbd "s-k") kele-command-map kele-mode-map))

(use-package flycheck
  :init (global-flycheck-mode))

;; Reformatter
(use-package reformatter)

;; Defining reformatters
;; python
(reformatter-define black-format
  :program "black"
  :args '("-"))
(reformatter-define ruff-format
  :program "ruff"
  :args '("format" "-"))
(reformatter-define prettier-format
  :program "prettier"
  :args '("--parser" "json"))
;; terraform
(reformatter-define terraform-format
  :program "terraform"
  :args '("fmt" "-"))
;; yaml
(reformatter-define yaml-format
  :program "yamlfmt"
  :args '("-"))
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
    ('python-mode (ruff-format-buffer))
    ('python-ts-mode (ruff-format-buffer))
    ('yaml-mode (yaml-format-buffer))
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
    ('yaml-mode (yaml-format-region beg end))
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

(use-package git-gutter
  :defer t
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode)))

(use-package magit-todos
  :hook (magit-mode . magit-todos-mode)
  :config
  (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?"))

(use-package lsp-mode
   :init
   ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
   (setq lsp-keymap-prefix "C-l")
   :config
   (setq lsp-modeline-diagnostics-enable t)
   :hook (
          ;; replace XXX-mode with concrete major-mode(e. g. python-mode)
          (elm-mode . lsp)
          (python-ts-mode . lsp-deferred)
          (python-mode . lsp-deferred)
          (clojure-mode . lsp)
          (rustic-mode . lsp)
          (scala-mode . lsp)
          ;; if you want which-key integration
          (lsp-mode . lsp-enable-which-key-integration))
   :commands (lsp lsp-deferred))
 
 ;; optionally
 ;; (use-package lsp-ui :commands lsp-ui-mode)
 ;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-python)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(electric-pair-mode 1)

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/yasnippets"))
  (yas-global-mode 1))

(use-package vterm
  :after evil-collection
  :config
  (setq vterm-shell "$HOME/.nix-profile/bin/fish")
  (setq term-prompt-regexp "➜ *")
  (evil-define-minor-mode-key 'normal 'vterm-mode (kbd "_") 'evil-collection-vterm-first-non-blank)
  ;; (evil-define-key 'normal 'vterm-mode-map (kbd "cc") 'evil-collection-vterm-change-line)
  :hook ((vterm-mode . (lambda () (setq-local hl-line-mode nil)))
         (vterm-mode . (lambda () (display-line-numbers-mode -1)))))

(defun my/vterm-buffer-p (buffer)
 "Return non-nil if BUFFER is a vterm buffer."
 (with-current-buffer buffer
    (or (eq major-mode 'vterm-mode)
        (eq major-mode 'vterm-copy-mode))))

;; make sure project-kill-buffers kills vterm buffers
(add-to-list 'project-kill-buffer-conditions 'my/vterm-buffer-p)

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
                                        "NOTE"
                                        "WAIT"
                                        "|"
                                        "DONE"
                                        "ARCHIVED"))
          org-todo-keyword-faces '(("TODO" . "GreenYellow")
                                   ("NOTE" . "Gold")
                                   ("WAIT" . "Violet"))
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

(org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (clojure . t)
      (shell . t)
      (sql . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(use-package ob-async)

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
  (setq org-roam-node-display-template
        "${title:60} ${tags:*}")
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
  "Use project specific find if in project"
  (interactive)
  (if (project-current)
      (project-find-file)
    (consult-fd)))

(defun my/toggle-scratch-buffer ()
  "Toggle the scratch buffer. If it's currently displayed, close the window; otherwise, open it."
  (interactive)
  (let ((scratch-buffer (get-buffer "*scratch*")))
    (if scratch-buffer
        (let ((window (get-buffer-window scratch-buffer)))
          (if window
              (delete-window window)
            (progn
              (evil-window-split 20)
              (switch-to-buffer scratch-buffer))))
      (progn
        (evil-window-split 20)
        (switch-to-buffer (get-buffer-create "*scratch*"))))))

(my/leader-key-def
  "DEL" '(evil-switch-to-windows-last-buffer :which-key "Last buffer")
  "RET" '(consult-bookmark :which-key "Bookmarks")
  "SPC" '(my/find-file :which-key "Find file")
  "<home>" '(dashboard-refresh-buffer :which-key "Switch to Dashboard")
  "<up>" '(evil-window-up :which-key "cursor up")
  "<down>" '(evil-window-down :which-key "cursor down")
  "<left>" '(evil-window-left :which-key "cursor left")
  "<right>" '(evil-window-right :which-key "cursor right")
  ";" '(eval-expression :which-key "Eval expression")
  "x" '(my/toggle-scratch-buffer :which-key "Toggle scratch buffer")
  "X" '(org-capture :which-key "Org Capture"))

(my/leader-key-def
    "a"  '(:ignore t :which-key "Org Agenda")
    "aa" '(org-agenda :which-key "Agenda")
    "at" '(org-todo-list :which-key "Todo list")
    "am" '(org-tags-view :which-key "Tags view")
    "av" '(org-search-view :which-key "Search view"))

(defun my/consult-switch-buffer()
  "Use project specific switcher if in project"
  (interactive)
  (if (project-current)
      (consult-project-buffer)
      (consult-buffer)))

(defun my/kill-matching-buffers-no-confirm (regexp)
 "Kill all buffers matching REGEXP without confirmation."
  (interactive)
  (cl-letf (((symbol-function 'kill-buffer-ask) #'kill-buffer))
    (kill-matching-buffers regexp)))

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

(my/leader-key-def
  "b"  '(:ignore t :which-key "buffer")
  "bn" '(next-buffer :which-key "Next buffer")
  "bp" '(previous-buffer :which-key "Previous buffer")
  "bb" '(my/consult-switch-buffer :which-key "Switch buffer")
  "bi" '(ibuffer :which-key "ibuffer")
  "bk" '(kill-current-buffer :which-key "Kill buffer")
  "bl" '(evil-switch-to-windows-last-buffer :which-key "Switch to last buffer")
  "bs" '(basic-save-buffer :which-key "Save buffer")
  "bz" '(bury-buffer :which-key "Bury buffer")
  "bm" '(bookmark-set :which-key "Mark as bookmark")
  "bM" '(bookmark-delete :which-key "Delete bookmark")
  "bR" '(revert-buffer :which-key "Revert buffer")
  "bB" '(consult-buffer :which-key "consult buffer")
  "bK" '(my/close-all-buffers :which-key "Kill all buffers")
  "bN" '(evil-buffer-new :which-key "New buffer"))

(my/leader-key-def
    "c"  '(:ignore t :which-key "code")
    "c <return>" '(lsp-execute-code-action :which-key "Code Actions")
    "cc" '(project-compile :which-key "Compile")
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

(my/leader-key-def
  "d"  '(find-file :which-key "here"))

(my/leader-key-def
    "f"  '(:ignore t :which-key "files")
    "ff" '(find-file :which-key "Find file")
    "fl" '(consult-locate :which-key "Locate file")
    "fr" '(consult-recent-file :which-key "Recent files")
    "fs" '(save-buffer :which-key "Save file")
    "fy" '(my/copy-filename-to-clipboard :which-key "Yank filename")
    "fC" '(copy-file :which-key "Copy this file")
    "fD" '(delete-file :which-key "Delete this file")
    "fR" '(rename-file :which-key "Rename/Move file")
    "fS" '(write-file :which-key "Save file as..."))

(defun my/kill-magit-buffers()
  "Kills all magit buffers"
  (interactive)
  (my/kill-matching-buffers-no-confirm "^magit.*"))

(my/leader-key-def
  "g"  '(:ignore t :which-key "git")
  "gg" '(magit-status :which-key "Magit status")
  "g/" '(magit-dispatch :which-key "Magit dispatch")
  "gb" '(magit-branch-checkout :which-key "Magit switch branch")
  "gC" '(magit-clone :which-key "Magit clone")
  "gD" '(magit-file-delete :which-key "Magit file delete")
  "gR" '(vc-revert :which-key "Revert file")
  "gS" '(magit-stage-file :which-key "Magit stage file")
  "gK" '(my/kill-magit-buffers :which-key "Kill all magit buffers")
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
    "hf" '(describe-function :which-key "Describe function")
    "hi" '(info :which-key "Info")
    "hk" '(describe-key :which-key "Describe key")
    "hl" '(view-lossage :which-key "View lossage")
    "hm" '(describe-mode :which-key "Describe mode")
    "hs" '(describe-symbol :which-key "Describe symbol")
    "hq" '(help-quit :which-key "Help quit")
    "hv" '(describe-variable :which-key "Describe variable")
    "hw" '(where-is :which-key "Where is")
    "hA" '(apropos-documentation :which-key "Apropos docs")
    "hC" '(describe-coding-system :which-key "Describe coding system")
    "hF" '(describe-face :which-key "Describe face")
    "hV" '(set-variable :which-key "Set variable")
    "hH" '(help-for-help :which-key "Help for help"))

;; (defun my/k8s-pods()
;;     (kubel-open ))

(defun my/kill-kubel-buffers()
    "Kill all kubel buffers"
    (interactive)
    (my/kill-matching-buffers-no-confirm "^\\*kubel.*\\*"))

(my/leader-key-def
    "k"  '(:ignore t :which-key "Kubernetes")
    "kk" '(kubel :which-key "k8s")
    "kK" '(my/kill-kubel-buffers :which-key "Kill kubel buffers"))
    ;; "kl" '(kubel-open :which-key "k8s Logs"))

;; TODO add note filtering functions here

(my/leader-key-def
    "n"  '(:ignore t :which-key "notes")
    "nn" '(org-capture :which-key "Org Capture")
    "ni" '(org-roam-node-insert :which-key "org-roam-node-insert")
    "nf" '(org-roam-node-find :which-key "org-roam-node-find")
    "nt" '(org-roam-tag-add :which-key "Add a TAG")
    "nl" '(org-roam-buffer-toggle :which-key "org-roam-buffer-toggle"))

(defun my/vterm-switch-or-new()
  (interactive)
  (let ((vterm-target-name (my/vterm-buffer-name))
        (default-directory (my/vterm-project-default-dir)))
    (if (buffer-live-p (get-buffer vterm-target-name))
        (switch-to-buffer-other-window vterm-target-name)
        (vterm-other-window vterm-target-name))))

(defun my/vterm-new()
  (interactive)
  (vterm-other-window (my/vterm-buffer-name)))

(defun my/vterm-project-default-dir()
  (if (project-current)
      (project-root (project-current))
    default-directory))

(defun my/vterm-buffer-name()
  (let ((default-directory (my/vterm-project-default-dir)))
    (format "%s @ %s" vterm-buffer-name default-directory)))

(my/leader-key-def
    "o"  '(:ignore t :which-key "open")
    "o-" '(dired-jump :which-key "Dired")
    "ob" '(browse-url-of-file :which-key "Browser")
    ;o; "d" '(org :which-key "debugger")
    "of" '(make-frame :which-key "New frame")
    "om" '(mu4e :which-key "Mu4e")
    ;o; "r" '(org :which-key "REPL")
    "oe" '(eshell-toggle :which-key "eshell")
    "ot" '(my/vterm-switch-or-new :which-key "vterm-switch")
    "oT" '(my/vterm-new :which-key "vterm-new"))

(defun my/switch-project-dired()
 "Switch to a project and open dired in the project root."
 (interactive)
 (let ((project (project-prompt-project-dir)))
    (when project
      (dired (expand-file-name project)))))


(defun my/goto-project-flake()
  (interactive)
  (if (project-current)
      (let* ((project (project-name (project-current)))
            (flake-project (expand-file-name project "~/projects/flakes")))
        (find-file (expand-file-name "flake.nix" flake-project)))
    (message "Not in a project.")))

(my/leader-key-def
    "p"  '(:ignore t :which-key "projects")
    "pb" '(consult-project-buffer :which-key "Switch project buffer")
    "pd" '(project-dired :which-key "dired in project")
    "pk" '(project-kill-buffers :which-key "Kill project buffers")
    "pp" '(my/switch-project-dired :which-key "Switch project") 
    "pf" '(my/goto-project-flake :which-key "Go to Flake")
    "ps" '(consult-fd :which-key "consult find")
    "pt" '(magit-todos-list :which-key "Project TODOs")
    "pD" '(project-forget-project :which-key "Forget project"))

(my/leader-key-def
    "q"  '(:ignore t :which-key "quit")
    "qq" '(delete-frame :which-key "quit frame"))

(my/leader-key-def
    "s"  '(:ignore t :which-key "search")
    "ss" '(rg-dwim :which-key "ripgrep simple")
    "sS" '(rg-menu :which-key "ripgrep menu")
    "sp" '(rg-project :which-key "ripgrep project")
    "sl" '(rg-literal :which-key "ripgrep literal anywhere")
    "sr" '(rg--transient :which-key "ripgrep regex anywhere")
    "s/" '(consult-ripgrep :which-key "ripgrep dwim"))

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
    "w SPC" '(rotate-layout :which-key "rotate layout") 
    "wr" '(rotate-window :which-key "rotate windows")
    "w <up>" '(windmove-swap-states-up :which-key "move window up")
    "w <down>" '(windmove-swap-states-down :which-key "move window down")
    "w <left>" '(windmove-swap-states-left :which-key "move window left")
    "w <right>" '(windmove-swap-states-right :which-key "move window right"))

(use-package winner
    :after evil
    :config
    (winner-mode))
    ;; (my/leader-key-def
    ;;     "<left>" '(winner-undo :which-key "winner undo")
    ;;     "<right>" '(winner-redo :which-key "winner redo")))

(general-define-key    
    :states 'insert
    "<home>" 'beginning-of-line
    "<end>"  'end-of-line)

(general-define-key    
    :states 'normal
    "?" 'which-key-show-major-mode)

(general-define-key
 :states '(normal insert visual)
 "C-s" 'consult-line)

(general-define-key
 :states '(normal visual)
 "/" 'consult-line)

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
