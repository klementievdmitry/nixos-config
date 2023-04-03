;; Load path
;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
(defun update-load-path ()
  "Update `load-path'."
  (push (expand-file-name "lisp" user-emacs-directory) load-path))

(advice-add #'package-initialize :after #'update-load-path)

(update-load-path)

;; use-package
(straight-use-package 'use-package)

;; Dired gitignore
(straight-use-package
 '(dired-gitignore :type git :host github :repo "johannes-mueller/dired-gitignore.el"))
(add-hook 'dired-mode #'dired-gitignore-mode)

;; Enable electric pair mode
(electric-pair-mode 1)

;; Enable show paren mode
(show-paren-mode 1)

;; UI
(require 'ui-builtin)
(require 'ui-face)
(require 'ui-extern)

;; Direnv
(use-package direnv
  :config
  (direnv-mode))

;; Commands
(require 'init-commands)

;; Keybindings
(require 'init-evil)
(require 'init-general)
(require 'useful-keybindings)

;; Org mode
(require 'init-org)

;; LSP
(require 'init-lsp)
(require 'code-completion)

;; Specific languages
(require 'init-nix)
(require 'init-cc)
(require 'init-cmake)
(require 'init-python)
