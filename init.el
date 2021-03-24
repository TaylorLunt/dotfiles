;; =============================================================================
;; TODO
;; =============================================================================
;; NOTE if something isn't working, check if :demand should be set
;;
;; Global:
;; TODO use #' instead of ' where appropriate
;; Fix:
;; TODO get ligatures working in programming modes
;; TODO get which-key paging keybindings working
;; TODO elisp files are colored incorrectly; some faces are not being set
;; TODO hl-todo causes a segfault when enabled for some reason
;; TODO org mode: g e to go up to next heading etc.
;; TODO Failed to install evil-org-agenda: Package "evil-org-agenda-" is unavailable
;; Packages:
;; TODO LSP: better keybindings for some lsp functionality like lsp-find-definition, lsp-find-references, etc.
;; TODO LSP: setup debugger (dap-mode)
;; TODO emacs-tree-sitter: better, faster syntax highlighting and structure editing(!)
;; TODO smartparens? paredit? emacs-tree-sitter?
;; TODO projectile: projectile and lsp projectile integration
;; TODO typo.el: in markdown mode only, and toggle with SPC t something
;; TODO yascroll
;; TODO magithub
;; TODO magit evil keybindings
;; Languages:
;; TODO Bash
;; TODO C and C++
;; TODO Elixir (and Erlang)
;; TODO GDscript
;; TODO Grammarly has lsp-mode support lol
;; TODO HTML/CSS/Javascript/JSON
;; TODO Haskell
;; TODO Java
;; TODO Markdown
;; TODO Python: use Black for formatting
;; TODO Rust
;; TODO SQL
;; TODO Latex; Latex org integration
;; TODO XML/YAML/TOML

(setq user-full-name "Taylor Lunt"
      user-mail-address "taylorlunt@gmail.com")
;; =============================================================================
;; GENERAL
;; =============================================================================
;; Clean up the interface
(setq inhibit-startup-message t)
(setq visible-bell t)
(setq frame-resize-pixelwise t) ;; for tiling window manager
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)

;; Fonts
;; The following must use default-frame-alist rather than set-face-attribute, otherwise
;; emacsclient starts with the wrong font size compared to emacs proper
(add-to-list 'default-frame-alist '(font . "Fantasque Sans Mono-12"))
(set-face-attribute 'variable-pitch nil :font "Noto Sans" :height 126 :weight 'regular)


