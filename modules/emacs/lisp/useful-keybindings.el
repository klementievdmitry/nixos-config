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

(provide 'useful-keybindings)
