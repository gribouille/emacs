;;; init.el -- Gribouille Emacs Configuration
;;; Commentary:
;;; To show shortcut: M-x cheatsheet-show
;;; Code:

;; About me
(setq user-full-name "Gribouille"
      user-mail-address "gribouille.leponge@gmail.com")


;;
;; System configuration
;;

;; Encoding by default: utf-8
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

;; Package configuration.
(package-initialize)
;; Path for ArchLinux
(unless (string-equal system-type "darwin")
  (add-to-list 'load-path "/usr/share/emacs/site-lisp"))

;; Load other elisp modules here:
;;(setq custom-file "~/.emacs.d/custom-settings.el")
;;(load custom-file t)

;; Packages repositories: MELPA & ELPA
;; to refresh: M-x package-refresh-contents
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))

;; Load the elisp module in the elisp directory
(add-to-list 'load-path "~/.emacs/elisp")

;; Install use-package if not installed to simplify packages configuration
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose t)
;; Ensure option always used i.e. installed automatically if not present
(setq use-package-always-ensure t)


;;
;; Global configuration
;;

;; <Alt right> is not used for Meta key
;; Important for MacBook with azerty keyboard
(when (string-equal system-type "darwin")
  (setq ns-right-alternate-modifier nil))

;; Hide toolbar
(tool-bar-mode -1)

;; Hide menu bar
(menu-bar-mode -1)

;; Hide scroll bar
(scroll-bar-mode -1)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Four spaces is a tab
(setq tab-width 2)

;; Disable annoying visual bell graphic
(setq visible-bell nil)

;; Disable super annoying audio bell
(setq ring-bell-function 'ignore)

;; Only one space between sentences
(setq sentence-end-double-space nil)

;; Show line number
(global-linum-mode t)

;; Show column number
(column-number-mode t)

;; Highlight the current line
(global-hl-line-mode 1)

;; Backup
;; by default, backup files are in the current directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; save lots
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; History
(require 'savehist)
(savehist-mode 1)
(setq savehist-file "~/.emacs.d/savehist")
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; Indent the new line
(global-set-key (kbd "RET") 'newline-and-indent)

;; C-b to switch buffers
;;(global-set-key (kbd "C-b") 'ivy-switch-buffer)

;; C-q to keyboard quit
(define-key global-map [remap quoted-insert] 'keyboard-quit)

;;
;; Functions
;;

;; killing text
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
	    (line-beginning-position 2)))))


;;
;; Packages
;;

;; Package: ensure that the env vars look the same as the user's shell
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "GOPATH"))
  )

;; Package: automatically recompile Emacs Lisp source files
;; (guarantee that Emacs never loads outdated byte code files)
(use-package auto-compile
  :config (auto-compile-on-load-mode)
  :after (setq load-prefer-newer t))

;; Package: highlight delimiters.
(use-package paren
  :init
  (setq show-paren-style 'parenthesis)
  :config
  (show-paren-mode 1))

;; Package: save the recent
(use-package recentf
  :bind
  ("C-x C-r" . recentf-open-files)
  :config
  (progn
    (setq recentf-max-saved-items 200
          recentf-max-menu-items 15)
    (recentf-mode 1)
    ))

;; Package: sexy mode-line
(use-package smart-mode-line)

;; Package: dark theme
(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-default-dark t))

;; Package: switch between window with M-<arrow>
(use-package windmove
  :config
  (windmove-default-keybindings 'meta))

;; Package: expand or contract the selected region
(use-package expand-region
  :defer t
  :bind
  ("C-=" . er/expand-region)
  ("C-<prior>" . er/expand-region)
  ("C-<next>" . er/contract-region))

;; Package: undo tree
(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))


;; Package: powerfull search lines
(use-package helm-swoop
 :bind
 (("C-S-s"   . helm-swoop)
  ("M-i"     . helm-swoop)
  ("M-s s"   . helm-swoop)
  ("M-s M-s" . helm-swoop)
  ("M-I"     . helm-swoop-back-to-last-point)
  ("C-c M-i" . helm-multi-swoop)
  ("C-x M-i" . helm-multi-swoop-all)
  )
 :config
 (progn
   (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
   (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)))

;; Package: google the selected word
(use-package google-this
  :bind
  ("C-c g" . google-this)
  :config
  (google-this-mode 1))

;; Package: generic complRetion frontend
(use-package ivy
  :bind
  ("C-b" . ivy-switch-buffer)
  :config
  (progn
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "(%d/%d) ")
    (ivy-mode)))

;; Package: EVIL mode mouahahah!!!
;; TODO: see boon or modalka
;; Keybinding: https://github.com/emacs-evil/evil-collection
(use-package evil
  :config
  (progn
    (unbind-key "C-b" evil-motion-state-map)
    (evil-mode t)))

;; Package: focus on the current function
(use-package focus
  :config
  (focus-mode 1))

;; 
(use-package beacon
  :config
  (beacon-mode 1))

;;
(use-package highlight-symbol
  :config
  (highlight-symbol-mode 1))

;;
(use-package yaml-mode)

;;
(use-package toml-mode)

;; Package: project manager
(use-package projectile
  :commands projectile-mode
  :config
  ;; Completion for projectile
  (use-package counsel-projectile
    :requires ivy))

;; Package: auto-completion
(use-package company
  :config
  (progn
    (add-hook 'prog-mode-hook 'company-mode)
    ;; improve company-mode (icon, color, source...)
    (unless (version< emacs-version "26")
      (use-package company-box
         :hook (company-mode . company-box-mode)))))

;; Package: frontend for linting
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Package: great homepage for emacs
(use-package dashboard
  :config
  (progn
    ;; for emacsclient
    (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
    ;; configure the homepage
    (setq dashboard-items '((recents  . 5)
                            (bookmarks . 5)
                            (projects . 5)
                            (agenda . 5)
                            (registers . 5)))
    (dashboard-setup-startup-hook)))

;; Package: files tree view
(use-package neotree
  :bind
  ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme (if (display-graphic-p) 'nerd 'arrow)))

;; Package: git integration
;; TODO: shortcuts
(use-package magit)

;; Package: org
(use-package org
  :init
  (setq org-modules '(org-drill
                      org-mouse
                      org-protocol
                      org-annotate-filex
                      org-eval
                      org-expiry
                      org-interactive-query
                      org-man
                      org-collector
                      org-toc))
  :bind
  (("M-<right>" . windmove-right))
  :hook
  ;; Make windmove work in org-mode
  ;; TODO: works ?
  ((org-metaup . windmove-up)
   (org-metaleft . windmove-left)
   (org-metadown . windmove-down)
   (org-metaright . windmove-right))
  :config
  (progn
    (setq org-log-done t)
    (org-load-modules-maybe t)))

;; Package: Haskell
;; TODO: configuration
(use-package haskell-mode)

;; Package: Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Package: Go
(use-package go-mode
  :config
  (use-package company-go
    :config
    (progn
       ;; bigger popup window
      (setq company-tooltip-limit 20)
      ;; decrease delay before autocompletion popup shows
      (setq company-idle-delay .3)
      ;; remove annoying blinking
      (setq company-echo-delay 0)
      ;; start autocompletion only after typing
      (setq company-begin-commands '(self-insert-command))
      )))


;;
;; End
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil)
 '(package-selected-packages
   (quote
    (toml-mode yaml-mode highlight-symbol beacon focus exec-path-from-shell flycheck company-go go-mode cheatsheet counsel-projectile company-box company markdown-mode use-package smart-mode-line projectile neotree ivy helm-swoop haskell-mode guide-key google-this expand-region evil dashboard base16-theme auto-compile))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
