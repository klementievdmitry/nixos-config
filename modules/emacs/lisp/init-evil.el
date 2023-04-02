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
