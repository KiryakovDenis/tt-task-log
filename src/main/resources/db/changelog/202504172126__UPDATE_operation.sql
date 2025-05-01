UPDATE tt_task_log.task_log
   SET operation = CASE WHEN operation = 'I' THEN 'INSERT'
                        WHEN operation = 'U' THEN 'UPDATE'
                    END
 WHERE operation in ('I', 'U')