(defun writemacs-setup-org-editing ()
  "Enable auto-fill with a specific width and activate additional minor modes."
  ;; 1. Set the fill column locally for this buffer
  (setq-local fill-column writemacs/org-fill-width)
  
  ;; 2. Enable auto-fill-mode
  (auto-fill-mode 1)
  
  ;; 3. Loop through and enable extra minor modes safely
  (dolist (mode writemacs/org-minor-modes)
    (if (fboundp mode)
        (funcall mode 1)
      (message "Warning: Minor mode '%s' is not installed or defined." mode))))

;; this confg is copied from emacs-from-scratch
(defun writemacs/org-mode-setup ()
  (org-indent-mode)
  
  (auto-fill-mode 1)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun writemacs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Lora" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . writemacs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (writemacs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun writemacs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . writemacs/org-mode-visual-fill))

(provide 'formatting)
