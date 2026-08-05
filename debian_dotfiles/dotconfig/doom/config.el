;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Bare metal install notes (non-nix):
;; NOTE: Symbols Nerd Font is needed. https://nerdfonts.com. (M-x nerd-icons-install-fonts)
;; NOTE: ripgrep is needed (apt install ripgrep)
;; NOTE: fd is needed (apt install fd-find)
;; NOTE: lsp module must be enabled for cc layer to work properly: https://langserver.org/
;;       ccls (apt install ccls) works with eglot (default), and it needs to consume a compile_commands.json.
;;       Setting CMAKE_EXPORT_COMPILE_COMMANDS to ON in CMake causes it to be generated in the build directory,
;;       but by default ccls expects it in the project root. Symlinking is the easiest way to do this, but
;;       supposedly you can also change eglot-server-programs to invoke ccls with the compilationDatabaseDirectory
;;       option to point it to the build directory. That is complex elisp tinkering that I want to avoid.
;;
;;       For CMake LSP support, neomakelsp or cmake-language-server are needed
;;
;;       Relevant docs:
;;       https://joaotavora.github.io/eglot/#Setting-Up-LSP-Servers
;;       https://github.com/MaskRay/ccls/wiki/Project-Setup#compile_commandsjson
;;
;; NOTE: Shockingly, the ghostel terminal emulator just works. Use char mode C-c C-l to have all input pass to the
;;       terminal. The only way out of this mode is M-RET, which is perfect.
;;       There is a persp-mode binding active here, so it's easy to leave char mode once done with the terminal and
;;       then swap perspectives. The default C-c bindings also claim to help with copying scrollback

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;(setq doom-theme 'doom-one)
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq doom-font (font-spec :family "Iosevka" :size 16 :weight 'normal :width 'normal))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Add hook to activate magit-delta by default
(add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1)))

;; Enable magit-todos plugin
(use-package! magit-todos
  :after magit
  :config
  (magit-todos-mode 1))

;; Enable smart soft word wrapping everywhere
(+global-word-wrap-mode +1)

;; Enable sidecar-locals, and set allow-list
(sidecar-locals-mode)
(setq sidecar-locals-paths-allow (list "~/Documents/code/*"))

;; Compilation buffer skips past warnings but still counts them
(setq-default compilation-skip-threshold 2)

;; Extend org mode todo keywords to include more states for local task tracking
(after! org (setq-default org-todo-keywords
                          '((sequence "TODO(t)"
                                      "NEXT(n)"
                                      "IN_PROGRESS(p!)"
                                      "IN_REVIEW(r!)"
                                      "|"
                                      "DONE(d!)")
                            (sequence "BLOCKED(b@)")
                            (sequence "|"
                                      "CANCELLED(c@)")
                            (sequence "LATER(l@)")
                            (sequence "MAYBE(m@)"))))

;; Set corresponding faces for each of the items above
(after! org (setq-default org-todo-keyword-faces
                          '(("TODO". org-todo)
                            ("NEXT" . +org-todo-active)
                            ("IN_PROGRESS" . org-priority)
                            ("IN_REVIEW" . org-footnote)
                            ("DONE" . org-done)
                            ("BLOCKED" . +org-todo-onhold)
                            ("CANCELLED" . +org-todo-cancel)
                            ("LATER" . org-document-title)
                            ("MAYBE" . org-dispatcher-highlight))))

