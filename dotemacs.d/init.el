(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
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
(global-subword-mode 1)
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
;; C-a takes you to start of indentation
(global-set-key (kbd "C-a") 'back-to-indentation)
;; M-m takes you to start of the line
(global-set-key (kbd "M-m") 'move-beginning-of-line)
;; Kill the current buffer, don't ask for selection
(global-set-key (kbd "C-x k") 'kill-current-buffer)
;; Use forward-to-word for M-f
(global-set-key (kbd "M-f") 'forward-to-word)
;; Use swiper-helm for search
(global-set-key (kbd "M-s") 'swiper-helm)
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


;; Gnu Global support
;;(require 'ggtags)
;;(setq ggtags-auto-jump-to-match nil)
;;(add-hook 'c-mode-hook 'ggtags-mode)
;;(add-hook 'c++-mode-hook 'ggtags-mode)
;;(add-hook 'asm-mode-hook 'ggtags-mode)
(global-auto-complete-mode t)

;; Helm config
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x c o") 'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)

(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)
(setq helm-M-x-fuzzy-match t)

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(setq
 helm-gtags-ignore-case t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-c g f") 'helm-gtags-find-files)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)


;; Smartparens
(require 'smartparens-config)
(add-hook 'c-mode-hook 'turn-on-smartparens-strict-mode)
(setq sp-escape-quotes-after-insert nil)

;; Magit
(global-set-key (kbd "C-x C-g") 'magit-status)
;; Smerge
(setq smerge-command-prefix (kbd "C-c C-v"))

;; bitbake files support
(require 'bb-mode)
(setq auto-mode-alist (cons '("\\.bb$" . bb-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.inc$" . bb-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bbappend$" . bb-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bbclass$" . bb-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.conf$" . bb-mode) auto-mode-alist))

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
 '(package-selected-packages
   '(smartparens auto-complete swiper-helm helm-rg magit helm helm-gtags)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
