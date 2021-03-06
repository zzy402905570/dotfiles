(use-package smartparens
  :config (require 'smartparens-config)
  :hook ((c++-mode c-mode python-mode
                   ruby-mode js2-mode tuareg-mode
                   go-mode rust-mode) . smartparens-mode))

(use-package lsp-mode
  :load-path "~/.emacs.d/vendor/lsp-mode"
  :hook ((go-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)
         ;; (sh-mode . lsp-deferred)
         ;; (js2-mode . lsp-deferred)
         )
  :ensure-system-package
  ((gopls . "go get golang.org/x/tools/gopls@latest")
   (rls . "rustup component add rls rust-analysis rust-src")
   (pyls . "pip install 'python-language-server[all]'")
   ;; (typescript-language-server . "npm install -g typescript-language-server")
   ;; (bash-language-server . "npm install -g bash-language-server")
   )
  :commands (lsp lsp-deferred)
  :config
  ;; (add-hook 'before-save-hook 'lsp-format-buffer)
  (setq lsp-log-io t
        lsp-eldoc-render-all t
        lsp-rust-server 'rust-analyzer
        lsp-prefer-capf t
        )
  (push "[/\\\\]vendor$" lsp-file-watch-ignored)
  :bind (:map lsp-mode-map
              ("M-." . lsp-find-definition)
              ("M-n" . lsp-find-references)
              ("C-c M-n" . lsp-rust-analyzer-expand-macro)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-doc-position 'top
        lsp-ui-doc-max-width 80
        lsp-ui-sideline-show-symbol nil
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-ignore-duplicate t)
  :bind (:map lsp-ui-mode-map
              ("C-c l" . lsp-ui-imenu))
  )

(use-package hideshow
  :hook (prog-mode . hs-minor-mode)
  :config
  (defun my/toggle-fold ()
    (interactive)
    (save-excursion
      (end-of-line)
      (if (hs-already-hidden-p)
          (hs-show-block)
        (hs-hide-block))))
  :bind (:map prog-mode-map
              ("C-c o" . my/toggle-fold))
  )

;; bridge to go-playground and rust-playground
(defun my/playground-exec ()
  (interactive)
  (cond ((rust-playground-get-snippet-basedir)
         (rust-playground-mode)
         (rust-playground-exec))
        ((string-match-p (file-truename go-playground-basedir) (file-truename (buffer-file-name)))
         (go-playground-mode)
         (go-playground-exec))))

(my/global-map-and-set-key "C-R" 'my/playground-exec)
