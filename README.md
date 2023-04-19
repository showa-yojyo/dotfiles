---
title: ドットファイル README
author: プレハブ小屋 <yojyo@hotmail.com>
date: 2023-04-19 (Wed)
---

**Note: no one but me use this repository.**

このリポジトリーはいわゆるドットファイルのためのものだ。
本リポジトリーは完全に個人用だが、公開されているのは単に歴史上の理由による。

## 想定

現在想定している本リポジトリー利用環境は WSL であり、そこではシェルは Bash しか用いない。

本リポジトリーにおけるディレクトリー構造は次の仕様および実例に準拠する：

* [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
* [XDG Base Directory - ArchWiki](https://wiki.archlinux.org/title/XDG_Base_Directory)

この仕様の要点はアプリケーション構成ファイル群を次の三つに分類して管理するということだろう：

* 設定
* データ
* 履歴、キャッシュなどの流動的なファイル

本リポジトリーは `XDG_CONFIG_HOME` としてそのまま利用できることを目標とする（ことに途中からした）。
上の分類で言う設定を扱うわけだが、パスワードや認証データなどを含むファイルを含めてはならない。
それは別の XDG ディレクトリーに置くはずだ。

## 運用

基本的な Bash 設定ファイルは `bash/` に配置する。
新規 Bash 環境では次のコマンド実行を（好みでオプションを付加して）必要とする：

```console
bash$ cd
bash$ git clone git://github.com/showa-yojyo/dotfiles.git "$XDG_CONFIG_HOME"
bash$ ln -s "$XDG_CONFIG_HOME/bash/bashrc" .bashrc
bash$ ln -s "$XDG_CONFIG_HOME/bash/bash_profile" .bash_profile
```

リンク作成に必要な残りのファイルについては当該サブディレクトリーの内容を参照。

書いていて気づいたが、現在は XDG 環境変数を上述の Bash 設定ファイルのどこかで定義しているが、これは不適切である可能性がある。
そのため `XDG_CONFIG_HOME` を移転することができなくなる。

新しいアプリケーション・パッケージをシステムに導入する場合は、先述の実例資料を参考にしながら、対応されている設定ファイルのパスをよく確認してから追加するものとする。
以下に設定パス決定手順を要約をしておく：

* XDG 仕様に対応していれば、そのまま `$XDG_CONFIG_HOME/package/packagerc` などを追加することが可能だ。
* 設定ファイルを指定する環境変数を定義していれば、Bash 設定ファイルで
  `export PACKAGE_HOME="$XDG_CONFIG_HOME/package"` のようにする。
* 全く対応していなければ `HOME` からシンボリックリンクを用意するしかない：

   ```console
   bash$ cd ~
   bash$ ln -s "$XDG_CONFIG_HOME/package/packagerc" .packagerc
   ```

* リポジトリーのルート直下ではドットから始めるディレクトリーエントリー名称を極力避けること。

## 欠点

本リポジトリーは WSL というか Linux しか対応しなくなっているが、Windows にも対応したい。
Git ブランチでそれを実現するか、ディレクトリー構造を工夫するか、深く検討しなければ解決されないだろう。

また、先述のように `XDG_CONFIG_HOME` に任意のパスを割り当てたければファイル
`bash/bashrc` を変更することになる。これはリポジトリーの可搬性を著しく下げる。

## ライセンス

GitHub にリモートリポジトリーを置く以上、便宜的に `LICENSE` を含んでいる。
実際は、自作部分に関しては他人が自由に使っても全然気にしない。
