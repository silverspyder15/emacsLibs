;;; ~/emacs/lisp/misc-config.el

;; Re-enable various useful commands that are disabled by default
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Make text-mode the default major mode
(setq default-major-mode 'text-mode)

;; I want to be able to see the mark region and type over the selection
(transient-mark-mode t)
(delete-selection-mode t)

;; Show matching parens
(show-paren-mode t)

;; Set up ibuffer
;;(autoload 'ibuffer "ibuffer" "List buffers." t)


;;(setq ibuffer-formats '((mark modified read-only " " (name 40 40) " " (size 6 -1 :right) " " (mode 16 16 :center) " " (process 8 -1) " " filename)
;			(mark " " (name 16 -1) " " filename))
;      ibuffer-saved-filter-groups '(("default";
;				     ("c" (mode . c-mode))
;				     ("c++" (mode . c++-mode))
;				     ("python" (mode . python-mode))
;				     ("haskell" (mode . haskell-mode))
;				     ("emacs" (or (name . "^\\*scratch\\*$") (name . "^\\*Messages\\*$"))))
;				     ("dired" (mode . dired-mode)))
;      ibuffer-elide-long-columns t
;      ibuffer-eliding-string "&")

;(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-switch-to-saved-filter-groups "default")))

;; Set up iswitchb
;;(iswitchb-mode 1)
;;(setq iswitchb-default-method 'maybe-frame)

;; Setup ido mode
(ido-mode 1)

;; Set up tramp
(setq tramp-default-method "ssh")

;; Set up pastie
(autoload 'pastie-region "pastie" "Post the current region as a new paste at pastie.org. Copies the URL into the kill ring." t)

;; Other miscellaneous stuff
(setq inhibit-splash-screen t
      ring-bell-function 'ignore
      line-number-mode t
      column-number-mode t
      scroll-preserve-screen-position t
      scroll-step 1
      make-backup-files nil
      next-line-add-newlines nil
      find-file-use-truenames nil
      find-file-compare-truenames t
      minibuffer-confirm-incomplete t
      win32-alt-is-meta nil)

;;to copy and paste into the system clipboard using emacs key bindings

(setq x-select-enable-clipboard t)

(defadvice kill-new (before kill-new-push-xselection-on-kill-ring activate)
  "Before putting new kill onto the kill-ring, add the clipboard/external selection to the kill ring"
  (let ((have-paste (and interprogram-paste-function
                         (funcall interprogram-paste-function))))
    (when have-paste (push have-paste kill-ring))))

;;enable desktop-save

;;(desktop-save-mode 1)

;;;;;;;;; Custom grep ;;;;;;;;;;;
;; I want my grep command to be recursive and case in-sensitive.
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(grep-command "grep -nH -i -r "))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Changing major modes of files
;; that dont end with the proper suffix
;; i.e. abc.py.in
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; if first line of file a certain text, change the major mode.
;; Ref: http://ergoemacs.org/emacs/emacs_auto-activate_a_major-mode.html

;; Python major mode.
(add-to-list 'magic-mode-alist '("#! @PYTHON@" . python-mode) )
(add-to-list 'magic-mode-alist '("#! /usr/bin/python" . python-mode) )

;;Perl major mode.
(add-to-list 'magic-mode-alist '("#! /usr/bin/perl -w" . perl-mode) )

;;;;;;;;;; Magit configuration ;;;;;;;;;;;
(require 'magit)
(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
	       "~/emacs/site-lisp/magit/Documentation/"))

;;;;;;;;; Origami ;;;;;;;;;;
;; Currently this is disabled. Use <F5> instead to fold at various cursur levels.
;; Defined in screen-config.el (Code folding)
(require 'origami)
;;(add-hook 'after-init-hook #'global-flycheck-mode)


;;;;;;; Cscope config ;;;;;;;;
(require 'xcscope)
(require 'xpycscope)
(setq cscope-do-not-update-database t)

;; Set cscope initial directory
(setq cscope-set-initial-directory "/home/nilesh/workspaces")
(provide 'cscope-config)

;;;;;;; Dired ;;;;;;;;;;
(autoload 'dired-async-mode "dired-async.el" nil t)
(dired-async-mode 1)


;;;;;;; Add a column marker line ;;;;;;;;;;;
(require 'column-marker)
(add-hook 'c-mode-hook (lambda () (interactive) (column-marker-1 80)))


;;;;;;;;;;;;;;; Flycheck mode ;;;;;;;;;;;;;;;;;
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'c-mode-hook
          (lambda () (setq flycheck-gcc-include-path
                           (list
                                 (expand-file-name "~/workspaces/VCA/ovs/")
                                 (expand-file-name "~/workspaces/VCA/ovs/lib/")
                                 (expand-file-name "~/workspaces/VCA/ovs/include/")
                                 (expand-file-name "~/workspaces/VCA/ovs/include/windows/")
                                 (expand-file-name "~/workspaces/VCA/")
                                 (expand-file-name "~/workspaces/VCA/vrs/lib/libvrs-vswitchd/")
                                 (expand-file-name "~/workspaces/VCA/ovs/datapath/linux/compat/include/")
                                 "/usr/include/"
                                 ))))

;; Set default error display level to warning.
(add-hook 'c-mode-hook
           (lambda () (setq flycheck-error-list-minimum-level 'warning)))

;; (add-hook 'c-mode-hook
;; 	  (lambda () (setq flycheck-clang-args . ("-isystem/home/nilesh/workspaces/VCA/ovs/lib/")))))


;; (with-eval-after-load 'flycheck
;;   (setq-default flycheck-disabled-checkers (list (expand-file-name ("~/workspaces/VCA/ovs/lib/")))))



;;;;;;;;;; Show trailing whitespace ;;;;;;;;;;;
(setq-default show-trailing-whitespace t)

(require 'protobuf-mode)

;;;;;;;; Autocomplete ;;;;;;;;;;;;;;;
;; Enable autocomplete at startup
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)  ;load and activate packages, including auto-complete
(ac-config-default)
(global-auto-complete-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Map alt key to meta
(setq x-alt-keysm 'meta)


;;; end ~/emacs/lisp/misc-config.el
