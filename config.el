;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;; The exceptions to this rule:
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Additional functions/macros that will help you configure Doom:
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

(load! "lib.el")

;; Misc
;;; Turn off annoying message when connecting with emacsclient
(setq server-client-instructions nil)

;; Font
(setq doom-font
      (font-spec
       :family "Iosevka Term"
       :size 15
       :weight 'semi-bold))

;; Theme
(setq doom-theme 'doom-nord)
(setq display-line-numbers-type 'relative)

;; Modeline
(setq display-time-default-load-average nil)
(setq display-time-format "%H:%M")
(display-time-mode 1)

;; Dired
(after! dired
  (setq delete-by-moving-to-trash t)
  (setq large-file-warning-threshold nil))

;; Ranger
(after! (dired ranger)
  (setq ranger-override-dired 'ranger))

;; Workspaces
;;; Disable new workspace being created when reconnecting to emacs daemon
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

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

;; mu4e
(after! mu4e
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Personal"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/personal" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "gekoke@lazycantina.xyz")
                  (user-full-name . "gekoke")
                  (smtpmail-smtp-server . "smtp.fastmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)
                  (mu4e-sent-folder . "/personal/Sent")
                  (mu4e-drafts-folder . "/personal/Drafts")
                  (mu4e-trash-folder . "/personal/Trash"))))))

;; Treemacs
;;; Enable icons
(setq doom-themes-treemacs-theme "doom-colors")

;; Autocommit
(setq gac-automatically-push-p t)
(setq gac-automatically-add-new-files-p t)

;; Keybindings
(map! :leader "x" #'kill-current-buffer)
(map! :leader "r l" #'align-regexp)
(map! :leader "r a" #'dired-jump)
(map! :leader "v" #'magit-status)
(map! :leader "V" #'magit-status-here)
(map! :leader "e" #'+vertico/switch-workspace-buffer)
(map! :leader "E" #'switch-to-buffer)
(map! :map ranger-mode-map
      :m  "; ;" 'dired-create-empty-file)
(map! :localleader
      (:map ranger-mode-map
            "k" #'dired-create-directory))
(map! :map vterm-mode-map "C-c C-w" #'evil-window-next)

;; Org
(after! org
  (setq org-directory "~/org/")
  (setq org-attach-id-dir "~/org/.attach/")
  (setq org-agenda-files (list "~/org/"))
  (setq org-log-done 'time)
  (setq org-startup-with-inline-images t)

  (use-package! org-contacts
    :custom (org-contacts-files '("~/org/contacts.org")))

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"    ; A task that needs doing & is ready to do
           "PROJ(p)"    ; A project, which usually contains other tasks
           "LOOP(r)"    ; A recurring task
           "STRT(s)"    ; A task that is in progress
           "WAIT(w@)"   ; Something external is holding up this task
           "HOLD(h)"    ; This task is paused/on hold because of me
           "IDEA(i)"    ; An unconfirmed and unapproved task or notion
           "|"
           "DONE(d)"    ; Task successfully completed
           "KILL(k@)")  ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"     ; A task that needs doing
           "[-](S)"     ; Task is in progress
           "[?](W)"     ; Task is being held up or paused
           "|"
           "[X](D)")    ; Task was completed
          (sequence
           "|"
           "OKAY(o)"
           "YES(y)"
           "NO(n)"))
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STRT" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
          ("NO"   . +org-todo-cancel))))

;; Prolog
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(prolog-mode . "prolog-ls"))
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection (list "swipl"
                                "-g" "use_module(library(lsp_server))."
                                "-g" "lsp_server:main"
                                "-t" "halt"
                                "--" "stdio"))
    :major-modes '(prolog-mode)
    :priority 1
    :multi-root t
    :server-id 'prolog-ls)))

;; Latex
(setq org-latex-compiler "lualatex")

;; C
(if-supports! c
  (after! lsp
    (setq lsp-clangd-binary-path (executable-find "clang"))))
