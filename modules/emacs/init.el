;; Bootstrap Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-recipe-repositories '(org-elpa
				     melpa
				     gnu-elpa-mirror
				     nongnu-elpa
				     el-get
				     emacsmirror-mirror))

;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
(defun update-load-path ()
  "Update `load-path'."
  (push (expand-file-name "lisp" user-emacs-directory) load-path))

(update-load-path)

;; use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

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

;; Dired
(require 'init-dired)

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

;; Project(projectile/magit/forge)
(require 'init-project)

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
