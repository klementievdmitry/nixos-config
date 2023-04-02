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

;; For multiple files
(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))

;; File loading function
(defun load-user-file (file)
  (interactive "f")
  (load-file (expand-file-name file user-init-dir)))

;; Bootstrap
(require 'init-bootstrap)

;; UI
(require 'init-ui)

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

;; General keybindings
(require 'init-general)

;; Evil mode
(require 'init-evil)

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

;; Project (projectile/magit/forge)
(require 'init-project)

;; Org mode
(require 'init-org)

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

;; C/C++ mode
;; Manually adding C/C++ LSP hooks
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)
(add-hook 'c-or-c++-mode-hook 'lsp-deferred)

;; CMake mode
(use-package cmake-mode
  :hook (cmake-mode . lsp-deferred))

;; Python mode
(use-package python-mode
  :hook (python-mode . lsp-deferred))

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

;; w3m
(use-package w3m)

(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook 'dired-omit-mode)

;;; init.el ends here