;; Performance (or the illusion thereof)
;; emacs >= 27 required:
;; (setq bidi-inhibit-bpa t)
(setq bidi-paragraph-direction 'left-to-right)
(setq-default bidi-paragraph-direction 'left-to-right)
(setq echo-keystrokes 0.01)
;; lower than default undo limit so it doesn't crash my emacs
(setq undo-limit 40000
      undo-outer-limit 8000000
      undo-strong-limit 100000)
(setq gc-cons-threshold 100000000) ;; recommended for lsp-mode
;; emacs >= 27 required:
;; (setq read-process-output-max (* 1024 1024)) ;; 1mb read: recommended for lsp-mode

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Scrolling
(setq mouse-wheel-scroll-amount '(2 ((control) . 5))) ;; two lines at a time unless control held

;; Auto-saving
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 5)  ;; save after 5 seconds of idle time
(setq backup-directory-alist
      `(("." . ,"~/.emacs.d/backups")))

;; Scratch buffer
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message nil)

;; =============================================================================
;; PACKAGES AND KEYBINDINGS
;; =============================================================================
;; Set up use-package
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
    ("org" . "https://orgmode.org/elpa/")
    ("elpa" . "https://elpa.gnu.org/packages/")))
;; fix a bug relating to downloading packages: (probably not required after emacs 26.3)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)                    ;
(unless package-archive-contents
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
    (package-install 'use-package))
(require 'use-package)
(setq use-package-always-defer t)
(setq use-package-always-ensure t)

;; Setup general -- better keybindings and leader key
(use-package general
    :demand
    :config
    (general-evil-setup t)
    (general-create-definer taylor-gl/leader-key-def
        :states '(normal insert visual emacs)
        :keymaps 'override
        :prefix "SPC"
        :global-prefix "C-SPC"
        "" '(:ignore t :which-key "<leader>")
        )
    ;; many of these come from doom emacs
    (taylor-gl/leader-key-def
        "SPC" 'save-buffer
        "RET" 'counsel-bookmark
        "TAB" '(lambda (&optional arg) (interactive "P")(org-agenda arg "n")) ;; open agenda and all TODOs directly
        "/" 'comment-line
        ":" 'counsel-M-x
        ";" 'pp-eval-expression
        "b" '(:ignore t :which-key "buffer")
        "b b" '(counsel-switch-buffer :which-key "switch buffers")
        "b d" '(kill-current-buffer :which-bey "kill this buffer")
        "b D" '(kill-buffer :which-key "kill a buffer")
        "b k" '(crux-kill-other-buffers :which-key "kill all other buffers")
        "b n" '(next-buffer :which-key "next buffer")
        "b p" '(crux-switch-to-previous-buffer :which-key "previous buffer")
        "b m" '(bookmark-set :which-key "bookmark")
        "b M" '(bookmark-delete :which-key "remove bookmark")
        "e" '(:ignore t :which-key "edit")
        "e y" '(flycheck-copy-errors-as-kill :which-key "yank error")
        "e f" '(flycheck-list-errors :which-key "flycheck buffer")
        "e n" '(flycheck-next-error :which-key "next error")
        "e p" '(flycheck-list-errors :which-key "previous error")
        "e v" '(flycheck-verify-setup :which-key "verify flycheck checker")
        "f" '(:ignore t :which-key "file")
        "f i" '(crux-find-user-init-file :which-key "find init.el")
        "f d" '(dired-jump :which-key "dir of this file")
        "f f" '(counsel-find-file :which-key "find file")
        "f l" '(counsel-locate :which-key "locate file")
        "f r" '(counsel-recentf :which-key "recent file")
        "f SPC" '(write-file :which-key "save file as...")
        "g" '(:ignore t :which-key "git")
        "g B" '(magit-blame-addition :which-key "blame")
        "g g" '(magit-status :which-key "status")
        "g G" '(magit-status-here :which-key "status here")
	;; replaced by bookmarking todo.org
        ;; "t" '((lambda () (interactive)(counsel-find-file "~/Dropbox/emacs/todo.org")) :which-key "todo.org")
        "h" '(:ignore t :which-key "help")
        "h b" '(describe-personal-keybindings :which-key "describe personal keybindings")
        "h c" '(describe-char :which-key "describe char")
        "h e" '(view-echo-area-messages :which-key "show echo")
        "h f" '(describe-function :which-key "describe function")
        "h k" '(describe-key-briefly :which-key "describe key")
        "h K" '(describe-key :which-key "describe key in depth")
        "h m" '(describe-mode :which-key "describe modes")
        "h M" '(+default/man-or-woman :which-key "man page")
        "h v" '(describe-variable :which-key "describe variable")
        "i" '(:ignore t :which-key "insert snippet")
        "i d" '(crux-insert-date :which-key "insert date")
        "i e" '(yas-visit-snippet-file :which-key "edit snippet")
        "i n" '(yas-new-snippet :which-key "new snippet")
        "i s" '(yas-insert-snippet :which-key "insert snippet")
        "i x" '(crux-delete-buffer-and-file :which-key "delete current buffer file")
	"u" '(:ignore t :which-key "undo")
	"u l" '(undo-tree-undo :which-key "undo (last)")
	"u r" '(undo-tree-redo :which-key "redo")
	"u v" '(undo-tree-visualize :which-key "view tree")
        "q" '(:ignore t :which-key "quit")
        "q e" '(save-buffers-kill-emacs :which-key "quit emacs")
        "q E" '(evil-quit-all-with-error-code :which-key "quit emacs without saving")
        "q q" '(save-buffers-kill-terminal :which-key "quit frame")
        "r" '(:ignore t :which-key "roam")
        "r d" '(org-roam-buffer-toggle-display :which-key "roam display")
        "r b" '(helm-bibtex :which-key "view bibliography")
        "r c" '(org-roam-capture :which-key "capture note")
        "r f" '(org-roam-find-file :which-key "find roam note")
        "r g" '(org-roam-graph :which-key "graph")
        "r i" '(org-roam-insert :which-key "insert note citation")
        "r l" '(org-ref-insert-link :which-key "insert link to reference")
        "r p" '(org-mark-ring-goto :which-key "previous note")
        "r r" '(org-roam :which-key "start roam")
        "r t" '(org-roam-tag-add :which-key "add tag")
        "r T" '(org-roam-tag-delete :which-key "delete tag")
        "r u" '(org-roam-update :which-key "update roam now")
        "r x" '(crux-delete-buffer-and-file :which-key "delete this note")
        "s" '(:ignore t :which-key "search")
        "s f" '(counsel-locate :which-key "file locate")
        "s i" '(counsel-imenu :which-key "imenu (find symbol)")
        "s r" '(counsel-mark-ring :which-key "mark ring")
        "s t" '(swiper-isearch-thing-at-point :which-key "thing at point")
        "w" '(:ignore t :which-key "window")
        "w +" '(evil-window-increase-height :which-key "increase height")
        "w -" '(evil-window-decrease-height :which-key "decrease height")
        "w >" '(evil-window-increase-width :which-key "increase width")
        "w <" '(evil-window-decrease-width :which-key "decrease width")
        "w =" '(balance-windows :which-key "balance windows")
        "w d" '(evil-window-delete :which-key "delete")
        "w h" '(evil-window-left :which-key "left")
        "w n" '(evil-window-down :which-key "down")
        "w e" '(evil-window-up :which-key "up")
        "w i" '(evil-window-right :which-key "right")
        "w n" '(evil-window-next :which-key "next")
        "w p" '(evil-window-mru :which-key "previous")
        "w s" '(evil-window-split :which-key "split above/below")
        "w v" '(evil-window-vsplit :which-key "split left/right")
        "w H" '(+evil/window-move-left :which-key "left")
        "w N" '(+evil/window-move-down :which-key "down")
        "w E" '(+evil/window-move-up :which-key "up")
        "w I" '(+evil/window-move-right :which-key "right")
        ))

;; Setup which-key -- shows a menu of which keybindings are available
(use-package which-key
  :init
  (which-key-mode)
  (setq which-key-sort-uppercase-first nil)
  ;; TODO get these keybindings working
  ;; :general
  ;; (:keymaps 'which-key-C-h-map
	    ;; "j" nil
	    ;; "k" nil
	    ;; "n" which-key-show-next-page-cycle
	    ;; "e" which-key-show-previous-page-cycle
	    ;; "l" which-key-undo-key
	    ;; "C-l" which-key-undo-key)
  :diminish
  :custom ;; must use :custom, not :config
  (which-key-allow-evil-operators t)
  (which-key-setup-side-window-bottom)
  (which-key-idle-delay 0.01)
  (which-key-idle-secondary-delay 0.01))

;; Setup hydra
(use-package hydra)

;; Setup crux
(use-package crux
  :after evil
  :demand t
  :general
  (:states 'normal
	   "go" 'crux-smart-open-line
	   "gO" 'crux-smart-open-line-above)
  :config
  (crux-reopen-as-root-mode t))

;; Setup undo-tree
(use-package undo-tree
  :demand
  :general
  (:keymaps undo-tree-visualizer-mode-map
	    "e" 'undo-tree-visualize-undo
	    "n" 'undo-tree-visualize-redo
	    "h" 'undo-tree-visualize-switch-branch-left
	    "i" 'undo-tree-visualize-switch-branch-right
	    "C-e" 'undo-tree-visualize-undo-to-x
	    "C-n" 'undo-tree-visualize-redo-to-x)
  :config
  (global-undo-tree-mode)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (setq undo-tree-auto-save-history t)
  )

;; =============================================================================
;; INTERFACE
;; =============================================================================
;; Setup counsel/ivy/swiper
(use-package counsel ;; includes ivy and swiper
  :diminish
  :after evil
  :general
  (:states 'normal
	   "?" 'swiper-isearch
	   "/" 'evil-avy-goto-char-2
	   ":" 'counsel-M-x)
  (:keymaps 'minibuffer-local-map
	    "C-r" 'counsel-minibuffer-history)
  :demand
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d) ")
  (setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)") ;; hide certain files; from doom emacs
  )

;; Setup ivy-rich
(use-package ivy-rich
    :diminish
    :demand
    :config
    (ivy-rich-mode 1)
    (setq ivy-rich-path-style 'abbrev))

;; Setup helpful -- better help menus
(use-package helpful
  :demand
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Setup doom-modeline from doom emacs
(use-package doom-modeline
  :ghook 'after-init-hook
  :init
  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-icon t)
  :config
  ;; Show column number in doom-modeline
  (column-number-mode)
  )

;; Setup all-the-icons
;; (Needed by doom-modeline)
(use-package all-the-icons
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-dired
    :ghook 'dired-mode-hook)

;; Setup doom-themes
(use-package doom-themes
    :demand
    :custom-face
    ;; change ugly org-level-1 etc. color choices
    (outline-1 ((t (:foreground "#fadb2f")))) ;; only bold level 1 face
    (outline-2 ((t (:foreground "#8ec07c"))))
    (outline-3 ((t (:foreground "#a2bbb1"))))
    (outline-4 ((t (:foreground "#8ec07c"))))
    (outline-5 ((t (:foreground "#a2bbb1"))))
    (outline-6 ((t (:foreground "#8ec07c"))))
    (outline-7 ((t (:foreground "#a2bbb1"))))
    (outline-8 ((t (:foreground "#8ec07c"))))
    :config
    (setq doom-themes-enable-bold t)
    (setq doom-themes-enable-italic t)
    (load-theme 'doom-gruvbox t)
    (doom-themes-visual-bell-config)
    (doom-themes-org-config))

;; Setup whitespace (to visualize trailing whitespace etc.)
(use-package whitespace
  :ensure f
  :demand
  :init
  (global-whitespace-mode)
  :config
  (setq whitespace-style '(face trailing tabs tab-mark)))

;; Setup rainbow-delimiters
(use-package rainbow-delimiters
    :ghook 'prog-mode-hook)

;; Setup evil-goggles (highlights evil motions)
(use-package evil-goggles
  :after evil
  :ghook 'evil-mode-hook
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

;; Setup hl-line (highlights the current line)
(use-package hl-line
  :ensure nil ;; already installed with emacs
  :demand
  :config
  (global-hl-line-mode 1))

;; Setup paren
(use-package paren
  :ensure nil ;; already installed
  :demand
  :config
  (show-paren-mode +1))

;; Setup saveplace (saves place in file)
(use-package saveplace
  :ensure nil
  :demand
  :init
  (save-place-mode t)
  (setq save-place-file "~/.emacs.d/.saveplace"))

;; Setup hl-todo
;; TODO this package causes a segfault for some reason
;;(use-package hl-todo
;;  :demand
;;  :config
;;  (global-hl-todo-mode 1)
;;  (setq hl-todo-keyword-faces
;;	'(("TODO"   . "#fb4932")
;;	  ("INPROGRESS"  . "#fe8019")
;;	  ("WAITING"  . "#fe8019")
;;	  ("SHOULD"  . "#fabd2f")
;;	  ("NOTE"  . "#b8bb26")
;;	  ("MAYBE"  . "#fabd2f")
;;	  ("DONE"  . "#a89984")
;;	  ("ABANDONED"  . "#a89984")
;;	  ("FIXME"  . "#fb4932")
;;	  ("XXX"  . "#fb4932")
;;	  ("DEBUG"  . "#fe8019")
;;	  ("GOTCHA" . "#fb4932")
;;	  ("STUB"   . "#fabd2f"))))

;; Setup shackle for buffer/window placement
(use-package shackle
  :demand
  :init
  (setq shackle-rules '((("^\\*\\(?:[Cc]ompil\\(?:ation\\|e-Log\\)\\|Messages\\)" "^\\*info\\*$" "\\`\\*magit-diff: .*?\\'" grep-mode "*ag search*" "*Flycheck errors*") :regexp t :align below :noselect t :size 0.3)
			("^\\*\\(?:Wo\\)?Man " :regexp t :align right :select t)
			("^\\*Calc" :regexp t :align below :select t :size 0.3)
			("^\\*lsp-help" :regexp t :select t :align bottom :size 0.2)
			(("^\\*Warnings" "^\\*Warnings" "^\\*CPU-Profiler-Report " "^\\*Memory-Profiler-Report " "^\\*Process List\\*" "*Error*") :regexp t :align below :noselect t :size 0.2)
			("^\\*\\(?:Proced\\|timer-list\\|Abbrevs\\|Output\\|Occur\\|unsent mail\\)\\*" :regexp t :ignore t)
			(("*shell*" "*eshell*") :popup t :select t)
			("^ \\*undo-tree\\*" :regexp t :other t :align right :select t :size 0.2)
			("^\\*\\([Hh]elp\\|Apropos\\)" :regexp t :align right :select t)
			))
  (setq shackle-default-rule '(:select t :same t)) ;; reuse current window for new buffers by default
  (setq shackle-default-size 0.4)
  :config
  (shackle-mode)
  )

;; Ligatures
(setq-default prettify-symbols-alist '(
                                       ("#+BEGIN_SRC" . "†")
                                       ("#+END_SRC" . "†")
                                       ("#+begin_src" . "†")
                                       ("#+end_src" . "†")
                                       ("lambda" . ?λ)
                                       ("\forall" . ?∀)
                                       ("\exists" . ?∃)
                                       ("infinity" . ?∞)
                                       ("therefore" . ?∴)
                                       ("because" . ?∵)
                                       ("&&" . ?∧)
                                       ("||" . ?∨)
                                       ("==" . ?≡)
                                       ("<=" . ?≤)
                                       (">=" . ?≥)
                                       ("<<" . ?≪)
                                       (">>" . ?≫)
                                       ("/=" . ?≠)
                                       ("!=" . ?≠)
                                       ("~>" . ?⇝)
                                       ("<~" . ?⇜)
                                       ("~~>" . ?⟿)
                                       ("<=<" . ?↢)
                                       (">=>" . ?↣)
                                       ("->" . ?→)
                                       ("-->" . ?⟶)
                                       ("<-" . ?←)
                                       ("<--" . ?⟵)
                                       ("<=>" . ?⇔)
                                       ("<==>" . ?⟺)
                                       ("=>" . ?⇒)
                                       ("==>" . ?⟹)
                                       ("<=" . ?⇐)
                                       ("<==" . ?⟸)
                                       (" *** " . (?  (Br . Bl) ?⁂ (Br . Bl) ? ))
                                       ))
