;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

;; User details
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Misc
; Turn off annoying message when connecting with emacsclient
(setq server-client-instructions nil)

;; Font
(setq doom-font                (font-spec :family "IosevkaTerm" :size 16 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "IosevkaTerm" :size 16 :weight 'medium))

;; Dired
(setq delete-by-moving-to-trash t)

;; Theme
(setq doom-theme 'doom-gruvbox)
(setq display-line-numbers-type 'relative)

;; Ranger
(ranger-override-dired-mode t)

;; Keybindings
(map! :leader "x" #'kill-current-buffer)
(map! :leader "r a" #'dired-jump)
(map! :map ranger-mode-map
      :m  "; ;" 'dired-create-empty-file)
(map! :localleader
      (:map ranger-mode-map
      "k" #'dired-create-directory))

;; Modeline
(setq display-time-default-load-average nil)
(setq display-time-format "%H:%M")
(display-time-mode 1)

;; Workspaces
; Disable new workspace being created when reconnecting to emacs daemon
(after! persp-mode
    (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; Org
(setq org-directory "~/org/")
(setq org-agenda-files (list "~/org/"))
(setq org-log-done 'time)

;; Idris2
(use-package! idris2-mode
  :mode ("\\.l?idr\\'" . idris2-mode)
  :config

  (setq idris2-semantic-source-highlighting nil)
  (setq idris2-stay-in-current-window-on-compiler-error t)

  (after! lsp-mode
    (add-to-list 'lsp-language-id-configuration '(idris2-mode . "idris2"))

    (lsp-register-client
      (make-lsp-client
        :new-connection (lsp-stdio-connection "idris2-lsp")
        :major-modes '(idris2-mode)
        :server-id 'idris2-lsp)))

  (setq lsp-semantic-tokens-enable t)
  (add-hook 'idris2-mode-hook #'lsp!))

(after! company
  (setq company-global-modes
    '(not erc-mode
       message-mode
       help-mode
       gud-mode
       vterm-mode
       idris2-repl-mode)))  ;; Fix Idris2 REPL crashing on input

;; Calendar
(setq calendar-week-start-day 1)
(setq calendar-holidays
      '((holiday-fixed 1 1 "Uusaasta")
        (holiday-fixed 2 24 "Iseseisvuspäev")
        (holiday-easter-etc -2 "Suur Reede")
        (holiday-easter-etc 0 "Ülestõusmispühade 1. püha")
        (holiday-fixed 5 1 "Kevadpüha")
        (holiday-easter-etc 50 "Nelipühade 1. püha")
        (holiday-fixed 6 23 "Võidupüha")
        (holiday-fixed 6 24 "Jaanipäev")
        (holiday-fixed 8 20 "Taasiseseisvumispäev")
        (holiday-fixed 24 24 "Jõululaupäev")
        (holiday-fixed 24 25 "Esimene jõulupüha")
        (holiday-fixed 24 26 "Teine jõulupüha")))
