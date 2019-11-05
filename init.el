;;; package --- Emiliano Cabrera <emiliano@j3cb.net> init config file
;;; Commentary:
;;; This repository contains my Emacs configuratio1n.
;;; Code:

(defconst emacs-start-time (current-time))


;; Makes startup faster
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(add-hook 'after-init-hook
          `(lambda ()
             (setq gc-cons-threshold 800000
		   gc-cons-percentage 0.1)
             (garbage-collect)) t)

;; Load env variables
;; I have multiple computers and I use all of them.In order to reuse my emacs
;; configuration I use ~/.env.el to set variables that depend on each computer.

(if (file-exists-p "~/.env.el")
    (load-file "~/.env.el"))

;; Personal information that is not public.
(if (file-exists-p "~/.emacs.d/personal.el")
    (load-file "~/.emacs.d/personal.el"))

;; Define package repositories (archives).
(require 'package)

(package-initialize)

(setq package-archives
      '(("gnu"          . "http://elpa.gnu.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
	("melpa"        . "https://melpa.org/packages/")
	("marmalade"    . "https://marmalade-repo.org/packages/")))


;; A use-package declaration for simplifying your .emacs
;; repo https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(add-to-list 'package-selected-packages 'use-package)

;; Install themes

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(use-package apropospriate-theme
  :ensure t
  :config
  ;;(load-theme 'apropospriate-light t)
  (load-theme 'apropospriate-dark t)
  )

;; (use-package berrys-theme
;;   :ensure t
;;   :config
;;   (load-theme 'berrys t)

;;   :config ;; for good measure and clarity
;;   (setq-default cursor-type '(bar . 2))
;;   (setq-default line-spacing 2))

;; (use-package challenger-deep-theme :ensure t)
;; (use-package creamsody-theme :ensure t)

;; (use-package cyberpunk-theme
;;   :ensure t
;;   (load-theme 'cyberpunk t))

;; (use-package darkokai-theme :ensure t)
;; (use-package doneburn-theme :ensure t)
;; (use-package dracula-theme :ensure t)

;; (use-package gruvbox-theme
;;   :ensure t
;;   ;;(load-theme 'gruvbox-dark-hard t)
;;   (load-theme 'gruvbox-dark-medium t)
;;   ;;(load-theme 'gruvbox-dark-soft t)
;;   ;;(load-theme 'gruvbox-light-hard t)
;;   ;;(load-theme 'gruvbox-light-medium t)
;;   ;;(load-theme 'gruvbox-light-soft t)
;;   )

;; (use-package lab-themes :ensure t)
;; (use-package lenlen-theme :ensure t)
;; (use-package material-theme :ensure t)
;; (use-package monokai-alt-theme :ensure t)
;; (use-package monokai-theme :ensure t)
;; (use-package spacemacs-theme :ensure t)
;; (use-package sunburn-theme :ensure t)
;; (use-package twilight-bright-theme :ensure t)
;; (use-package zeno-theme :ensure t)
;; (use-package zerodark-theme :ensure t)

;; Install Packages

;; ag.el
;; An Emacs frontend to The Silver Searcher http://agel.readthedocs.org/en/latest/
;; repo https://github.com/Wilfred/ag.el
(use-package ag
  :defer 2
  :ensure t)

;; aggresive-indent-mode
;; Emacs minor mode that keeps your code always indented.  More reliable than
;; electric-indent-mode.
;; repo https://github.com/Malabarba/aggressive-indent-mode
(use-package aggressive-indent
  :defer 2
  :ensure t
  :diminish aggressive-indent-mode
  :init
  (dolist (mode-hook '(clojure-mode-hook
		       clojurec-mode-hook
		       clojurescript-mode-hook
		       emacs-lisp-mode-hook
		       go-mode-hook
		       json-mode-hook
		       python-mode-hook
		       ruby-mode-hook))

    (add-hook mode-hook 'aggressive-indent-mode)))

;; AUCTEX is an extensible package for writing and formatting TEX files in GNU
;; Emacs. It supports many different TEX macro packages, including AMS-TEX, LATEX,
;; Texinfo, ConTEXt, and docTEX (dtx files).
;; AUCTEX includes preview-latex which makes LATEX a tightly integrated component
;; of your editing workflow by visualizing selected source chunks
;; (such as single formulas or graphics ) directly as images in the source buffer.
;; repo https://elpa.gnu.org/packages/auctex.html
(use-package auctex
  :defer 2
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :init
  (progn
    (add-hook 'LaTeX-mode-hook
	      (lambda ()
		(visual-line-mode)
		(LaTeX-math-mode)
		(turn-on-reftex)

		(setq TeX-auto-save t)
		(setq TeX-parse-self t)
		(TeX-PDF-mode)
		(setq reftex-plug-into-AUCTeX t)

		(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
		(turn-on-auto-fill)
		(set-fill-column 80)))))


;; beacon
;; Whenever the window scrolls a light will shine on top of the cursor so I know
;; where it is.
;; repo https://github.com/Malabarba/beacon
(use-package beacon
  :ensure t
  :defer 2
  :diminish beacon-mode
  :init (beacon-mode t))

;; cider
;; The Clojure Interactive Development Environment that Rocks for Emacs
;; repo https://github.com/clojure-emacs/cider
(use-package cider
  :ensure t
  :defer 2
  :diminish cider-mode)

;; clojure-mode
;; Emacs support for the Clojure(Script) programming language.
;; repo https://github.com/clojure-emacs/clojure-mode
(defun emilianork/cider-figwheel-repl ()
  "Startups fidwheel repl inside a cider repl."
  (interactive)
  (with-current-buffer
      (cider-current-repl)
    (goto-char (point-max))
    (insert "(require 'figwheel-sidecar.repl-api)
	       (figwheel-sidecar.repl-api/start-figwheel!)
	       (figwheel-sidecar.repl-api/cljs-repl)"))
  (cider-repl-return))

(use-package clojure-mode
  :ensure t
  :defer 2
  :bind
  ("C-c M-f" . 'emilianork/cider-figwheel-repl))

;; command-log-mode repo https://github.com/lewang/command-log-mode

;; Show event history and command history of some or all buffers.

;; To start recording commands use M-X command-log-mode
;; To see the log buffer, call M-x clm/open-command-log-buffer.

;; The key strokes in the log are decorated with ISO9601 timestamps on
;; the property `:time' so if you want to convert the log for
;; screencasting purposes you could use the time stamp as a key into
;; the video beginning.
(use-package command-log-mode
  :ensure t
  :defer 2
  :diminish command-log-mode)

;; company
;; Modular in-buffer completion framework for Emacs http://company-mode.github.io/
;; repo https://github.com/company-mode/company-mode
(use-package company
  :ensure t
  :defer 2
  :diminish company-mode
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))