(setq prettify-symbols-unprettify-at-point 'right-edge) ;; don't form ligatures under the cursor
(add-hook 'org-mode-hook 'prettify-symbols-mode)
(add-hook 'prog-mode-hook 'prettify-symbols-mode)

;; Setup dired
(use-package dired
  :ensure nil ;; already installed
  :ghook ('dired-mode-hook 'dired-hide-details-mode)
  :config
  (setq dired-dwim-target t)
  (setq find-file-visit-truename t)
  (setq dired-ls-F-marks-symlinks t)
  (setq dired-auto-revert-buffer t)
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)
  )

(use-package dired-x
  :after dired
  :ensure nil ;; already installed
  :ghook ('dired-mode-hook 'dired-omit-mode)
  :config
  (dired-omit-mode t)
  (setq dired-guess-shell-alist-user '(("\\.\\(?:pdf\\|djvu\\|eps\\)\\'" "evince")
                                       ("\\.\\(?:doc\\|docx\\|odt\\)\\'" "libreoffice")
                                       ("\\.\\(?:jpe?g\\|png\\|gif\\|xpm\\)\\'" "feh")
                                       ("\\.\\(?:xcf\\)\\'" "xdg-open")
                                       ("\\.csv\\'" "xdg-open")
                                       ("\\.tex\\'" "xdg-open")
                                       ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|rm\\|rmvb\\|ogv\\)\\(?:\\.part\\)?\\'" "xdg-open")
                                       ("\\.\\(?:mp3\\|flac\\)\\'" "xdg-open")
                                       ("\\.html?\\'" "xdg-open")
                                       ("\\.md\\'" "xdg-open")))
  (setq dired-omit-files "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)") ;; hide certain files
  )

