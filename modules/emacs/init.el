;;; init.el --- Initial configuration file -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Klementiev Dmitry
;;
;; Author: Klementiev Dmitry <klementievdmitry@gmail.com>
;; Maintainer: Klementiev Dmitry <klementievdmitry@gmail.com>
;; Created: марта 28, 2023
;; Modified: марта 28, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/klvdmy/init
;; Package-Requires: ((emacs "26.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; Just initial config file
;;
;;
;;; Code:

(provide 'init)

;; No startup message
(setq inhibit-startup-message t)

(scroll-bar-mode -1)    ; Disable visible scrollbar
(tool-bar-mode -1)      ; Disable toolbar
(tooltip-mode -1)       ; Disable tooltips
(set-fringe-mode 10)    ; Give some breathing room
(menu-bar-mode -1)      ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(defun klvdmy/load-face-attributes ()
  ;; Set the font size
  (set-face-attribute 'default nil :font "JetBrains Mono" :height 130)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :height 200)

  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil :font "JetBrains Mono" :height 235 :weight 'regular))

(defun klvdmy/load-face-attributes-to-frame (frame)
  (select-frame frame)
  (klvdmy/load-face-attributes))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'klvdmy/load-face-attributes-to-frame)
  (klvdmy/load-face-attributes))

;; Enable electric pair mode
(electric-pair-mode 1)

;; Enable show paren mode
(show-paren-mode 1)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; All the icons
(use-package all-the-icons)

;; Set custom theme
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-eclipse t)
  (kaolin-treemacs-theme))

;; Show line and column numbers
(column-number-mode)                 ; Show column number in modeline
(global-display-line-numbers-mode t) ; Show line numbers

;; Hide line numbers in org/term/eshell modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Command log mode
(use-package command-log-mode
  :config
  (global-command-log-mode 1))

;; Use Ivy and Counsel for completions
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

(use-package counsel
  :custom
  (ivy-initial-inputs-alist nil) ; Don't start searches with ^
  :config
  (counsel-mode 1))

;; Doom modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Which-key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.3))

;; Ivy rich
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Helpful - A better emacs *help* buffer
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; General package for key bindings
(use-package general ; This package may be used in other
		     ; packages config (like `hydra`)
  :config ; This is a basic general conf
  ;; Definer
  (general-create-definer klvdmy/leader-keys ; This defined may be used
                                             ; in other packages (like `hydra`)
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  ;; Define basic leader key bindings
  (klvdmy/leader-keys
    "tt" '(counsel-load-theme :which-key "choose theme"))

  ;; Define all other basic key bindings
  (general-define-key
   "<escape>" 'keyboard-escape-quit ; Make ESC quit prompts
   "C-M-j" 'counsel-switch-buffer
   "C-s" 'counsel-grep-or-swiper))

;; Emacs Evil - Vim-like modal editing in Emacs
(use-package evil
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t) ; "C-u" - scroll up
			   ; "C-d" - scroll down
  (evil-want-C-i-jump nil)
  :bind (:map evil-insert-state-map
	 ("C-g" . 'evil-normal-state) ; "C-g" in insert mode to go to normal mode
                                     ; I use that's instead of "jk"
	 ("C-h" . 'evil-delete-backward-char-and-join)) ; I use(no) this instead
                                                       ; of backspace
  :config
  (evil-mode 1) ; Take on evil-mode
  
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection ; This is a collection of
			     ; evil bindings for the parts
			     ; of emacs that evil does not
                             ; cover properly by default,
                             ; such as `help-mode`,
                             ; `M-x calendar`. Eshell and more
  :after evil
  :config
  (evil-collection-init))

;; Hydra
(use-package hydra ; So cool package for me
                   ; for text resizing
  :config
  (defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t))

  (klvdmy/leader-keys
    "ts" '(hydra-text-scale/body :which-key "scale text")))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Magit - Emacs git integration
(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; [2020-11-24] This package is now a part of evil-collection
(use-package evil-magit
  :disabled ; Disable package because it's deprecated (removed from melpa)
            ; (use `evil-collection` instead of `evil-magit`)
  :after magit)

;; NOTE: Make sure to configure a Github token before using this package:
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)

;; Org mode
(defun klvdmy/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun klvdmy/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "JetBrains Mono" :weight 'regular :height (cdr face)))
  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . klvdmy/org-mode-setup)
  :config
  (klvdmy/org-font-setup)
  :custom
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers nil))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Direnv
(use-package direnv
  :config
  (direnv-mode))

;; LSP mode
(defun klvdmy/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . klvdmy/lsp-mode-setup)
  :custom
  (lsp-keymap-prefix "C-c l") ;; Or "C-l", "s-l"
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

;; Dap mode for debugging
(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

;; Nix mode
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))

;; TypeScript mode
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :custom
  (typescript-indent-level 2))

;; C/C++ mode
;; Manually adding C/C++ LSP hooks
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)

;; CMake mode
(use-package cmake-mode
  :hook (cmake-mode . lsp-deferred))

;; Company mode - Emacs autocompletion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
	      ("<tab>" . company-complete-selection)
	      :map lsp-mode-map
	      ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;;; init.el ends here
