User

| カラム物理名    | 型      |
| --------------- | ------- |
| id              | integer |
| user_name       | string  |
| email           | string  |
| password_digest | string  |
| admin           | boolean |

<br>
Task

| カラム物理名 | 型       |
| ------------ | -------- |
| id           | integer  |
| task_name    | string   |
| detail       | string   |
| deadline     | datetime |
| priority     | boolean  |
| status       | string   |
| user_id      | integer  |

<br>
Label

| カラム物理名 | 型      |
| ------------ | ------- |
| id           | integer |
| label_name   | string  |
| user_id      | integer |

<br>
Label_record

| カラム物理名 | 型      |
| ------------ | ------- |
| id           | integer |
| task_id      | integer |
| label_id     | integer |


●デプロイ手順 <br>
githubとherokuの連携設定済みのため、下記手順でデプロイを行う。<br>
~~~
・stepX ブランチで開発を完了
・Gemfileのruby2.6.5をコメントアウト
・% bundle install
・% git add -A
・% git commit -m "コミットメッセージ"
・% git push origin stepX
その後、プルリクを作成し、reviewを受けて、masterにmergeされたら自動deploy
~~~
