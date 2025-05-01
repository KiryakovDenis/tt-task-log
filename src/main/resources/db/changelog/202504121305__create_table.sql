CREATE TABLE tt_task_log.task_log (
    logtime timestamp DEFAULT current_timestamp,
    operation varchar NOT NULL,
    task_id integer NOT NULL,
    task_doc jsonb NOT NULL
);