
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(after-save-hook nil)
 '(bmkp-last-as-first-bookmark-file "~/devel/tipsi/tipsi_web/bookmarks")
 '(coffee-tab-width 4)
 '(color-identifiers-coloring-method (quote hash))
 '(custom-safe-themes
   (quote
    ("5a68850c66edcf32eb859345c331c9b20a50ddfcb577b70e0a69ad5d939d10d9" "40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" "708df3cbb25425ccbf077a6e6f014dc3588faba968c90b74097d11177b711ad1" default)))
 '(dired-dwim-target t)
 '(docker-tramp-use-names t)
 '(flycheck-disabled-checkers
   (quote
    (javascript-jshint json-python-json javascript-jshint javascript-gjslint javascript-jscs emacs-lisp-checkdoc)))
 '(flycheck-eslintrc nil t)
 '(flycheck-flake8rc "~/.config/flake8")
 '(flymake-log-level -1)
 '(flymake-no-changes-timeout 5)
 '(helm-adaptive-mode t nil (helm-adaptive))
 '(helm-ag-insert-at-point (quote word))
 '(helm-ag-use-agignore t)
 '(helm-mode-fuzzy-match t t)
 '(js-indent-level 2 t)
 '(js2-strict-missing-semi-warning nil)
 '(magit-pull-arguments nil t)
 '(org-agenda-files
   (quote
    ("~/Dropbox/gtd/tipsi.org" "~/Dropbox/gtd/gtd.org" "~/Dropbox/gtd/logbook/14_09.org" "~/Dropbox/gtd/calendar.org_archive" "~/Dropbox/gtd/calendar.org")))
 '(org-directory "~/Dropbox/gtd")
 '(org-mobile-directory "~/Dropbox/gtd")
 '(org-mobile-inbox-for-pull "~/Dropbox/gtd/mobileorg.org")
 '(package-selected-packages
   (quote
    (smartparens-config ag anything auto-complete avy cider clojure-mode coffee-mode docker docker-tramp dockerfile-mode erlang flx flx-ido flycheck flycheck-nim flycheck-flow fuzzy go-mode goto-chg geiser helm helm-ag helm-projectile hydra ido-completing-read+ js2-mode json-mode lua-mode magit markdown-mode prettier-js projectile rainbow-delimiters restclient rust-mode scala-mode2 slim-mode slime tagedit tramp vimish-fold web-mode use-package zenburn-theme)))
 '(projectile-completion-system (quote ido))
 '(projectile-enable-caching t)
 '(projectile-generic-command "ag -g \"\" -0")
 '(projectile-mode t nil (projectile))
 '(projectile-tags-exclude-supports-globs t t)
 '(ps-bottom-margin 5)
 '(ps-footer-offset 5)
 '(ps-header-font-size (quote (8 . 8)))
 '(ps-header-lines 1)
 '(ps-header-offset 0)
 '(ps-header-title-font-size (quote (8 . 8)))
 '(ps-inter-column 25)
 '(ps-left-margin 25)
 '(ps-paper-type (quote a4))
 '(ps-print-header-frame nil)
 '(ps-print-only-one-header t)
 '(ps-right-margin 25)
 '(ps-spool-duplex nil)
 '(ps-top-margin 5)
 '(safe-local-variable-values
   (quote
    ((eval font-lock-add-keywords nil
           (\`
            (((\,
               (concat "("
                       (regexp-opt
                        (quote
                         ("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl"))
                        t)
                       "\\_>"))
              1
              (quote font-lock-variable-name-face)))))
     (lexical-bindings . true)
     (vimish-fold-dir . "/ssd/kpi/tipsi/tipsi_web/.emacs.d/vimish-fold")
     (bookmark-default-file . "/ssd/kpi/tipsi/tipsi_web/bookmarks")
     (some-variable . "test")
     (content-type . "jsx")
     (web-mode-content-type . "jsx")
     (web-mode-content-type . jsx)
     (eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook"
           (add-hook
            (quote write-contents-functions)
            (lambda nil
              (delete-trailing-whitespace)
              nil))
           (require
            (quote whitespace))
           "Sometimes the mode needs to be toggled off and on."
           (whitespace-mode 0)
           (whitespace-mode 1))
     (whitespace-line-column . 80)
     (whitespace-style face tabs trailing lines-tail)
     (python-indent-offset . 4)
     (erlang-mode . 1)
     (erlang-mode\;erlang-indent-level . 4)
     (erlang\;erlang-indent-level . 4)
     (encoding . utf-8))))
 '(tab-width 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )