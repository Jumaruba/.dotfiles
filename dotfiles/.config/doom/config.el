;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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

(setq doom-font (font-spec :family "psudoFont Liga Mono" :size 12 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "psudoFont Liga Mono" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

;; ================= MY CHANGES =================
;; Tree with clicks
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

;; Nice UI for errors
(after! flycheck
  (require 'flycheck-posframe)
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(setq lsp-enable-snippet nil)

;; `+lookup/references' (find references) was slow: Doom routes xref through
;; `consult-xref', whose minibuffer UI auto-previews EVERY candidate as you move
;; -- each step opens and re-renders the target file (font-lock, line numbers,
;; indent-guides, vc-gutter, posframe). Across many references that render churn
;; is the cost. Bypass consult for xref results and use the built-in *xref*
;; buffer instead: the whole list renders once, you browse it with n/p (RET or
;; click to visit), and only the reference you pick is opened. No per-candidate
;; preview. (Leaves `xref-show-definitions-function' on Doom's default, so
;; jumping to an ambiguous definition still uses the quick consult picker.)
(after! xref
  (setq xref-show-xrefs-function #'xref--show-xref-buffer))

;; macOS: by default Emacs grabs BOTH Option keys as Meta, so Option-based
;; characters on non-US layouts (e.g. { } [ ]) never get inserted -- the
;; keypress is consumed as a Meta command. (Concretely: `{' lives on Option+a
;; key whose base char is `(', so as Meta it fires `M-(' = `insert-parentheses',
;; which is why typing `{' produced a stray `(' instead.)
;;
;; This layout puts those chars on the LEFT Option, so free the LEFT Option to
;; compose characters natively and move Meta to the RIGHT Option, keeping a Meta
;; key for Emacs commands. (Swap the two if your layout uses the right Option.)
(when (eq system-type 'darwin)
  (setq ns-option-modifier 'none          ; left Option -> compose { } [ ] etc.
        ns-right-option-modifier 'meta))  ; right Option -> Emacs Meta

;; FONTS ========================================
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Faces-for-Font-Lock.html
(set-face-attribute 'font-lock-comment-face nil :foreground "#5B6268" :slant 'italic)
(set-face-attribute 'font-lock-function-call-face nil :foreground "#D758FD" :slant 'italic)
(set-face-attribute 'font-lock-variable-name-face nil :foreground "#FFAD65" :slant 'italic)
(set-face-attribute 'font-lock-function-name-face nil :foreground "#46AEFF")
(set-face-attribute 'font-lock-string-face nil :foreground "#99FD51" )

; TREEMACS
(setq treemacs-width 60)

(use-package! xclip
  :config
  (xclip-mode 1))

(use-package! protobuf-mode
  :mode "\\.proto\\'")

;; Launch the coursier-installed Metals THROUGH `mise exec`.
;;
;; Why the wrapper: this Emacs is started from the macOS dock/Spotlight, so it
;; never sources ~/.zshrc and never runs `mise activate`. Without mise it has a
;; bare PATH and no JAVA_HOME, so Metals would run under /usr/bin/java
;; (OpenJDK 24) instead of the project's mise-managed Temurin 21. That JDK
;; mismatch destabilises the presentation compiler and triggers repeated
;; re-indexing -> "Find references" crawls.
;;
;; `mise exec` resolves the project's tools (java=temurin-21, scala=2.13.18) from
;; the workspace root that lsp-mode launches the server in, and exports the right
;; JAVA_HOME before handing off to the coursier metals launcher. Absolute paths
;; are required: GUI Emacs's PATH contains neither /opt/homebrew/bin nor the
;; coursier bin dir.
;;
;; Install with:  cs install metals   (and `mise use -g java@temurin-21`)
(after! lsp-metals
  (setq lsp-metals-server-command "/opt/homebrew/bin/mise"
        lsp-metals-server-args
        (list "exec" "--"
              (expand-file-name "~/Library/Application Support/Coursier/bin/metals"))))


(after! markdown-mode
  (set-formatter! 'prettier
    '("prettier" "--parser" "markdown")
    :modes '(markdown-mode gfm-mode)))
