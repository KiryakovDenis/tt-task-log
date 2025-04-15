CREATE OR REPLACE VIEW tt_task_log.v_task_log as
WITH data_ AS (
SELECT a.operation
      ,a.logtime
      ,a.task_doc -> 'id' AS id
      ,a.task_doc -> 'title' AS title
      ,a.task_doc -> 'author' AS author
      ,a.task_doc -> 'editor' AS editor
      ,a.task_doc -> 'status' AS status
      ,a.task_doc -> 'assignee' AS assignee
      ,a.task_doc -> 'deadLine' AS dead_line
      ,a.task_doc -> 'createdAt' AS created_at
      ,a.task_doc -> 'updatedAt' AS updated_at
      ,a.task_doc -> 'description' AS description
  FROM tt_task_log.task_log a),
data_with_changes AS (
    SELECT a1.operation
          ,a1.logtime
          ,a1.id
          ,a1.title AS curr_title
          ,lag(a1.title) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_title
          ,a1.author AS curr_author
          ,lag(a1.author) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_author
          ,a1.editor AS curr_editor
          ,lag(a1.editor) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_editor
          ,a1.status AS curr_status
          ,lag(a1.status) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_status
          ,a1.assignee AS curr_assignee
          ,lag(a1.assignee) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_assignee
          ,a1.dead_line AS curr_dead_line
          ,lag(a1.dead_line) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_dead_line
          ,a1.created_at AS curr_created_at
          ,lag(a1.created_at) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_created_at
          ,a1.updated_at AS curr_updated_at
          ,lag(a1.updated_at) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_updated_at
          ,a1.description AS curr_description
          ,lag(a1.description) OVER (PARTITION BY a1.id ORDER BY a1.logtime) AS prev_description
      FROM data_ a1)
SELECT a2.id
      ,a2.logtime
      ,a2.operation
      ,CASE
          WHEN (a2.curr_title != a2.prev_title)
               OR
               (a2.prev_title IS NULL AND a2.curr_title IS NOT NULL) THEN
            'title:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_title::VARCHAR || chr(13)
                 ELSE a2.prev_title::VARCHAR || '=>' || a2.curr_title::VARCHAR || chr(13)
             end
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_author != a2.prev_author)
               OR
               (a2.prev_author IS NULL AND a2.curr_author IS NOT NULL) THEN
            'author:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_author::VARCHAR || chr(13)
                 ELSE a2.prev_author::VARCHAR || '=>' || a2.curr_author::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_editor != a2.prev_editor)
               OR
               (a2.prev_editor IS NULL AND a2.curr_editor IS NOT NULL)  THEN
            'editor:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_editor::VARCHAR || chr(13)
                 ELSE a2.prev_editor::VARCHAR || '=>' || a2.curr_editor::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_status != a2.prev_status)
               OR
               (a2.prev_status IS NULL AND a2.curr_status IS NOT NULL)  THEN
            'status:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_status::VARCHAR || chr(13)
                 ELSE a2.prev_status::VARCHAR || '=>' || a2.curr_status::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_assignee != a2.prev_assignee)
               OR
               (a2.prev_assignee IS NULL AND a2.curr_assignee IS NOT NULL)  THEN
            'assignee:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_assignee::VARCHAR || chr(13)
                 ELSE a2.prev_assignee::VARCHAR || '=>' || a2.curr_assignee::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_dead_line != a2.prev_dead_line)
               OR
               (a2.prev_dead_line IS NULL AND a2.curr_dead_line IS NOT NULL)  THEN
            'dead_line:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_dead_line::VARCHAR || chr(13)
                 ELSE a2.prev_dead_line::VARCHAR || '=>' || a2.curr_dead_line::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_created_at != a2.prev_created_at)
               OR
               (a2.prev_created_at IS NULL AND a2.curr_created_at IS NOT NULL) THEN
            'created_at:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_created_at::VARCHAR || chr(13)
                 ELSE a2.prev_created_at::VARCHAR || '=>' || a2.curr_created_at::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_updated_at != a2.prev_updated_at)
               OR
               (a2.prev_updated_at IS NULL AND a2.curr_updated_at IS NOT NULL)  THEN
            'updated_at:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_updated_at::VARCHAR || chr(13)
                 ELSE a2.prev_updated_at::VARCHAR || '=>' || a2.curr_updated_at::VARCHAR || chr(13)
             END
          ELSE ''
      END ||
      CASE
          WHEN (a2.curr_description != a2.prev_description)
               OR
               (a2.prev_description IS NULL AND a2.curr_description IS NOT NULL)  THEN
            'description:' ||
            CASE WHEN a2.operation = 'I' THEN a2.curr_description::VARCHAR || chr(13)
                 ELSE a2.prev_description::VARCHAR || '=>' || a2.curr_description::VARCHAR || chr(13)
             END
          ELSE ''
      END AS log_text
  FROM data_with_changes a2