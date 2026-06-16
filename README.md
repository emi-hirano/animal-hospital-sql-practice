# Animal Hospital SQL Practice

MySQL学習用に作成した動物病院データベースです。
Docker上のMySQL環境を構築し、DBeaverを利用してSQLの練習を行いました。

## 使用技術

- MySQL 8.x
- Docker Desktop
- DBeaver

## 内容

- 動物病院をテーマにしたサンプルデータ
- `JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `HAVING`
- サブクエリ
- 集計SQL

## ファイル

- `sql/init.sql` : テーブル作成とサンプルデータ
- `questions.md` : 練習問題
- `answers.sql` : 練習問題の回答例

## 学習できること

- 複数テーブルをつなぐ `JOIN`
- 診察がないペットも表示する `LEFT JOIN`
- 動物種別・獣医師別などの `GROUP BY` 集計
- 集計結果を絞り込む `HAVING`
- サブクエリを利用した段階的な集計
- 診察料と処置費を合計する集計SQL