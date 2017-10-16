;;; ~/emacs/lisp/efuncs.el

;; Different platforms use different line endings
(defun unix-file ()
  "Change the current buffer to Latin 1 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-unix t))

(defun dos-file ()
  "Change the current buffer to Latin 1 with DOS line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-dos t))

(defun mac-file ()
  "Change the current buffer to Latin 1 with Mac line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-mac t))

;; Steve Yegge's syntax highlighting->HTML transformer
;; http://steve.yegge.googlepages.com/saving-time
(defun syntax-highlight-region (start end)
  "Adds <font> tags into the region that correspond to the
current color of the text.  Throws the result into a temp
buffer, so you don't dork the original."
  (interactive "r")
  (let ((text (buffer-substring start end)))
    (with-output-to-temp-buffer "*html-syntax*"
      (set-buffer standard-output)
      (insert "<pre>")
      (save-excursion (insert text))
      (save-excursion (syntax-html-escape-text))
      (while (not (eobp))
	(let ((plist (text-properties-at (point)))
	      (next-change
	       (or (next-single-property-change
		    (point) 'face (current-buffer))
		   (point-max))))
	  (syntax-add-font-tags (point) next-change)
	  (goto-char next-change)))
      (insert "\n</pre>"))))

(global-set-key "%" 'match-paren)

;; Match parenthesis by pressing the % key like the VI editor          
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

(defun syntax-add-font-tags (start end)
  "Puts <font> tag around text between START and END."
  (let (face color rgb name r g b)
    (and
     (setq face (get-text-property start 'face))
     (or (if (listp face) (setq face (car face))) t)
     (setq color (face-attribute face :foreground nil t))
     (setq rgb (assoc (downcase color) color-name-rgb-alist))
     (destructuring-bind (name r g b) rgb
       (let ((text (buffer-substring-no-properties start end)))
	 (delete-region start end)
	 (insert (format "<font color=#%.2x%.2x%.2x>" r g b))
	 (insert text)
	 (insert "</font>"))))))

(defun syntax-html-escape-text ()
  "HTML-escapes all the text in the current buffer,
starting at (point)."
  (save-excursion (replace-string "<" "&lt;"))
  (save-excursion (replace-string ">" "&gt;")))

;; Support for copying fontified regions to the Windows clipboard
(require 'htmlize)
(and (eq window-system 'w32)
     (defun w32-fontified-region-to-clipboard (start end)
       "Htmlizes region, saves it as a html file, scripts Microsoft Word to
open in the background and to copy all text to the clipboard, then
quits. Useful if you want to send fontified source code snippets to
your friends using RTF-formatted e-mails.

Version: 0.2

Author:

Mathias Dahl, <mathias@cucumber.dahl.net>. Remove the big, green
vegetable from my e-mail address...

Requirements:

* htmlize.el
* wscript.exe must be installed and enabled
* Microsoft Word must be installed

Usage:

Mark a region of fontified text, run this function and in a number of
seconds you have the whole colorful text on your clipboard, ready to
be pasted into a RTF-enabled application.

"
       (interactive "r")
       (let ((snippet (buffer-substring start end))
	     (buf (get-buffer-create "*htmlized_to_clipboard*"))
	     (script-file-name (expand-file-name "~/tmp/htmlized_to_clipboard.vbs"))
	     (htmlized-file-name (expand-file-name "~/tmp/htmlized.html")))
	 (set-buffer buf)
	 (erase-buffer)
	 (insert snippet)
	 (let ((tmp-html-buf (htmlize-buffer)))
	   (set-buffer tmp-html-buf)
	   (write-file htmlized-file-name)
	   (kill-buffer tmp-html-buf))
	 (set-buffer buf)
	 (erase-buffer)
	 (setq htmlized-file-name 
	       (substitute ?\\ ?/ htmlized-file-name))
	 (insert
	  (concat
	   "Set oWord = CreateObject(\"Word.Application\")\n"
	   "oWord.Documents.Open(\"" htmlized-file-name "\")\n"
	   "oWord.Selection.HomeKey 6\n"
	   "oWord.Selection.EndKey 6,1\n"
	   "oWord.Selection.Copy\n"
	   "oWord.Quit\n"
	   "Set oWord = Nothing\n"))
	 (write-file script-file-name)
	 (kill-buffer nil)
	 (setq script-file-name
	       (substitute ?\\ ?/ script-file-name))
	 (w32-shell-execute nil "wscript.exe" 
			    script-file-name))))

;; Clear shell contents
(defun shell-clear-region ()
  (interactive)
  (delete-region (point-min) (point-max))
  (comint-send-input))

;; Quick and dirty code folding
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 1))))

;;; Slick copy for C-w and M-w to copy and kill current line without selection
;;; http://www.emacswiki.org/emacs/SlickCopy

    (defadvice kill-ring-save (before slick-copy activate compile)
      "When called interactively with no active region, copy a single line instead."
      (interactive
       (if mark-active (list (region-beginning) (region-end))
         (message "Copied line")
         (list (line-beginning-position)
               (line-beginning-position 2)))))

    (defadvice kill-region (before slick-cut activate compile)
      "When called interactively with no active region, kill a single line instead."
      (interactive
       (if mark-active (list (region-beginning) (region-end))
         (list (line-beginning-position)
               (line-beginning-position 2)))))


(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last mark-ring))))))

