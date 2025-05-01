DROP VIEW tt_task_log.v_task_log;
CREATE OR REPLACE VIEW tt_task_log.v_task_log as
WITH data_ AS (
SELECT a.operation
      ,a.logtime
      ,a.task_doc ->> 'id' AS id
      ,a.task_doc ->> 'title' AS title
      ,a.task_doc ->> 'author' AS author
      ,a.task_doc ->> 'editor' AS editor
      ,a.task_doc ->> 'status' AS status
      ,a.task_doc ->> 'assignee' AS assignee
      ,a.task_doc ->> 'deadLine' AS dead_line
      ,a.task_doc ->> 'createdAt' AS created_at
      ,a.task_doc ->> 'updatedAt' AS updated_at
      ,a.task_doc ->> 'description' AS description
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
      FROM data_ a1),
pure_cahnges AS (
  SELECT a.operation
        ,a.logtime
        ,a.id
        ,CASE WHEN a.curr_title::varchar != COALESCE(a.prev_title::varchar, '') THEN
                jsonb_build_object('title',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_title::varchar
                         ELSE a.prev_title::varchar || ' -> ' || a.prev_title::varchar
                     END
                )
              ELSE NULL
          END AS title
        ,CASE WHEN a.curr_author::varchar != COALESCE(a.prev_author::varchar, '') THEN
                jsonb_build_object('author',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_author::varchar
                         ELSE a.prev_author::varchar || ' -> ' || a.prev_author::varchar
                     END
                )
              ELSE NULL
          END AS author
        ,CASE WHEN a.curr_editor::varchar != COALESCE(a.prev_editor::varchar, '') THEN
                jsonb_build_object('author',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_editor::varchar
                         ELSE a.prev_editor::varchar || ' -> ' || a.prev_editor::varchar
                     END
                )
              ELSE NULL
          END AS editor
        ,CASE WHEN a.curr_status::varchar != COALESCE(a.prev_status::varchar, '') THEN
                jsonb_build_object('status',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_status::varchar
                         ELSE a.prev_status::varchar || ' -> ' || a.prev_status::varchar
                     END
                )
              ELSE NULL
          END AS status
        ,CASE WHEN a.curr_assignee::varchar != COALESCE(a.prev_assignee::varchar, '') THEN
                jsonb_build_object('assignee',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_assignee::varchar
                         ELSE a.prev_assignee::varchar || ' -> ' || a.prev_assignee::varchar
                     END
                )
              ELSE NULL
          END AS assignee
        ,CASE WHEN a.curr_dead_line::varchar != COALESCE(a.prev_dead_line::varchar, '') THEN
                jsonb_build_object('dead_line',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_dead_line::varchar
                         ELSE a.prev_dead_line::varchar || ' -> ' || a.prev_dead_line::varchar
                     END
                )
              ELSE NULL
          END AS dead_line
        ,CASE WHEN a.curr_created_at::varchar != COALESCE(a.prev_created_at::varchar, '') THEN
                jsonb_build_object('created_at',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_created_at::varchar
                         ELSE a.prev_created_at::varchar || ' -> ' || a.prev_created_at::varchar
                     END
                )
              ELSE NULL
          END AS created_at
        ,CASE WHEN a.curr_updated_at::varchar != COALESCE(a.prev_updated_at::varchar, '') THEN
                jsonb_build_object('updated_at',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_updated_at::varchar
                         ELSE a.prev_updated_at::varchar || ' -> ' || a.prev_updated_at::varchar
                     END
                )
              ELSE NULL
          END AS updated_at
        ,CASE WHEN a.curr_description::varchar != COALESCE(a.prev_description::varchar, '') THEN
                jsonb_build_object('description',
                    CASE WHEN a.operation = 'INSERT' THEN a.curr_description::varchar
                         ELSE a.prev_description::varchar || ' -> ' || a.prev_description::varchar
                     END
                )
              ELSE NULL
          END AS description
    FROM data_with_changes a
)
SELECT a2.id, a2.logtime, a2.operation, jsonb_build_object('change_event', jsonb_agg(a2.change_event)) AS event_log
  FROM (SELECT a1.id, a1.logtime, a1.operation,
                CASE WHEN a.rn = 1 THEN title
                    WHEN a.rn = 2 THEN editor
                    WHEN a.rn = 3 THEN status
                    WHEN a.rn = 4 THEN assignee
                    WHEN a.rn = 5 THEN dead_line
                    WHEN a.rn = 6 THEN created_at
                    WHEN a.rn = 7 THEN updated_at
                    WHEN a.rn = 8 THEN description
                    WHEN a.rn = 9 THEN title
                END AS change_event
          FROM pure_cahnges a1
          CROSS JOIN (SELECT generate_series(1, 9) AS rn) a) a2
 WHERE a2.change_event IS NOT NULL
 GROUP BY a2.id, a2.logtime, a2.operation