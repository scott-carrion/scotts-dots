;;; doom-post-install.el --- Headless asset installer for Doom Emacs -*- lexical-binding: t; -*-

(require 'cl-lib)

;; Add Straight's built package directories to load-path
(let ((build-root (expand-file-name ".local/straight/" user-emacs-directory)))
  (when (file-directory-p build-root)
    (dolist (dir (directory-files build-root t "^build-"))
      (when (file-directory-p dir)
        (let ((default-directory dir))
          (normal-top-level-add-subdirs-to-load-path))))))

;; Suppress any unexpected interactive y/n prompts during execution
(cl-letf (((symbol-function 'yes-or-no-p) (lambda (&rest _) t))
          ((symbol-function 'y-or-n-p)    (lambda (&rest _) t)))

  ;; Install Nerd Fonts (Symbols Nerd Font Mono)
  (message "--> Installing nerd-icons fonts...")
  (require 'nerd-icons)
  (nerd-icons-install-fonts t)

  ;; Download the pre-built libghostty-vt dynamic module
  (message "--> Downloading ghostel native module...")
  (require 'ghostel)
  (ghostel-download-module)

  (message "--> Headless asset setup complete."))
