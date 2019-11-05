;;; package --- Emiliano Cabrera <emiliano@j3cb.net> email config file
;;; Commentary:
;;; This repository contains my Emacs email configuratio1n.
;;; Code:

;; Email Mu4e configuration example

;; This template contains a simple configuration that works on Gmail and Protonmail
;; accounts. It also assumes that you have install _mu_, _mu4e_ and _mbsync_.

;; I use mbsync + mu4e and smtp to send and review my email.

;; mbsync oficial page http://isync.sourceforge.net/mbsync.html

;; mu4e oficial http://www.djcbsoftware.nl/code/mu/mu4e.html


;; 1. Rename ~mbsyncrc.example~ to ~mbsyncrc~ and ~authinfo.example~ to ~authinfo~
;; an fill them with your own information.

;; 2. Encrypt ~authinfo~ with:
;; gpg2 --output authinfo.gpg --symmetric authinfo

;; 3. Delete ~authinfo~.

;; Configuration default settings example:

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

(require 'mu4e)
(require 'smtpmail)
(require 'org-mu4e)

(setq auth-sources
      '((:source "~/.emacs.d/authinfo.gpg")))


;; Default email configuration
(setq mu4e-maildir "your/maildir/path")
(setq send-mail-function 'smtpmail-send-it)
(setq user-full-name     "User Example")

;; Default smtp configuration
(setq smtpmail-debug-info t
      message-kill-buffer-on-exit t
      mu4e-get-mail-command "mbsync -V -a -c ~/.emacs.d/mbsyncrc")

;; show full addresses in view message (instead of just names)
;; toggle per name with M-RET
(setq mu4e-view-show-addresses t)

;; Useful to avoid name issues when you are moving around to many files
(setq mu4e-change-filenames-when-moving t)

;; Emails accounts contexts configuration

(setq mu4e-contexts
      `(,(make-mu4e-context
	  :name "protonmail"
	  :enter-func (lambda () (mu4e-message "Entering protonmail context"))
	  :leave-func (lambda () (mu4e-message "Leaving protonmail context"))
	  :vars '((user-mail-address      . "user@protonmail.com")
		  (user-full-name         . "User Example")

		  (mu4e-drafts-folder . "/protonmail/Drafts")
		  (mu4e-sent-folder   . "/protonmail/Sent")
		  (mu4e-trash-folder  . "/protonmail/Trash")

		  (smtpmail-default-smtp-server . "127.0.0.1")
		  (smtpmail-smtp-server         . "127.0.0.1")
		  (smtpmail-smtp-service        . 1025)
		  (smtpmail-smtp-user           . "user@protonmail.com")))
	,(make-mu4e-context
	  :name "gmail"
	  :enter-func (lambda () (mu4e-message "Entering gmail context"))
	  :leave-func (lambda () (mu4e-message "Leaving gmail context"))
	  :vars '((user-mail-address      . "user@gmail.com")
		  (user-full-name         . "User Example")

		  (mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
		  (mu4e-sent-folder   . "/gmail/[Gmail]/Sent Mail")
		  (mu4e-trash-folder  . "/gmail/[Gmail]/Trash")

		  (starttls-use-gnutls           . t)
		  (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
		  (smtpmail-local-domain         . "gmail.com")
		  (smtpmail-default-smtp-server  . "smtp.gmail.com")
		  (smtpmail-smtp-server          . "smtp.gmail.com")
		  (smtpmail-smtp-service         . 587)
		  (smtpmail-smtp-user            . "user@example.com")))))

;; start with the first (default) context;
;; default is to ask-if-none (ask when there's no context yet, and none match)
(setq mu4e-context-policy 'pick-first)

;; Redefining bookmarks:

;; Empty the initial bookmark list
(setq mu4e-bookmarks '())

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "All Trashes"
	      :query "maildir:/protonmail/Trash OR maildir:/gmail/[Gmail]/Trash"
	      :key ?T))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "All Spam"
	      :query "maildir:/protonmail/Spam OR maildir:/gmail/[Gmail]/Spam"
	      :key ?S))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "All Drafts"
	      :query "maildir:/protonmail/Drafts OR maildir:/gmail/[Gmail]/Draft"
	      :key ?d))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name  "Unread messages"
	      :query "flag:unread AND NOT flag:trashed"
	      :key ?u))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "All Sent Mail"
	      :query "maildir:/protonmail/Sent OR maildir:/gmail/[Gmail]/\"Sent Mail\""
	      :key ?s))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "All Inboxes"
	      :query "maildir:/protonmail/Inbox OR maildir:/gmail/Inbox"
	      :key ?i))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "Last month"
	      :query "date:31d..now"
	      :key ?m))

(add-to-list 'mu4e-bookmarks
	     (make-mu4e-bookmark
	      :name "Today's messages"
	      :query "date:today..now"
	      :key ?t))

;; Compose and view setttings from https://github.com/munen/emacs.d

(add-hook 'mu4e-compose-mode-hook 'flyspell-mode)

(defvar emilianork/message-attachment-regexp "\\([Ww]e send\\|[Ii] send\\|attach\\|angehängt\\|[aA]nhang\\|angehaengt\\|haenge\\|hänge\\)")
(defun emilianork/message-check-attachment ()
  "Check if there is an attachment in the message if I claim it."
  (save-excursion
    (message-goto-body)
    (when (search-forward-regexp emilianork/message-attachment-regexp nil t nil)
      (message-goto-body)
      (unless (or (search-forward "<#part" nil t nil)
		  (message-y-or-n-p
		   "No attachment. Send the message ?" nil nil))
	(error "No message sent")))))

(add-hook 'message-send-hook 'emilianork/message-check-attachment)

(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)

(add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)

(setq mu4e-compose-format-flowed t)

(add-hook 'mu4e-compose-mode-hook 'epa-mail-mode)
(add-hook 'mu4e-view-mode-hook 'epa-mail-mode)

(add-hook 'mu4e-view-mode-hook 'visual-line-mode)

(setq mu4e-compose-dont-reply-to-self t)

(add-to-list 'mu4e-user-mail-address-list "user@protonmail.com")
(add-to-list 'mu4e-user-mail-address-list "user@gmail.com")
