;; Define the fill width configuration
(defvar writemacs-org-fill-width 80
  "The character width for auto-fill-mode in Org buffers.")

;; Define an empty list of minor modes by default
(defvar writemacs-org-minor-modes nil
  "List of additional minor modes to enable when entering Org mode.
Example: '(flyspell-mode display-line-numbers-mode)")

(defun writemacs-setup-org-editing ()
  "Enable auto-fill with a specific width and activate additional minor modes."
  ;; 1. Set the fill column locally for this buffer
  (setq-local fill-column writemacs-org-fill-width)
  
  ;; 2. Enable auto-fill-mode
  (auto-fill-mode 1)
  
  ;; 3. Loop through and enable extra minor modes safely
  (dolist (mode writemacs-org-minor-modes)
    (if (fboundp mode)
        (funcall mode 1)
      (message "Warning: Minor mode '%s' is not installed or defined." mode))))

;; Attach the setup function to the Org mode hook
(add-hook 'org-mode-hook 'writemacs-setup-org-editing)

(provide 'formatting)
