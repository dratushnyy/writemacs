;; Keybindings file
;; should be loaded after evil mode

(use-package general
  :config
  (general-create-definer writemacs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (writemacs/leader-keys
    "t"  '(:ignore t :which-key "toggles")))


(use-package hydra)
(defhydra writemacs-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("" nil "finished" :exit t))

(writemacs/leader-keys
  "ts" '(writemacs-text-scale/body :which-key "scale text"))

(defhydra writemacs-pomodoro (:timeout 4 :color blue :hint nil)
  "pomodoro timers"
  ("w" (org-timer-set-timer "25") "Work")
  ("s" (org-timer-set-timer "5") "Short break")
  ("l" (org-timer-set-timer "15") "Long break")
  ("p" org-timer-pause-or-continue "Pause/Resume" :color red)
  ("x" org-timer-stop "Stop")
  ("q" nil "Quit"))   

(writemacs/leader-keys
  "tp" '(writemacs-pomodoro/body :which-key "pomodoro timers"))

(provide 'keybindings)
