;; NOTE: This must be loaded after evil and hydra

(defvar writemacs-quotes-file
  (expand-file-name "~/Dropbox/Projects/quotes.org")
  "The file where selected text will be appended as org quotes.")

;; Variables to store the last used inputs
(defvar writemacs-quotes-last-author ""
  "Remembers the last author entered for org quotes.")

(defvar writemacs-quotes-last-source ""
  "Remembers the last source entered for org quotes.")


(evil-define-operator writemacs-quote-evil-region (beg end type)
  "Append Evil visual selection under a heading with AUTHOR, SOURCE, and TIMESTAMP properties."
  :keep-visual nil
  (interactive "<R>")
  (let* ((text (buffer-substring-no-properties beg end))
         (timestamp (format-time-string "[%Y-%m-%d %a %H:%M]"))
         
         ;; Setup Author Prompt
         (author-prompt (if (string-blank-p writemacs-quotes-last-author)
                            "Enter author: "
                          (format "Enter author (default %s): " writemacs-quotes-last-author)))
         (author (read-string author-prompt nil nil writemacs-quotes-last-author))
         
         ;; Setup Source Prompt
         (source-prompt (if (string-blank-p writemacs-quotes-last-source)
                            "Enter source: "
                          (format "Enter source (default %s): " writemacs-quotes-last-source)))
         (source (read-string source-prompt nil nil writemacs-quotes-last-source))
         
         ;; Initialize the property block
         (props (concat ":PROPERTIES:\n"
                        (format ":TIMESTAMP: %s\n" timestamp))))
    
    ;; Update the global variables with the new input
    (setq writemacs-quotes-last-author author)
    (setq writemacs-quotes-last-source source)

    ;; Conditionally add Author and Source to the properties drawer if they aren't blank
    (unless (string-blank-p author)
      (setq props (concat props (format ":AUTHOR: %s\n" author))))
    (unless (string-blank-p source)
      (setq props (concat props (format ":SOURCE: %s\n" source))))
    
    ;; Close the properties drawer
    (setq props (concat props ":END:\n"))

    ;; Format the final output string
    (let ((formatted-text (format "\n* Quote %s\n%s#+BEGIN_QUOTE\n%s\n#+END_QUOTE\n" 
                                  timestamp props text)))
      
      (append-to-file formatted-text nil writemacs-quotes-file)
      (message "Appended quote to %s" writemacs-quotes-file))))


(defhydra writemacs-quotation (:timeout 4)
  "add quotation"
  ("a" writemacs-quote-evil-region "Add quote")
  ("o" (find-file writemacs-quotes-file) "Open quotes")
  ("f" nil "Finished"))

(writemacs/leader-keys
  "tq" '(writemacs-quotation/body :which-key "add quotation"))

(provide 'quotations)