;; =============================================================================
;; EVIL MODE
;; =============================================================================
;; Setup evil
(use-package evil
  :demand
  :general
  ;; Reimplementing some of the colemak evil rebindings from here https://github.com/wbolster/evil-colemak-basics
  ;; I do use the t-f-j rotation
  (:states '(motion normal visual)
	   "e" 'evil-previous-visual-line
	   "ge" 'evil-previous-visual-line
	   "E" 'evil-lookup
	   "f" 'evil-forward-word-end
	   "F" 'evil-forward-WORD-end
	   "gf" 'evil-backward-word-end
	   "gF" 'evil-backward-WORD-end
	   "gt" 'find-file-at-point
	   "gT" 'evil-find-file-at-point-with-line
	   "i" 'evil-forward-char
	   "gj" 'evil-backward-word-end
	   "gJ" 'evil-backward-WORD-end
	   "k" 'evil-search-next
	   "K" 'evil-search-previous
	   "gk" 'evil-next-match
	   "gK" 'evil-previous-match
	   "n" 'evil-next-visual-line
	   "gn" 'evil-next-visual-line
	   "gN" 'evil-next-visual-line
	   "zi" 'evil-scroll-column-right
	   "zI" 'evil-scroll-right)
  (:states '(normal visual)
	   "l" 'undo-tree-undo
	   "C-r" 'undo-tree-redo
	   "N" 'evil-join
	   "gN" 'evil-join-whitespace)
  (:states 'normal
	   "u" 'evil-insert
	   "U" 'evil-insert-line)
  (:states 'visual
	   "U" 'evil-insert)
  (:states '(motion operator)
	   "e" 'evil-previous-line
	   "n" 'evil-next-line)
  (:states '(visual operator)
	   "u" evil-inner-text-objects-map)
  (:states 'operator
	   "i" 'evil-forward-char)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (setq evil-want-fine-undo t)
  ;; Start certain modes in normal mode
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  ;; Start certain modes in emacs mode
  (add-to-list 'evil-emacs-state-modes 'custom-mode)
  (add-to-list 'evil-emacs-state-modes 'eshell-mode))

;; Setup evil-collection -- evil keybindings for many modes
(use-package evil-collection
    :after evil
    :demand
    :config
    (defun taylor-gl/hjkl-to-hnei (_mode mode-keymaps &rest _rest)
    (evil-collection-translate-key nil 'evil-motion-state-map
      ;; colemak hnei is qwerty hjkl
      "n" "j"
      "e" "k"
      "i" "l"
      ;; add back nei
      "j" "e"
      "k" "n"
      "l" "i"))
    (general-add-hook 'evil-collection-setup-hook #'taylor-gl/hjkl-to-hnei)
    (evil-collection-init))

;; Setup evil-snipe
(use-package evil-snipe
  :after evil
  :demand t
  :general
  (:states '(motion normal visual)
	  "j" 'evil-snipe-j
	  "J" 'evil-snipe-J
	  ;; "s" 'evil-snipe-s -- is set by evil-snipe-mode below
	  ;; "S" 'evil-snipe-S -- is set by evil-snipe-mode below
	  "t" 'evil-snipe-t
	  "T" 'evil-snipe-T
	   )
  :config
  (evil-snipe-mode t)
  ;; evil-snipe-def used because of https://github.com/hlissner/evil-snipe/issues/46
  (evil-snipe-def 1 inclusive "t" "T")
  (evil-snipe-def 1 exclusive "j" "J")
  ;; (evil-snipe-override-mode t)
  (setq evil-snipe-show-prompt nil)
  (setq evil-snipe-repeat-keys nil)
  )

;; Setup evil numbers (for increment/decrement at point)
(use-package evil-numbers
  :after evil
  :general
  (:keymaps evil-normal-state-map
         "g =" 'evil-numbers/inc-at-pt
         "g -" 'evil-numbers/dec-at-pt)
  )

;; Setup evil-surround
;; E.g. ys<textobject>) will surround with (parens).
;; Also, ds) will delete a pair of (parens).
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

;; Setup avy (for jumping)
(use-package avy
  :after evil
  :demand t
  :config
  ;; avy-keys colemak (used for characters which pop up when jumping)
  ;; These correspond to: a r s t d h n e i o '
  (avy-setup-default)
  (setq avy-keys '(97 114 115 116 100 104 110 101 105 111 39))
  (setq avy-background t)
  (setq avy-all-windows nil)
  ;; make shorter sequences for words closer to point
  (setq avy-orders-alist
        '((avy-goto-char . avy-order-closest)
          (avy-goto-word-0 . avy-order-closest)))
  )

;; =============================================================================
;; ORG
;; =============================================================================
;; Setup org
(defun taylor-gl/org-mode-setup ()
  (variable-pitch-mode 1)
  (auto-fill-mode 0))
(use-package org
  :hook (org-mode . taylor-gl/org-mode-setup)
  :mode ("\\.org\\'" . org-mode)
  :general
  (:keymaps 'org-read-date-minibuffer-local-map
         "C-h" (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-day 1)))
         "C-n" (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-week 1)))
         "C-e" (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-week 1)))
         "C-i" (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-day 1)))
         "C-S-h" (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-month 1)))
         "C-S-n" (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-year 1)))
         "C-S-e" (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-year 1)))
         "C-S-i" (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-month 1)))
         )
  (:keymaps 'org-mode-map
	    "RET" '+org/dwim-at-point
	    "<return>" '+org/dwim-at-point
	    "M-h" 'org-metaleft
	    "M-n" 'org-metadown
	    "M-e" 'org-metaup
	    "M-i" 'org-metaright
	    "M-H" 'org-shiftmetaleft
	    "M-N" 'org-shiftmetadown
	    "M-E" 'org-shiftmetaup
	    "M-I" 'org-shiftmetaright
	    "M-f" 'org-forward-sentence
	    "C-H" 'org-shiftcontrolleft
	    "C-N" 'org-shiftcontroldown
	    "C-E" 'org-shiftcontrolup
	    "C-E" 'org-shiftcontrolright
	    ;; TODO put these in 'normal and 'visual mode maps
	    ;; "g h" 'org-up-element
	    ;; "g n" 'org-forward-element
	    ;; "g e" 'org-backward-element
	    ;; "g i" 'org-down-element
	    )
  :config
  (setq org-ellipsis " ▼"
        org-directory "~/Dropbox/emacs/"
        org-agenda-files '("~/Dropbox/emacs/todo.org" "~/Dropbox/emacs/reference.org")
        org-modules '(ol-bibtex)
        org-link-shell-confirm-function nil ;; don't annoy me by asking for confirmation
        ;; don't show DONE items in agenda
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-latex-packages-alist '(("" "clrscode3e" t)
                                   ("" "mathtools" t)
                                   ("" "amssymb" t))
        org-hide-emphasis-markers t
	org-startup-indented t
        org-file-apps '((auto-mode . emacs)
                        (directory . emacs)
                        ("\\.mm\\'" . default)
                        ("\\.x?html?\\'" . default)
                        ("\\.pdf\\'" . "evince \"%s\"")
                        ("\\.djvu\\'" . "evince \"%s\"")
                        ("\\.epub\\'" . "ebook-viewer \"%s\"")
                        )
        org-log-into-drawer t ;; log into LOGBOOK drawer
	org-M-RET-may-split-line nil
        org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "SHOULD(s)" "MAYBE(m)" "NOTE(n)" "WAITING(w)" "NPC(p)" "MET(P)" "|" "DONE(d)" "ABANDONED(a)" ))
        org-todo-keyword-faces '(
                                 ("TODO" :foreground "#fb4932" :weight bold :underline f)
                                 ("INPROGRESS" :foreground "#fe8019" :weight bold :underline f)
                                 ("WAITING" :foreground "#fe8019" :weight bold :underline f)
                                 ("SHOULD" :foreground "#fabd2f" :weight bold :underline f)
                                 ("NOTE" :foreground "#b8bb26" :weight bold :underline f)
                                 ("MAYBE" :foreground "#fabd2f" :weight bold :underline f)
                                 ("DONE" :foreground "#a89984" :weight bold :underline f)
                                 ("ABANDONED" :foreground "#928374" :weight bold :underline f)
                                 )
        calendar-holidays '((holiday-fixed 1 1 "New Year's Day")
                            (holiday-float 2 1 3 "Family Day")
                            (holiday-fixed 2 14 "Valentine's Day")
                            (holiday-fixed 3 17 "St. Patrick's Day")
                            (holiday-fixed 4 1 "April Fools' Day")
                            (holiday-easter-etc -2 "Good Friday")
                            (holiday-easter-etc 0 "Easter")
                            (holiday-easter-etc 1 "Easter Monday")
                            (holiday-float 5 0 2 "Mother's Day")
                            (holiday-float 5 1 -2 "Victoria Day")
                            (holiday-float 6 0 3 "Father's Day")
                            (holiday-fixed 7 1 "Canada Day")
                            (holiday-float 8 1 1 "Civic Holiday")
                            (holiday-float 9 1 1 "Labour Day")
                            (holiday-float 10 1 2 "Thanksgiving")
                            (holiday-fixed 10 31 "Halloween")
                            (holiday-fixed 11 11 "Remembrance Day")
                            (holiday-fixed 12 24 "Christmas Eve")
                            (holiday-fixed 12 25 "Christmas")
                            (holiday-fixed 12 26 "Boxing Day")
                            (solar-equinoxes-solstices)
                            (holiday-sexp calendar-daylight-savings-starts
                                          (format "Daylight Saving Time Begins %s"
                                                  (solar-time-string
                                                   (/ calendar-daylight-savings-starts-time
                                                      (float 60))
                                                   calendar-standard-time-zone-name)))
                            (holiday-sexp calendar-daylight-savings-ends
                                          (format "Daylight Saving Time Ends %s"
                                                  (solar-time-string
                                                   (/ calendar-daylight-savings-ends-time
                                                      (float 60))
                                                   calendar-daylight-time-zone-name))))))