;; Set catppuccin theme flavor. Options: frappe, latte, macchiato, or mocha
(setq catppuccin-flavor 'macchiato)

;; Set buffer display name "unique-ification" strategy
(setq uniquify-buffer-name-style 'forward)

;; Modeline configuration
(setq doom-modeline-display-default-persp-name t)
(setq doom-modeline-persp-name t)

;; Add hook to enable themed view in PDF minor mode
(add-hook 'pdf-view-mode-hook #'pdf-view-themed-minor-mode)

;; Useful layout for GDB debugging
(setq gdb-many-windows t)
(setq gdb-debuginfod-enable-setting t)
(setq gdb-restore-window-configuration-after-quit t)
(setq gdb-stack-buffer-addresses t)

(defvar +scc/gdb-shortcut-command-line-args nil
  "The gdb command line arguments to use for gdb shortcut")

(defun +scc/gdb-shortcut ()
  "Shortcut to launch gdb with arguments given by +scc/gdb-shortcut-command-line-args"
  (interactive)
  (gdb +scc/gdb-shortcut-command-line-args))

(defun +scc/gdb-shortcut-no-args ()
  "Shortcut to launch gdb as if invoked with M-x gdb"
  (interactive)
  (gdb (list (gud-query-cmdline 'gdb))))

;; Keybindings
;; Useful reference:
;; https://discourse.doomemacs.org/t/how-to-re-bind-keys/56
;; https://rameezkhan.me/posts/2020/2020-07-03--adding-keybindings-to-doom-emacs/

;; Misc
(map! "C-h" 'backward-delete-char)

;; Window management: SPC w
;; Replaces SPC w x (evil-window-exchange) with kill-buffer-and-window
(map! :leader
      :desc "Kill buffer and window" "w x" #'kill-buffer-and-window
      :desc "evil-window-split" "w -" #'evil-window-split
      :desc "evil-window-split-vertical" "w /" #'evil-window-vsplit)

;; Navigation: SPC j
;; Avy does have variants of these restricting candidates to above/below cursor and in same line,
;; but I don't really think I'll be using them too much
(map! :leader
      (:prefix ("j" . "jump to")
       :desc "String" "j" #'avy-goto-char-timer
       :desc "Line" "l" #'avy-goto-line
       :desc "Word" "w" #'avy-goto-word-0
       :desc "Word starting with char" "W" #'avy-goto-word-1
       :desc "Char x1" "k" #'avy-goto-char
       :desc "Char x2" "K" #'avy-goto-char-2
       :desc "Last change" "c" #'goto-last-change
       :desc "Next change" "C" #'goto-last-change-reverse
       :desc "File (deer)" "d" #'deer
       :desc "File (ranger)" "r" #'ranger))

;; Workspaces: SPC l
;; This just remaps the workspaces from SPC TAB to SPC l
;; Reference: https://github.com/doomemacs/core/issues/4569
;; The comment about which-key labels not going with the move seems inaccurate, this works fine
(map! :leader :desc "workspaces" "l" doom-leader-workspace-map "TAB")
(map! :leader
      :desc "Switch to last workspace" "l TAB" #'+workspace/other
      :desc "Display tab bar" "l i" #'+workspace/display)

;; Clipboard: SPC y
(map! :leader
      (:prefix ("y" . "yank")
       :desc "copy" "y" #'clipboard-kill-ring-save
       :desc "paste" "p" #'clipboard-yank
       :desc "remember clipboard" "r" #'remember-clipboard))

;; Highlighting: SPC H
(defun clear-all-highlights ()
  "Toggles hi-lock-mode to clear all highlighting"
  (interactive)
  (hi-lock-mode 0)
  (hi-lock-mode 1))

(map! :leader
      (:prefix ("H" . "highlight")
       :desc "Symbol at point" "." #'highlight-symbol-at-point
       :desc "Regexp" "r" #'highlight-regexp
       :desc "Clear regexp" "u" #'unhighlight-regexp
       :desc "Clear all" "C" #'clear-all-highlights))

;; Projectile: SPC p
(map! :leader
      :desc "Install project" "p I" #'projectile-install-project
      :desc "Package project" "p P" #'projectile-package-project)

;; GDB
(map! :leader
      :desc "gdb (shortcut)" "o g" #'+scc/gdb-shortcut
      :desc "gdb" "o G" #'+scc/gdb-shortcut-no-args)


;; Ghostel (terminal)
(map! :after ghostel
      :map ghostel-mode-map
      :desc "Switch to last workspace" "C-c TAB" #'+workspace/other)

;; PDF tool tweaks
;; This makes middle mouse click into a "hand tool"-esque pan
(defun +scc/pdf-view-hand-tool (event)
  "Pan the PDF by clicking and dragging, like a hand tool."
  (interactive "e")
  (let* ((start-pos (mouse-pixel-position))
         (start-x (cadr start-pos))
         (start-y (cddr start-pos))
         (start-vscroll (window-vscroll nil t))
         (start-hscroll (window-hscroll)))
    (track-mouse
      (let ((done nil))
        (while (not done)
          (let ((e (read-event)))
            (cond
             ((mouse-movement-p e)
              (let* ((new-pos (mouse-pixel-position))
                     (new-x (cadr new-pos))
                     (new-y (cddr new-pos)))
                (when (and new-x new-y start-x start-y)
                  (let ((dy (- start-y new-y))
                        (dx (/ (- start-x new-x) (frame-char-width))))
                    ;; Dynamically scroll the window based on pixel displacement
                    (set-window-vscroll nil (max 0 (+ start-vscroll dy)) t)
                    (set-window-hscroll nil (max 0 (+ start-hscroll dx)))))))

             ;; End the drag when the mouse button is released
             ((memq (car-safe e) '(drag-mouse-1 drag-mouse-2 drag-mouse-3
                                   mouse-1 mouse-2 mouse-3
                                   up-mouse-1 up-mouse-2 up-mouse-3))
              (setq done t)))))))))

;; Bind the new hand tool to pdf-view-mode
(map! :after pdf-tools
      :map pdf-view-mode-map
      "<down-mouse-2>" #'+scc/pdf-view-hand-tool)
