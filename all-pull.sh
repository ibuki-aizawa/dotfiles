#!/bin/sh

dir_path="./*"

# $dir_pathに合致するgitリポジトリのディレクトリをforループで処理
for dir in $dir_path;
do
  (
    # 処理対象のgitリポジトリを表示
    echo $dir
    # gitリポジトリのトップディレクトリへ移動
    cd $dir
    # git pullコマンドでリモートリポジトリの変更を取得
    git pull
  )
done

