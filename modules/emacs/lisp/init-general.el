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

(provide 'init-general)
