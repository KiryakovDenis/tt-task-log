UPDATE tt_task_log.task_log
   SET operation = CASE WHEN operation = 'I' THEN 'INSERT'
                        ELSE 'UPDATE'
                    END