(use-package org-bullets
  :after org
  :ghook 'org-mode-hook
  :custom
  (org-bullets-bullet-list '("◇" "◆" "◉" "●" "○" "●" "○" "●" "○" "●" "○" "●")))

(use-package evil-org
  :after evil
  :ghook 'org-mode-hook
  :general
  (:states '(visual operator)
	   :keymap 'evil-inner-text-objects-map
	   :prefix "u"
	   "e" 'evil-org-inner-object
	   "E" 'evil-org-inner-element
	   "r" 'evil-org-inner-greater-element
	   "R" 'evil-org-inner-subtree)
  (:states '(visual operator)
	   :keymap 'evil-inner-text-objects-map
	   :prefix "a"
	   "e" 'evil-org-an-object
	   "E" 'evil-org-an-element
	   "r" 'evil-org-a-greater-element
	   "R" 'evil-org-a-subtree)
  :init
  (setq evil-org-retain-visual-state-on-shift t)
  (setq evil-org-special-o/O '(table-row))
  (setq evil-org-use-additional-insert t)
  :config
  (evil-org-set-key-theme '(navigation insert additional calendar))
  (setq evil-org-movement-bindings
	'((up . "e") (down . "n")
	  (left . "h") (right . "i")))
    )

;; TODO Failed to install evil-org-agenda: Package "evil-org-agenda-" is unavailable
;; (use-package evil-org-agenda
  ;; :ghook 'org-agenda-mode-hook
  ;; :config
  ;; (evil-org-agenda-set-keys)
  ;; (evil-define-key* 'motion evil-org-agenda-mode-map
    ;; "SPC" nil))

(with-eval-after-load 'org-faces
  (dolist (face '((org-level-1)
                  (org-level-2)
                  (org-level-3)
                  (org-level-4)
                  (org-level-5)
                  (org-level-6)
                  (org-level-7)
                  (org-level-8)))
    (set-face-attribute (car face) nil :font "Noto Sans" :weight 'regular :height 1.1))
  ;; making certain things fixed-pitch
  (require 'org-indent)
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit '(shadow fixed-pitch)))

;; Setup org-roam for zettelkasten
(use-package org-roam
  :after org
  :ghook 'after-init-hook
  :custom
  (org-roam-directory "~/Dropbox/emacs/roam"))
;; org-ref and helm-bibtex for use with org-roam
(use-package org-ref
  :config
  (setq reftex-default-bibliography '("~/Dropbox/emacs/roam/bibliography/references.bib"))
  (setq org-ref-bibliography-notes "~/Dropbox/emacs/roam/bibliography/notes.org"
        org-ref-default-bibliography '("~/Dropbox/emacs/roam/bibliography/references.bib")
        org-ref-pdf-directory "~/Dropbox/emacs/roam/bibliography/bibtex-pdfs/")
  (setq bibtex-completion-pdf-open-function 'org-open-file))
(use-package helm-bibtex
  :config
  (setq bibtex-completion-bibliography
        '("~/Dropbox/emacs/roam/bibliography/references.bib"))
  (setq bibtex-completion-library-path '("~/Dropbox/emacs/roam/bibliography/bibtex-pdfs/"))
  (setq bibtex-completion-pdf-open-function
        (lambda (fpath)
          (call-process "evince" nil 0 nil fpath))))


;; =============================================================================
;; CODE
;; =============================================================================
;; various coding-related modes
(defconst code-mode-hooks
  '(prog-mode-hook python-mode-hook elisp-mode-hook emacs-lisp-mode-hook)
  )

;; Setup company-mode (autocompletion; integrates with lsp-mode)
(use-package company
  :demand
  :custom
  (comany-begin-commands '(self-insert-command))
  (company-idle-delay 0.0) ;; some people use 0.1 as "instant", but that is visibly non-instant
  (company-minimum-prefix-length 1)
  (company-require-match 'never)
  (company-tooltip-align-annotations t)
  (global-company-mode t))

;; Setup company-posframe (helps company look good even when in a buffer with variable pitch fonts e.g. org)
(use-package company-posframe
  :ghook 'company-mode-hook
  :config
  (company-posframe-mode 1))

;; Setup flycheck (linting)
(use-package flycheck
  :demand
  :ghook (code-mode-hooks 'flycheck-mode)
  :init
  (flycheck-mode)
  :config
  (setq flycheck-idle-change-delay 0.05)
  )

;; Setup flycheck-pos-tip for flycheck info on hover
(use-package flycheck-pos-tip
  :after flycheck
  :ghook 'flycheck-mode-hook
  :config
  (flycheck-pos-tip-mode))

;; Setup LSP-server
(defconst lsp-mode-hooks
  '(python-mode-hook))
(use-package lsp-mode
  :after company
  :demand
  :ghook (lsp-mode-hooks 'lsp)
  ('lsp-mode-hook 'lsp-enable-which-key-integration)
  ;; :general
  ;; (:keymap 'lsp-mode-map
	   ;; :states '(normal visual emacs)
	   ;; :prefix "SPC"
	   ;; :global-prefix "C-SPC"
	   ;; TODO bind this under localleader
	   ;; "l" '(:ignore t :which-key "lsp")
	   ;; "l" lsp-command-map)
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-keymap-prefix "C-c l") ;; having this set creates which-key integration
  (setq lsp-enable-folding nil)
  (setq lsp-enable-on-type-formatting nil)
  ;; (require 'dash-functional)
  :custom
  (lsp-prefer-flymake nil)
  (lsp-semantic-tokens-enable t)
  )

;; Setup lsp-ui
(use-package lsp-ui
  :after lsp-mode
  :ghook 'lsp-mode-hook
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-diagnostic-max-lines 3)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-enable t)
  (lsp-ui-flycheck-enable t)
  )

;; Setup lsp-ivy
(use-package lsp-ivy
  :after lsp
  :commands lsp-ivy-workspace-symbol)


;; Setup python
(use-package lsp-pyright
  :demand
  :ghook ('python-mode-hook 'lsp))

;; =============================================================================
;; MISC.
;; =============================================================================
;; Setup YASnippet
(use-package yasnippet
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets
  :after yasnippet)

;; Setup magit
(use-package magit)
(use-package evil-magit
  :ensure f
  :after magit)

;; =============================================================================
;; CUSTOM FUNCTIONS (from doom emacs if they start with +)
;; =============================================================================
(defun +org--toggle-inline-images-in-subtree (&optional beg end refresh)
  "Refresh inline image previews in the current heading/tree."
  (let ((beg (or beg
		 (if (org-before-first-heading-p)
		     (line-beginning-position)
		   (save-excursion (org-back-to-heading) (point)))))
	(end (or end
		 (if (org-before-first-heading-p)
		     (line-end-position)
		   (save-excursion (org-end-of-subtree) (point)))))
	(overlays (cl-remove-if-not (lambda (ov) (overlay-get ov 'org-image-overlay))
				    (ignore-errors (overlays-in beg end)))))
    (dolist (ov overlays nil)
      (delete-overlay ov)
      (setq org-inline-image-overlays (delete ov org-inline-image-overlays)))
    (when (or refresh (not overlays))
      (org-display-inline-images t t beg end)
      t)))

(defun +org--insert-item (direction)
  (let ((context (org-element-lineage
		  (org-element-context)
		  '(table table-row headline inlinetask item plain-list)
		  t)))
    (pcase (org-element-type context)
      ;; Add a new list item (carrying over checkboxes if necessary)
      ((or `item `plain-list)
       ;; Position determines where org-insert-todo-heading and org-insert-item
       ;; insert the new list item.
       (if (eq direction 'above)
	   (org-beginning-of-item)
	 (org-end-of-item)
	 (backward-char))
       (org-insert-item (org-element-property :checkbox context))
       ;; Handle edge case where current item is empty and bottom of list is
       ;; flush against a new heading.
       (when (and (eq direction 'below)
		  (eq (org-element-property :contents-begin context)
		      (org-element-property :contents-end context)))
	 (org-end-of-item)
	 (org-end-of-line)))

      ;; Add a new table row
      ((or `table `table-row)
       (pcase direction
	 ('below (save-excursion (org-table-insert-row t))
		 (org-table-next-row))
	 ('above (save-excursion (org-shiftmetadown))
		 (+org/table-previous-row))))

      ;; Otherwise, add a new heading, carrying over any todo state, if
      ;; necessary.
      (_
       (let ((level (or (org-current-level) 1)))
	 ;; I intentionally avoid `org-insert-heading' and the like because they
	 ;; impose unpredictable whitespace rules depending on the cursor
	 ;; position. It's simpler to express this command's responsibility at a
	 ;; lower level than work around all the quirks in org's API.
	 (pcase direction
	   (`below
	    (let (org-insert-heading-respect-content)
	      (goto-char (line-end-position))
	      (org-end-of-subtree)
	      (insert "\n" (make-string level ?*) " ")))
	   (`above
	    (org-back-to-heading)
	    (insert (make-string level ?*) " ")
	    (save-excursion (insert "\n"))))
	 (when-let* ((todo-keyword (org-element-property :todo-keyword context))
		     (todo-type    (org-element-property :todo-type context)))
	   (org-todo
	    (cond ((eq todo-type 'done)
		   ;; Doesn't make sense to create more "DONE" headings
		   (car (+org-get-todo-keywords-for todo-keyword)))
                  (todo-keyword)
                  ('todo)))))))

    (when (org-invisible-p)
      (org-show-hidden-entry))
    (when (and (bound-and-true-p evil-local-mode)
               (not (evil-emacs-state-p)))
      (evil-insert 1))))

(defun +org--get-property (name &optional bound)
  (save-excursion
    (let ((re (format "^#\\+%s:[ \t]*\\([^\n]+\\)" (upcase name))))
      (goto-char (point-min))
      (when (re-search-forward re bound t)
        (buffer-substring-no-properties (match-beginning 1) (match-end 1))))))

(defun +org-get-global-property (name &optional file bound)
  "Get a document property named NAME (string) from an org FILE (defaults to
current file). Only scans first 2048 bytes of the document."
  (unless bound
    (setq bound 256))
  (if file
      (with-temp-buffer
        (insert-file-contents-literally file nil 0 bound)
        (+org--get-property name))
    (+org--get-property name bound)))

(defun +org-get-todo-keywords-for (&optional keyword)
  "Returns the list of todo keywords that KEYWORD belongs to."
  (when keyword
    (cl-loop for (type . keyword-spec)
             in (cl-remove-if-not #'listp org-todo-keywords)
             for keywords =
             (mapcar (lambda (x) (if (string-match "^\\([^(]+\\)(" x)
                                     (match-string 1 x)
                                   x))
                     keyword-spec)
             if (eq type 'sequence)
             if (member keyword keywords)
             return keywords)))

(defun +org/dwim-at-point (&optional arg)
  "Do-what-I-mean at point.
If on a:
- checkbox list item or todo heading: toggle it.
- clock: update its time.
- headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
  subtree; update statistics cookies/checkboxes and ToCs.
- footnote reference: jump to the footnote's definition
- footnote definition: jump to the first reference of this footnote
- table-row or a TBLFM: recalculate the table's formulas
- table-cell: clear it and go into insert mode. If this is a formula cell,
  recaluclate it instead.
- babel-call: execute the source block
- statistics-cookie: update it.
- latex fragment: toggle it.
- link: follow it
- otherwise, refresh all inline images in current tree."
  (interactive "P")
  (let* ((context (org-element-context))
	 (type (org-element-type context)))
    ;; skip over unimportant contexts
    (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
      (setq context (org-element-property :parent context)
	    type (org-element-type context)))
    (pcase type
      (`headline
       (cond ((memq (bound-and-true-p org-goto-map)
		    (current-active-maps))
	      (org-goto-ret))
	     ((and (fboundp 'toc-org-insert-toc)
		   (member "TOC" (org-get-tags)))
	      (toc-org-insert-toc)
	      (message "Updating table of contents"))
	     ((string= "ARCHIVE" (car-safe (org-get-tags)))
	      (org-force-cycle-archived))
	     ((or (org-element-property :todo-type context)
		  (org-element-property :scheduled context))
	      (org-todo
	       (if (eq (org-element-property :todo-type context) 'done)
		   (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
		       'todo)
		 'done))))
       ;; Update any metadata or inline previews in this subtree
       (org-update-checkbox-count)
       (org-update-parent-todo-statistics)
       (when (and (fboundp 'toc-org-insert-toc)
		  (member "TOC" (org-get-tags)))
	 (toc-org-insert-toc)
	 (message "Updating table of contents"))
       (let* ((beg (if (org-before-first-heading-p)
		       (line-beginning-position)
		     (save-excursion (org-back-to-heading) (point))))
	      (end (if (org-before-first-heading-p)
		       (line-end-position)
		     (save-excursion (org-end-of-subtree) (point))))
	      (overlays (ignore-errors (overlays-in beg end)))
	      (latex-overlays
	       (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
			   overlays))
	      (image-overlays
	       (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
			   overlays)))
	 (+org--toggle-inline-images-in-subtree beg end)
	 (if (or image-overlays latex-overlays)
	     (org-clear-latex-preview beg end)
	   (org--latex-preview-region beg end))))

      (`clock (org-clock-update-time-maybe))

      (`footnote-reference
       (org-footnote-goto-definition (org-element-property :label context)))

      (`footnote-definition
       (org-footnote-goto-previous-reference (org-element-property :label context)))

      ((or `planning `timestamp)
       (org-follow-timestamp-link))

      ((or `table `table-row)
       (if (org-at-TBLFM-p)
	   (org-table-calc-current-TBLFM)
	 (ignore-errors
	   (save-excursion
	     (goto-char (org-element-property :contents-begin context))
	     (org-call-with-arg 'org-table-recalculate (or arg t))))))

      (`table-cell
       (org-table-blank-field)
       (org-table-recalculate arg)
       (when (and (string-empty-p (string-trim (org-table-get-field)))
		  (bound-and-true-p evil-local-mode))
	 (evil-change-state 'insert)))

      (`babel-call
       (org-babel-lob-execute-maybe))

      (`statistics-cookie
       (save-excursion (org-update-statistics-cookies arg)))

      ((or `src-block `inline-src-block)
       (org-babel-execute-src-block arg))

      ((or `latex-fragment `latex-environment)
       (org-latex-preview arg))

      (`link
       (let* ((lineage (org-element-lineage context '(link) t))
	      (path (org-element-property :path lineage)))
	 (if (or (equal (org-element-property :type lineage) "img")
		 (and path (image-type-from-file-name path)))
	     (+org--toggle-inline-images-in-subtree
	      (org-element-property :begin lineage)
	      (org-element-property :end lineage))
	   (org-open-at-point arg))))

      ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
       (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
	 (org-toggle-checkbox (if (equal match "[ ]") '(16)))))

      (_
       (if (or (org-in-regexp org-ts-regexp-both nil t)
	       (org-in-regexp org-tsr-regexp-both nil  t)
	       (org-in-regexp org-link-any-re nil t))
	   (call-interactively #'org-open-at-point)
	 (+org--toggle-inline-images-in-subtree
	  (org-element-property :begin context)
	  (org-element-property :end context)))))))

;; =============================================================================
;; CUSTOM (don't edit by hand)
;; =============================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-org-agenda yasnippet-snippets which-key use-package smex rainbow-delimiters org-roam org-ref org-plus-contrib org-bullets magit ivy-rich helpful general evil-org evil-numbers evil-collection evil-colemak-basics doom-themes doom-modeline crux counsel avy all-the-icons-dired))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed))))
 '(outline-1 ((t (:foreground "#fadb2f"))))
 '(outline-2 ((t (:foreground "#8ec07c"))))
 '(outline-3 ((t (:foreground "#a2bbb1"))))
 '(outline-4 ((t (:foreground "#8ec07c"))))
 '(outline-5 ((t (:foreground "#a2bbb1"))))
 '(outline-6 ((t (:foreground "#8ec07c"))))
 '(outline-7 ((t (:foreground "#a2bbb1"))))
 '(outline-8 ((t (:foreground "#8ec07c")))))