;; company-box
;; A company fron-end with icons
;; repo https://github.com/sebastiencs/company-box
(use-package company-box
  :ensure t
  :defer 2
  :after company
  :diminish company-box-mode
  :hook (company-mode . company-box-mode))

;; company-backends
(use-package company-auctex
  :defer 2
  :after (company latex))

(use-package company-elisp
  :defer 2
  :after company
  :config
  (push 'company-elisp company-backends))

(use-package company-go
  :defer 2
  :ensure t
  :after company
  :config
  (push 'company-go company-backends))

(use-package company-lsp
  :defer 2
  :ensure t
  :after company
  :config
  (push 'company-lsp company-backends))

(use-package company-terraform
  :defer 2
  :ensure t
  :after company
  :config
  (push 'company-terraform company-backends))

;; csv-mode
;; Major mode for editing comma/char separated values
;; repo https://elpa.gnu.org/packages/csv-mode.html
(use-package csv-mode
  :ensure t
  :defer 2)

;; counsel
;; Counsel, a collection of Ivy-enhanced versions of common Emacs commands.
;; repo https://github.com/abo-abo/swiper
(use-package counsel
  :ensure t
  :after (ivy swiper)
  :demand t
  :diminish
  :init
  (bind-key "C-r" #'counsel-minibuffer-history minibuffer-local-map)

  :bind
  (("M-x"     . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c g"   . counsel-git)
   ("C-c j"   . counsel-git-grep)
   ("C-c k"   . counsel-ag)
   ("C-x l"   . counsel-locate)
   ("M-y"     . counsel-yank-pop)
   ("C-S-o"   . counsel-rhythmbox)))

;; diminish
;; Diminished modes are minor modes with no modeline display.
;; repo https://github.com/myrjola/diminish.el
(use-package diminish
  :ensure t
  :defer 2
  :config
  (diminish 'auto-revert-mode)
  (diminish 'eldoc-mode)
  (diminish 'org-src-mode)
  (diminish 'cider-mode))

;; docker
;; Manage docker from Emacs.
;; repo https://github.com/Silex/docker.el
(use-package docker
  :ensure t
  :defer 2)

;; dockerfile
;; An emacs mode for handling Dockerfiles
;; repo https://github.com/spotify/dockerfile-mode
(use-package dockerfile-mode
  :ensure t
  :defer 2)

;; docker-tramp.el
;; TRAMP integration for docker containers.
;; repo https://github.com/emacs-pe/docker-tramp.el
(use-package docker-tramp
  :ensure t
  :defer 2)

;; dump-jump
;; An Emacs "jump to definition" package
;; repo https://github.com/jacktasia/dumb-jump
(use-package dumb-jump
  :ensure t
  :defer 2
  :init
  (dolist (mode-hook '(clojure-mode-hook
		       clojurec-mode-hook
		       clojurescript-mode-hook
		       emacs-lisp-mode-hook
		       python-mode-hook
		       ruby-mode-hook))

    (add-hook mode-hook 'dumb-jump-mode)))

;; editorconfig
;; EditorConfig plugin for emacs http://editorconfig.org
;; repo https://github.com/editorconfig/editorconfig-emacs
(use-package editorconfig
  :ensure t
  :defer 2
  :diminish editorconfig-mode
  :config (editorconfig-mode 1))

;; elfeed
;; repo https://github.com/skeeto/elfeed
;; Elfeed is an extensible web feed reader for Emacs, supporting both Atom
;; and RSS.
(use-package elfeed
  :ensure t
  :defer 2
  :custom
  (elfeed-feeds my-personal-feeds)
  (elfeed-db-directory "~/.emacs.d/elfeed"))

;; expand-region.el
;; Expand region increases the selected region by semantic units. Just keep
;; pressing the key until it selects what you want.
;; repo https://github.com/magnars/expand-region.el
(use-package expand-region
  :ensure t
  :defer 2
  :init (global-set-key (kbd "C-c =") 'er/expand-region))

;; flycheck
;; Flycheck is a modern on-the-fly syntax checking extension for GNU Emacs,
;; intended as replacement for the older Flymake extension which is part of
;; GNU Emacs. For a detailed comparison to Flymake see Flycheck versus
;; Flymake.
;; repo http://www.flycheck.org/en/latest/
(use-package flycheck
  :ensure t
  :defer 2
  :diminish flycheck-mode
  :config (global-flycheck-mode))

(use-package flycheck-inline
  :ensure t
  :defer 2
  :diminish flycheck-inline-mode
  :config (global-flycheck-inline-mode))


;; git-gutter
;; Emacs port of GitGutter which is Sublime Text Plugin.
;; repo https://github.com/syohex/emacs-git-gutter
(use-package git-gutter-fringe
  :ensure t
  :defer 2
  :diminish git-gutter-mode
  :config
  (global-git-gutter-mode))

;; go-mode
;; Emacs mode for the Go programming language
;; repo https://github.com/dominikh/go-mode.el
(use-package go-mode
  :ensure t
  :defer 2)

;; gradle-mode
;; Minor mode for emacs to run gradle from emacs and not have to go to a
;; terminal!
;; repo https://github.com/jacobono/emacs-gradle-mode
(use-package gradle-mode
  :ensure t
  :defer 2)

;; grails-mode
;; A groovy major mode, grails minor mode, and a groovy inferior mode.
;; repo https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes
(use-package grails-mode
  :ensure t
  :defer 2)

;; groovy-mode
;; A groovy major mode, grails minor mode, and a groovy inferior mode.
;; repo https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes
(use-package groovy-mode
  :ensure t
  :defer 2)

;; hungry-delete
;; This package implements hungry deletion, meaning that deleting a whitespace
;; character will delete all whitespace until the next non-whitespace character.
;; repo https://github.com/nflath/hungry-delete
(use-package hungry-delete
  :ensure t
  :defer 2
  :diminish hungry-delete-mode
  :init (global-hungry-delete-mode))

;; ivy
;; Ivy, a generic completion mechanism for Emacs.
;; repo https://github.com/abo-abo/swiper
(use-package ivy
  :ensure t
  :defer 1
  :diminish ivy-mode
  :demand t
  :init
  (progn
    (add-hook 'pdf-view-mode-hook
	      '(lambda()
		 (define-key pdf-view-mode-map "\C-s" 'isearch-forward))))
  :config
  (ivy-mode t)

  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)

  :bind
  (("C-c C-r" . ivy-resume)
   ("<f6>"    . ivy-resume)
   ("C-x b"   . ivy-switch-buffer)))

;; json-mode
;; Major mode for editing JSON files.
;;
;; Extends the builtin js-mode to add better syntax highlighting for JSON and
;; some nice editing keybindings.
;; repo https://github.com/joshwnj/json-mode/tree/master
(use-package json-mode
  :ensure t
  :defer 2)

;; kubernetes-el
;; A magit-style interface to the Kubernetes command-line client.
;; repo https://github.com/chrisbarrett/kubernetes-el
(use-package kubernetes
  :ensure t
  :defer 2
  :commands (kubernetes-overview))

;; lolcat
;; Rainbows and unicorns in Emacs Lisp!
;; repo https://github.com/xuchunyang/lolcat.el
(use-package lolcat
  :ensure t
  :defer 2)


;; Magit
;; It's Magit! A Git porcelain inside Emacs.
;; repo https://github.com/magit/magit/tree/master
(use-package magit
  :ensure t
  :defer 2)

;; markdown-mode
;; markdown-mode is a major mode for editing Markdown-formatted text.
;; repo https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :ensure t
  :defer 2)

;; multi-term
;; Managing multiple terminal buffers in Emacs.
;; repo https://github.com/emacsorphanage/multi-term/
(use-package multi-term
  :ensure t
  :custom (multi-term-buffer-name "Term")
  :config
  ;; This code was copy paste from the internet long time ago but I don't
  ;; remember from who (sorry for the credits).
  (defun emilianork/multi-term-here ()
    "Opens up a new shell in the directory associated with the
  current buffer's file. The shell is renamed to match that
  directory to make multiple shell windows easier."
    (interactive)
    (let* ((height (/ (window-total-height) 2)))
      (split-window-vertically (- height))
      (other-window 1)
      (multi-term)))

  (defun emilianork/multi-term-kill ()
    "Send ESC in term mode."
    (interactive)
    (term-send-raw-string "exit\n")
    (delete-window))

  (add-hook 'term-mode-hook
	    (lambda ()
	      (setq show-trailing-whitespace nil)))

  (global-set-key (kbd "C-!") 'emilianork/multi-term-here)
  (global-set-key (kbd "C-#") 'emilianork/multi-term-kill))

;; nyan-cat
;; Nyan Mode - Turn your Emacs into Nyanmacs! :)
;;  repo https://github.com/TeMPOraL/nyan-mode
(use-package nyan-mode
  :ensure t
  :defer 2
  :config
  (nyan-mode 0))

;; org-bullets
;; Show org-mode bullets as UTF-8 characters.
;; repo https://github.com/emacsorphanage/org-bullets
(use-package org-bullets
  :ensure t
  :defer 2
  :init (add-hook 'org-mode-hook 'org-bullets-mode))


;; org-recur
;;Recurring org-mode tasks
;; repo https://github.com/m-cat/org-recur
(use-package org-recur
  :ensure t
  :hook ((org-mode . org-recur-mode)
         (org-agenda-mode . org-recur-agenda-mode))
  :demand t
  :config
  (define-key org-recur-mode-map (kbd "C-c d") 'org-recur-finish)

  ;; Rebind the 'd' key in org-agenda (default: `org-agenda-day-view').
  (define-key org-recur-agenda-mode-map (kbd "d") 'org-recur-finish)
  (define-key org-recur-agenda-mode-map (kbd "C-c d") 'org-recur-finish)

  (setq org-recur-finish-done t
        org-recur-finish-archive t))

;; org-ref
;; org-mode modules for citations, cross-references, bibliographies in org-mode
;; and useful bibtex tools to go with it.
;; repo https://github.com/jkitchin/org-ref
(use-package org-ref
  :ensure t
  :defer 2
  :config
  (setq org-ref-default-bibliography '(my-personal-default-bib)))

;; org-super-agenda
;; Supercharge your Org daily/weekly agenda by grouping items
;; repo https://github.com/alphapapa/org-super-agenda
(use-package org-super-agenda
  :ensure t
  :defer 2
  :after org-agenda
  :config
  (org-super-agenda-mode)

  (setq org-super-agenda-unmatched-name "Other")
  (setq org-super-agenda-groups my-personal-agenda-groups))

;; ovpn
;; An openvpn management mode for emacs
;; repo https://github.com/anticomputer/ovpn-mode
(use-package ovpn-mode
  :ensure t
  :defer 2)

;; paredit
;; Minor mode for editing parentheses
;; Links of interest:
;; http://danmidwood.com/content/2014/11/21/animated-paredit.html
;; repo https://melpa.org/packages/paredit-20171126.1805.el
(use-package paredit
  :ensure t
  :defer 2
  :diminish paredit-mode
  :init
  (dolist (mode-hook '(cider-repl-mode-hook
		       clojure-mode-hook
		       clojurec-mode-hook
		       clojurescript-mode-hook
		       emacs-lisp-mode-hook))

    (add-hook mode-hook 'paredit-mode)))

;; parrot-mode
;; A package to rotate text and party with parrots at the same time
;; repo https://github.com/dp12/parrot
(use-package parrot
  :ensure t
  :defer 2
  :config (parrot-mode))

;; powerline
;; Emacs version of the Vim powerline.
;; repo https://github.com/milkypostman/powerline
(use-package powerline
  :ensure t
  :defer 2
  :init (powerline-default-theme))

;; projectile
;; Project Interaction Library for Emacs https://www.projectile.mx
;; repo https://github.com/bbatsov/projectile
(use-package projectile
  :ensure t
  :defer 2
  :diminish projectile-mode
  :config (progn
	    (projectile-mode 1)
	    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)))

;; rainbow-delimiters
;; rainbow-delimiters is a "rainbow parentheses"-like mode which highlights
;; delimiters such as parentheses, brackets or braces according to their depth.
;; Each successive level is highlighted in a different color.
;; repo https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :defer 2
  :init
  (dolist (mode-hook '(cider-repl-mode-hook
		       clojure-mode-hook
		       clojurec-mode-hook
		       clojurescript-mode-hook
		       emacs-lisp-mode-hook
		       go-mode-hook
		       json-mode-hook
		       terraform-mode-hook))
    (add-hook mode-hook 'rainbow-delimiters-mode)))


;; smartparens
;; Minor mode for Emacs that deals with parens pairs and tries to be smart about
;; it.
;; repo [[https://github.com/Fuco1/smartparens/tree/master]]
(use-package smartparens
  :ensure t
  :defer 2
  :diminish smartparens-strict-mode
  :init
  (add-hook 'c-mode-common-hook #'smartparens-strict-mode))

;; spinner.el
;; Add spinners and progress-bars to the mode-line for ongoing operations.
;; repo https://github.com/Malabarba/spinner.el
(use-package spinner
  :ensure t
  :defer 2)

;; swiper
;; Swiper, an Ivy-enhanced alternative to isearch.
;; repo https://github.com/abo-abo/swiper
(use-package swiper
  :ensure t
  :after ivy
  :bind
  (("C-s" . swiper)))

;; terraform-mode
;; Major mode of Terraform configuration file
;; repo https://github.com/syohex/emacs-terraform-mode
(use-package terraform-mode
  :ensure t
  :defer 2)

;; undo-tree
;; repo https://elpa.gnu.org/packages/undo-tree.html
(use-package undo-tree
  :ensure t
  :defer 2
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t))

;; vlf
;; Emacs minor mode that allows viewing, editing, searching and comparing large
;; files in batches, trading memory for processor time.
;; repo https://github.com/m00natic/vlfi
(use-package vlf
  :ensure t
  :defer 2)

;; which-key
;; Emacs package that displays available keybindings in popup
;; repo https://github.com/justbur/emacs-which-key/
(use-package which-key
  :ensure t
  :defer 1
  :diminish which-key-mode
  :config
  (progn
    (which-key-mode)
    (setq which-key-idle-delay 0.3)))

;; yaml-mode
;;  The emacs major mode for editing files in the YAML data serialization
;; format.
;; repo https://github.com/yoshiki/yaml-mode
(use-package yaml-mode
  :ensure t
  :defer 2)

;; yasnippet
;; YASnippet is a template system for Emacs. It allows you to type an abbreviation
;; and automatically expand it into function templates. Bundled language templates
;; include: C, C++, C#, Perl, Python, Ruby, SQL, LaTeX, HTML, CSS and more.
;; repo https://github.com/joaotavora/yasnippet
(use-package yasnippet
  :ensure t
  :defer 2
  :diminish yas-minor-mode
  :init
  (progn
    (yas-global-mode 1)
    ;; we don't want yasnippet running in terminals
    (add-hook 'term-mode-hook (lambda()
				(yas-minor-mode -1)))))

(use-package yasnippet-snippets
  :ensure t
  :defer 2)

;; zone-nyan
;; Nyanyanyanyanyanyanyanyan.
;; repo https://github.com/wasamasa/zone-nyan
(use-package zone-nyan
  :ensure t
  :defer 2)

;; Custom functions that add/modify Emacs functionality.

(defun emilianork/revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun emilianork/rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
	  (message "A buffer named '%s' already exists!" new-name)
	(progn
	  (rename-file filename new-name 1)
	  (rename-buffer new-name)
	  (set-visited-file-name new-name)
	  (set-buffer-modified-p nil))))))

(defun emilianork/indent-whole-buffer ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun emilianork/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
	(set-difference (buffer-list)
			(cons (current-buffer)
			      (mapcar (lambda (x) (process-buffer x)) (process-list))))))


;; Code from FrankRuben27 reddit user.
(defun emilianork/goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
	(linum-mode 1)
	(call-interactively #'goto-line))
    (linum-mode -1)))


(defun emilianork/create-scratch-buffer ()
  "Create scratcg buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(global-set-key (kbd "M-n b r") 'emilianork/revert-buffer-no-confirm)
(global-set-key (kbd "M-n b i") 'emilianork/indent-whole-buffer)
(global-set-key (kbd "M-n b k") 'emilianork/kill-other-buffers)

;; go-to is binded to more than one keyscombination.
(global-set-key (kbd "M-g M-g") 'emilianork/goto-line-with-feedback)
(global-set-key (kbd "M-g g")   'emilianork/goto-line-with-feedback)

(global-set-key (kbd "C-c a") 'org-agenda)

(when (fboundp 'eww)
  (defun xah-rename-eww-buffer ()
    "Rename `eww-mode' buffer so sites open in new page.
  URL `http://ergoemacs.org/emacs/emacs_eww_web_browser.html'
  Version 2017-11-10"
    (let (($title (plist-get eww-data :title)))
      (when (eq major-mode 'eww-mode )
	(if $title
	    (rename-buffer (concat "eww " $title ) t)
	  (rename-buffer "eww" t)))))

  (add-hook 'eww-after-render-hook 'xah-rename-eww-buffer))

;; Default settings

;; Font
(set-frame-font "VictorMono")
(set-face-attribute 'default nil :height (string-to-number (or (getenv "FONT-SIZE") "90")))

;; erase-buffer is considered to be confusing for beginners
(put 'erase-buffer 'disabled nil)
(global-set-key (kbd "C-c E")  'erase-buffer)

;; upcase-region is considered to be confusing for beginners
(put 'upcase-region 'disabled nil)

;; Do NOT create backupfiles
(setq make-backup-files nil)

;; Cursor customization
(global-hl-line-mode t)
(setq-default cursor-type 'box)

;; Scroll one line at a time
(setq scroll-step 1)

;; Do NOT accelerate scrolling
(setq mouse-wheel-progressive-speed nil)

;; Enable scroll with mouse
(setq mouse-wheel-follow-mouse 't)

;; Indent using spaces, not tabs by default
(setq-default ndent-tabs-mode nil)

;; No Splash Screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; Do NOT show scroll-bar, menur bar and tool bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Initial major mode
(setq initial-major-mode 'text-mode)

;; ispell default dictionary
(setq ispell-dictionary "castellano")

;; Show column number
(setq column-number-mode t)

;; Set internal border settings
(setq internal-border-width 10)

;; Text scalation key-bindings
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; Buffers has unique names, even when two different files with same name
;; are open.
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)


;; Init show-paren-mode to only some buffers
(add-hook 'after-init-hook
	  (lambda ()
	    (dolist (mode-hook '(cider-repl-mode-hook
				 clojure-mode-hook
				 clojurec-mode-hook
				 clojurescript-mode-hook
				 emacs-lisp-mode-hook
				 go-mode-hook
				 json-mode-hook
				 python-mode-hook
				 ruby-mode-hook))

	      (add-hook mode-hook 'show-paren-mode))))

;; Dired default configuration
(setq-default dired-listing-switches "-alh")

;; Enable windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Enables winner-mode
(winner-mode 1)

;; Automated custom params saved by Emacs in it's own file
(setq custom-file "~/.emacs.d/custom-settings.el")
(load custom-file t)

;; When text is marked, if I type another key, the text will be deleted.
(delete-selection-mode t)

;;; Finalization
(let ((elapsed (float-time (time-subtract (current-time)
                                          emacs-start-time))))
  (message "Loading %s...done (%.3fs)" load-file-name elapsed))

(add-hook 'after-init-hook
          `(lambda ()
             (let ((elapsed
                    (float-time
                     (time-subtract (current-time) emacs-start-time))))
               (message "Loading %s...done (%.3fs) [after-init]"
                        ,load-file-name elapsed))) t)
