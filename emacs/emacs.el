
; utf-8
(prefer-coding-system 'utf-8)

;(setq inhibit-startup-screen t)
;; ウェルカムページを無効化 

;; 行番号を表示
(global-display-line-numbers-mode t)

;; 行番号を相対表示
(setq display-line-numbers-type 'relative)

;;(global-unset-key (kbd "M-SPC"))
;;(global-set-key (kbd "M-SPC") 'mark-sexp)

;;(global-unset-key (kbd "C-M-SPC"))
;;(global-set-key (kbd "C-M-SPC") 'mark-sexp)

;; C-hでバックスペース
;(global-set-key "\C-h" 'delete-backward-char)

;; ヘルプ
;(global-set-key "\C-c\C-h" 'help-command)

;(global-set-key "\C-0" 'beginning-of-line)

;; テーマ
(load-theme 'leuven-dark t)

;; language
(set-language-environment 'Japanese)

;; 現在行を強調
(global-hl-line-mode)
