
; utf-8
(prefer-coding-system 'utf-8)

;(setq inhibit-startup-screen t)
;; ウェルカムページを無効化 

;; 行番号を表示
(global-display-line-numbers-mode t)

;; 行番号を相対表示
(setq display-line-numbers-type 'relative)

;; C-hでバックスペース
(global-set-key "\C-h" 'delete-backward-char)

;; テーマ
(load-theme 'leuven-dark t)

;; language
(set-language-environment 'Japanese)

;; 現在行を強調
(global-hl-line-mode)

;; ファイルの変更時 dired を自動更新
(add-hook 'dired-mode-hook 'auto-revert-mode)
