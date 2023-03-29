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

;; Set the font size
(set-face-attribute 'default nil :font "JetBrains Mono" :height 130)

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
  (message "Hello, Evil!")
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

;;; init.el ends here
