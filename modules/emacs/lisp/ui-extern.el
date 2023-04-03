;; All the icons
(use-package all-the-icons)

;; Set custom theme
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-eclipse t)
  (kaolin-treemacs-theme))

;; Doom modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(provide 'ui-extern)
