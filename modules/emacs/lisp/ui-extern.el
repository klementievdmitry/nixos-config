;; All the icons
(use-package all-the-icons)

;; Set custom theme
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-eclipse t)
  (kaolin-treemacs-theme))

(provide 'ui-extern)