(defun unpop-to-global-mark-command ()
  "Unpop off global mark ring. Does nothing if mark ring is empty."
  (interactive)
      (when global-mark-ring
        (setq global-mark-ring (cons (copy-marker (mark-marker)) global-mark-ring))
        (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
        (when (null (mark t)) (ding))
        (setq global-mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last global-mark-ring))))))



;;;;;;;;;;;; Copy without selection ;;;;;;;;;;;;;;;;;;;
(defun get-point (symbol &optional arg)
      "get the point"
      (funcall symbol arg)
      (point)
     )

(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "copy thing between beg & end into kill ring"
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
	  (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end)))
  )


(defun paste-to-mark(&optional arg)
  "Paste things to mark, or to the prompt in shell-mode"
  (let ((pasteMe
	 (lambda()
	   (if (string= "shell-mode" major-mode)
	       (progn (comint-next-prompt 25535) (yank))
	     (progn (goto-char (mark)) (yank) )))))
    (if arg
	(if (= arg 1)
	    nil
	  (funcall pasteMe))
      (funcall pasteMe))
    ))


;;;;;;;; Marking words ;;;;;;;;;;;;
;; Marks words without underscore, hyphens
(defun mark-word-basic()
  "Select some line"
  (interactive)
  (let (p1 p2)
    (setq p1 (get-point 'backward-word))
    (setq p2 (get-point 'forward-word))
    (message "Marking %s:%s" p1 p2)
    (goto-char p1)
    (push-mark p2)
    (setq mark-active t)))

;; Marks word including underscore and hyphen
(defun mark-word()
  "Select some line"
  (interactive)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
	(with-syntax-table table
	  (mark-word-basic)
	)))

;; Code to select word including hyphens and underscores.
;; Similar to mark-word
(defun my-select-word()
  "Select some line"
  (interactive)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
	(with-syntax-table table
	  (let (p1 p2)
	    (setq p1 (get-point 'backward-word))
	    (setq p2 (get-point 'forward-word))
	    (message "Marking %s:%s" p1 p2)
	    (goto-char p1)
	    (push-mark p2)
	    (setq mark-active t)))
	))

;; Marking an entire line.
(defun my-select-line()
  "Select some line"
  (message "Indside my select lien")
  (interactive)
  (let (p1 p2)
    (setq p1 (line-beginning-position))
    (setq p2 (line-end-position))
    (message "Marking %s:%s" p1 p2)
    (goto-char p1)
    (push-mark p2)
    (setq mark-active t)))


(defun mark-thing (begin-of-thing end-of-thing &optional arg)
  "mark thing between beg & end"
  (message "Inside mark thing")
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
	  (end (get-point end-of-thing arg)))
      (message "Marking %s:%s" beg end)
      (goto-char beg)
      (push-mark end)
      (setq mark-active t)
      ))
  )


;;;;;;;;;; Copy word ;;;;;;;;;;;;;;;;;
;;; Modified to include underscore and hyphen as part of a word.
(defun copy-word (&optional arg)
      "Copy words at point into kill-ring"
      (interactive "P")
      (let ((table (copy-syntax-table (syntax-table))))
	(modify-syntax-entry ?_ "w" table)
	(modify-syntax-entry ?- "w" table)
	(with-syntax-table table
	  (copy-thing 'backward-word 'forward-word arg)))
      (message "Copied word")
       ;;(paste-to-mark arg)
     )
;; (global-set-key (kbd "C-c w") 'copy-word)
;; Enabled in ekeys.el


;;;;;;;;;; Copy string ;;;;;;;;;;;;
(defun beginning-of-string(&optional arg)
       "  "
       (re-search-backward "[ \t]" (line-beginning-position) 3 1)
     	     (if (looking-at "[\t ]")  (goto-char (+ (point) 1)) )
     )
(defun end-of-string(&optional arg)
  " "
  (re-search-forward "[ \t]" (line-end-position) 3 arg)
  (if (looking-back "[\t ]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-string-to-mark(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-string 'end-of-string arg)
  (paste-to-mark arg)
  )
;;  (global-set-key (kbd "C-c s")         (quote thing-copy-string-to-mark))

;;;;;;;;; Copy paragraph ;;;;;;;;;;;;;
     (defun copy-paragraph (&optional arg)
      "Copy paragraphes at point"
       (interactive "P")
       (copy-thing 'backward-paragraph 'forward-paragraph arg)
       (paste-to-mark arg)
       )
;;  (global-set-key (kbd "C-c p")         (quote copy-paragraph))

;;;;;;;;; Reload the emacs configuration ;;;;;;;;;
(defun reload-emacs(&optional arg)
  "Reload emacs config"
  (interactive "P")
  (message "reloading emacs config")
  (load-file "~/.emacs")
  )


;;; end ~/emacs/lisp/efuncs.el
