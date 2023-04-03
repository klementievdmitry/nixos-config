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

;; Show line and column numbers
(column-number-mode)                 ; Show column number in modeline
(global-display-line-numbers-mode t) ; Show line numbers

;; Hide line numbers in org/term/eshell modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(provide 'ui-face)
