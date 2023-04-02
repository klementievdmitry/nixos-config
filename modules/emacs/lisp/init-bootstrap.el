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

;; Direnv
(use-package direnv
  :config
  (direnv-mode))

(provide 'init-bootstrap)
