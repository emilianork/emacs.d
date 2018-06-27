;;; package --- Emiliano Cabrera <jemiliano.cabrera@protonmail.com> Emacs config
;;; Commentary:
;;   - All of the configuration is within `configuration.org`
;;; Code:

(package-initialize)

;; This loads the actual configuration in literate org-mode elisp
(defun emilianork/load-config ()
  (interactive)
  (org-babel-load-file "~/.emacs.d/configuration.org"))

(emilianork/load-config)
