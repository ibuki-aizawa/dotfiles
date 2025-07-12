
(prefer-coding-system 'utf-8)
(set-language-environment 'Japanese)

;(setq inhibit-startup-screen t)
;; ウェルカムページを無効化 

;; 行番号を表示
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(column-number-mode t)

;; タイトルバーにフルパスを表示
(setq frame-title-format "%f")

;; C-hでバックスペース
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; テーマ
(load-theme 'leuven-dark t)

;; 現在行を強調
(global-hl-line-mode)

;; バックアップファイルの作成場所をtmpフォルダに変更する
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

;; オートセーブファイルの作成場所をtmpフォルダに変更する
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; ファイルの変更時 dired を自動更新
(add-hook 'dired-mode-hook 'auto-revert-mode)
