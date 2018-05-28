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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(package-selected-packages
   (quote
    (org-trello zone-nyan yaml-mode vlf use-package undo-tree sunburn-theme spacemacs-theme rainbow-delimiters powerline paredit org-bullets nyan-mode multi-term monokai-theme monokai-alt-theme material-theme markdown-mode magit git-gutter-fringe fringe-current-line exec-path-from-shell esup elfeed editorconfig dumb-jump dracula-theme dockerfile-mode docker diminish darkokai-theme cyberpunk-theme csv counsel-tramp company-terraform company-go cider challenger-deep-theme beacon auctex alert aggressive-indent ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
