;;; ~/emacs/lisp/ekeys.el

;; Remap global keys
;;(define-key global-map "\C-h" 'delete-backward-char)
;;(define-key global-map "\C-xb" 'iswitchb-buffer)
;;(define-key global-map "\C-x\C-b" 'ibuffer)
(define-key global-map "\C-x\C-b" 'helm-mini)
(define-key global-map "\C-x " 'just-one-space)
(define-key global-map "\M- " 'set-mark-command)
(define-key global-map "\M-g" 'goto-line)
(define-key global-map "\M-=" 'what-line)
(define-key global-map [(control x) return] nil)	;; make `C-x C-m' and `C-x RET' different
(define-key global-map "\C-xg" 'magit-status)            ;; enter the magit status buffer.
(define-key global-map "\C-cc" 'comment-region)
(define-key global-map "\C-cu" 'uncomment-region)

(global-set-key (kbd "C-c w") 'copy-word)
(global-set-key (kbd "C-c m") 'mark-word)

;; Helm bindings
;;;;;;; Helm ;;;;;;;;;;;
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(define-key helm-find-files-map (kbd "<tab>")         'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "C-<backspace>") 'helm-find-files-up-one-level)

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [del] 'delete-char)
;;(global-set-key [f5] 'undo)
(global-set-key [f6] "\C-x\C-s\C-x0")
(global-set-key [f7] 'pop-global-mark)
(global-set-key [f8] 'unpop-to-global-mark-command)     ;;Defined in efuncs.el



;; Define mouse keys for my anker TM137G mouse.
(global-set-key [mouse-8] 'kill-ring-save)  ;; Copy region
(global-set-key [mouse-9] 'kill-region)     ;; Cut
;; [mouse-2] (mouse wheel) points to 'yank = paste region.
;; [mouse-3] (right click) points to mouse-save-then-kill (left click and then select region with right click)

;; Change the binding of mouse button 2, so that it inserts the selection at point
;; (where the text cursor is), instead of at the position clicked
;; (and window-system
;;     ((define-key global-map 'button2 'x-insert-selection)))

;; Put personal favorites in the CTRL-O keymap
(defvar ctrl-o-map (make-keymap)
  "Keymap for subcommands of C-o.")

(fset 'ctrl-o-prefix ctrl-o-map)
(define-key global-map "\^o" 'ctrl-o-prefix)
(define-key ctrl-o-map "a" 'auto-fill-mode)
(define-key ctrl-o-map "c" 'copy-word)
(define-key ctrl-o-map "f" 'c-mark-function)
(define-key ctrl-o-map "g" 'goto-line)
(define-key ctrl-o-map "m" 'compile)
(define-key ctrl-o-map "p" 'pastie-region)
(define-key ctrl-o-map "r" 'query-replace-regexp)
(define-key ctrl-o-map "t" 'toggle-selective-display)
(define-key ctrl-o-map "y" 'rectangle-mark-mode)
(define-key ctrl-o-map "v" 'mark-word)
(define-key ctrl-o-map "w" 'whitespace-cleanup)
(define-key ctrl-o-map "\C-o" 'open-line)
;; Golang
(define-key ctrl-o-map "j" 'godef-jump)
(define-key ctrl-o-map "k" 'pop-global-mark)

;;Unused
;;(define-key ctrl-o-map "n" 'my-mark-word)
;;(define-key ctrl-o-map "h" 'hscroll-mode)
;;(define-key ctrl-o-map "b" 'shell-clear-region)


;; Set the initial directory for cscope

;;; end ~/emacs/lisp/ekeys.el
