(require 'package)
 (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;; Custom script load path
(add-to-list 'load-path "~/.emacs.d/lisp/")
;; Custom theme load path
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; set custom themes safe to load
(setq custom-safe-themes t)
;; Custom theme
(load-theme 'wheatgrass)
;; M-% for search replace
(global-set-key "\M-%" 'query-replace-regexp)
;; stop creating those backup~ files
(setq make-backup-files nil)
;; stop creating those #auto-save# files
(setq auto-save-default nil)
;; turn on bracket match highlight
(show-paren-mode 1)
;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)
;; make cursor movement stop in between camelCase words.
;(global-subword-mode 1)
;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
;; show cursor position within line
(column-number-mode 1)
;; keep a list of recently opened files
(require 'recentf)
(recentf-mode 1)
;; make return key also do indent, globally
(electric-indent-mode 1)
;; make tab key always call a indent command.
(setq tab-always-indent 'complete)
;; Disable all bars
(savehist-mode 1)
(menu-bar-mode -1)
;(tool-bar-mode -1)
;(scroll-bar-mode -1)
;; Disable startup messages
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(define-key global-map (kbd "RET") 'newline-and-indent)
;; Use ibuffer to list buffers
(defalias 'list-buffers 'ibuffer)
;; Use y/n for yes or no
(defalias 'yes-or-no-p 'y-or-n-p)
;; Make copy and paste go to/from clipboard
(setq x-select-enable-clipboard t)
;; Smooth scrolling
(setq scroll-conservatively 100)
;; Show size of file on the mode line
(size-indication-mode)
;; Show line number on the mode line
(line-number-mode)
;; Show column number on the mode line
(column-number-mode)
;; Show time
(display-time-mode)
;; Set 24H time mode
(setq display-time-24h-format t)
;; Delete duplicates in minibuffer history
(setq history-delete-duplicates t)

;; My key settings
;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)
;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))
;; Kill the current buffer, don't ask for selection
(global-set-key (kbd "C-x k") 'kill-current-buffer)
;; Use forward-to-word for M-f
(global-set-key (kbd "M-f") 'forward-to-word)
;; Use C-l to go up in dired mode. ^ is too far
(eval-after-load 'dired
  '(define-key dired-mode-map (kbd "C-l") 'dired-up-directory))
;; Make C-o smart to open a new line irrespective of the point position
;; and let it follow the indentation
(defun eol-and-nl()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "C-o") 'eol-and-nl)

;; Ivy
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-virtual-abbreviate 'full)
(setq ivy-count-format "(%d/%d) ")

;; Avy
(global-set-key (kbd "C-'") 'avy-goto-char-timer)

(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c r") 'counsel-rg)
(global-set-key (kbd "C-c f") 'counsel-fzf)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c b") 'counsel-bookmark)

;; Counsel-gtags
(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)

(with-eval-after-load 'counsel-gtags
  (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))

;; autocomplete
(global-auto-complete-mode t)

;; Smartparens
(require 'smartparens-config)
(add-hook 'c-mode-hook 'turn-on-smartparens-mode)
(setq sp-escape-quotes-after-insert nil)

;; Magit
(global-set-key (kbd "C-x C-g") 'magit-status)
;; Smerge
(setq smerge-command-prefix (kbd "C-c C-v"))

;; Indentation
(setq c-default-style "linux")
(defun kernel-mode()
  (interactive)
  (setq-default indent-tabs-mode t
		c-basic-offset 8
		tab-width 8))
(defun space-mode()
  (interactive)
  (setq-default indent-tabs-mode nil
		c-basic-offset 4
		tab-width 4))
(kernel-mode)

;; ediff split vertical
(setq ediff-split-window-function 'split-window-horizontally)

;; Added by emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(avy smartparens magit counsel auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
