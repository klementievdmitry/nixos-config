(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)
(add-hook 'c-or-c++-mode-hook 'lsp-deferred)

(provide 'init-cc)
