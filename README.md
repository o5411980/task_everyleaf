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
