(require 'cl)
(add-to-list 'exec-path "C:/Users/Srikar/AppData/Local/GitHub/PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c/bin")
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
	       '("marmalade" . "http://marmalade-repo.org/packages/") t)
  (add-to-list 'package-archives
	       '("melpa" . "http://stable.melpa.org/packages/") t))

(defvar prelude-packages
  '(haskell-mode)
  "A list of packages to ensure are installed at launch.")

(defun prelude-packages-installed-p ()
  (loop for p in prelude-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(defun install-if-missing (pkgs)
  (when pkgs
    (unless (package-installed-p (car pkgs) nil)
      (package-install (car pkgs)))
    (install-if-missing (cdr pkgs))))

(unless package-archive-contents
   (package-refresh-contents))

(install-if-missing
 '(ace-jump-mode async auto-complete auto-complete-pcmp auto-package-update
		 ac-math autopair avy calfw calfw-gcal color-theme cyberpunk-theme dash
   elscreen elscreen-separate-buffer-list exec-path-from-shell faceup py-autopep8 ein
   flyspell-lazy hc-zenburn-theme helm helm-idris helm-j-cheatsheet elpy flycheck
   highlight j-mode log4e org-ac org-beautify-theme org-gcal magit better-defaults
   paredit prop-menu popup racket-mode s sml-mode sml-modeline yaxception))

(global-linum-mode t)

(defvar pythonPackages
  '(better-defaults
    ein
    elpy
    flycheck
    py-autopep8))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      pythonPackages)

(elpy-enable)
;;(elpy-use-ipython) Use (elpy-use-cpython) or (elpy-interactive-python-command)
;;http://elpy.readthedocs.org/en/latest/ide.html?highlight=ipython#option-elpy-interactive-python-command

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(require 'helm)
(require 'helm-config)
(require 'midnight)
(require 'savehist)
(savehist-mode t)

(global-set-key (kbd "C-x g") 'magit-status)

(helm-mode 1)
(setq racket-racket-program "C:/Program Files/Racket/Racket.exe")
(setq racket-raco-program "C:/Program Files/Racket/raco.exe")
(add-hook 'racket-mode-hook (lambda () (define-key racket-mode-map (kbd "C-c r") 'racket-run)))
(setq tab-always-indent 'complete)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)



;; Haskell
(defun my-haskell-hook ()
  (progn
    (interactive-haskell-mode)
    (haskell-doc-mode)
    (haskell-indentation-mode)
    (defun haskell-session-new-assume-from-cabal ()
      (let ((name (haskell-session-default-name)))
        (unless (haskell-session-lookup name)
          (haskell-session-make name))))

    (defun haskell-utils-read-directory-name (prompt default)
      (let ((filename (file-truename default)))
        (concat (replace-regexp-in-string "/$" "" filename) "/")))

    (defun haskell-session-target (s)
      (let* ((maybe-target (haskell-session-get s 'target))
             (target (if maybe-target maybe-target (haskell-session-set-target s ""))))
        (if (not (string= target "")) target nil)))))

(add-hook 'haskell-mode-hook 'my-haskell-hook)

(show-paren-mode 1)
(setq show-paren-delay 0)

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(global-set-key (kbd "{") 'paredit-open-curly)
(add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)
(add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)
(add-hook 'emacs-lisp-mode-hook                    #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook   #'enable-paredit-mode)
(add-hook 'ielm-mode-hook                          #'enable-paredit-mode) ;; inferior-emacs-lisp-mode
(add-hook 'lisp-mode-hook                          #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook              #'enable-paredit-mode)
(add-hook 'scheme-mode-hook                        #'enable-paredit-mode)
(add-hook 'racket-mode-hook                        #'enable-paredit-mode)
(add-hook 'racket-repl-mode-hook                   #'enable-paredit-mode)
(setq tab-always-indent 'complete)

;;This is for changing the font size
(set-face-attribute 'default nil :height 120)

;;(setq window-themes-list '(wheatgrass badwolf monokai zenburn manoj-dark cyberpunk tango-dark deeper-blue wombat))
(setq window-themes-list '(badwolf zerodark monokai))

(if window-system
  (load-theme (nth (cl-random (length window-themes-list)) window-themes-list))
  (load-theme 'wombat t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("416202b5e2a3a9f8ac13ef30059bfcf2885e66e055ce38dc73f5ce7f191d7253" "5b340b4eb24c3c006972f3bc3aee26b7068f89ba9580d9a4211c1db5d0a70ea2" "0c49a9e22e333f260126e4a48539a7ad6e8209ddda13c0310c8811094295b3a3" "001d6425a6e5180a5e966d5be64b983e82dbf3fd92592f3637baa47ee59ba59e" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
