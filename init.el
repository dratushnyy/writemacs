;; Most of this config is copied from emacs-from-scratch repo and videos

;; Startup in the projects root directory
(defun writemacs/startup-hook ()
  (cd writemacs/projects-root-dir))
(add-hook 'emacs-startup-hook #'writemacs/startup-hook)


;; To load config files from the same directory as this init.el
(let ((current-dir (file-name-directory (or load-file-name buffer-file-name))))
  ;; Add the current directory to Emacs' load path
  (add-to-list 'load-path current-dir)
  ;; Use expand-file-name to properly concatenate the path and filename
  (setq custom-file (expand-file-name "vars.el" current-dir)))

(load custom-file 'noerror 'nomessage)


;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun writemacs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'writemacs/display-startup-time)


;; Basic Config
(setq inhibit-startup-message t)
(setq use-dialog-box nil)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 20)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar
(recentf-mode 1)            ; Recent files
(setq history-length writemacs/minibuff-history-length)    ; Max history lendth
(savehist-mode 1)           ; Saving command history
(save-place-mode 1)         ; Save the place in the file
(global-auto-revert-mode 1) ; Revert buffers when underlying files has changes
(setq global-auto-revert-non-file-buffers t)

;; Set the exact format: Day abbreviation, Hour:Minute:Second
(setq display-time-format "%a, %H:%M:%S")

;; Force the clock to update every 1 second
(setq display-time-interval 1)

;; Restart the mode to apply the new interval and format immediately
(display-time-mode 1)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; Set fonts
(set-face-attribute 'default nil :font writemacs/default-fixed-pitch-font :height writemacs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font writemacs/default-fixed-pitch-font :height writemacs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font writemacs/default-variable-pitch-font :height writemacs/default-variable-font-size :weight 'regular)



;; Set theme
(use-package all-the-icons)
;; RUN M-x nerd-icons-install-fonts
;; RUN M-x all-the-icons-install-fonts


(use-package doom-themes
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled  ;; for treemacs users
  (doom-themes-treemacs-theme writemacs/treemacs-theme) ; use "doom-colors" for less minimal icon theme
  :config
  (load-theme writemacs/default-theme t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Setup mode line
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-icon t)
  (setq display-time t))


;; Set pomodoro timer sound
(setq org-clock-sound writemacs/pomodoro-end-sound)


;; Set line and column numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))



;; Set additional help
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))



(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after counsel
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))


;; Evil
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)

  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


(require 'keybindings)
(require 'quotations)

;; Projectile settins
;; maybe not very usefull for me
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p writemacs/projects-root-dir) )
    (setq projectile-project-search-path 'writemacs/projects-root-dir)
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))


;; Git setup
;; maybe not very usefull for me. 
(use-package magit
  :commands (magit-status magit-get-current-branch))

(require 'formatting)


