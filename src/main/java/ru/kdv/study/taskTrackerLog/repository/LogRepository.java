package ru.kdv.study.taskTrackerLog.repository;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import ru.kdv.study.taskTrackerLog.exception.DataBaseException;
import ru.kdv.study.taskTrackerLog.model.LogLine;
import ru.kdv.study.taskTrackerLog.repository.mapper.JsonNodeRowMapper;

@RequiredArgsConstructor
@Slf4j
@Repository
public class LogRepository {

    private final static String INSERT = """
            INSERT INTO tt_task_log.task_log (operation, task_id, task_doc)
            VALUES (:operation, :task_id, :task_doc::jsonb)
            """;

    private final static String SELECT = """
                SELECT JSON_AGG(JSON_BUILD_OBJECT('log_time', a.log_time,
                                                  'operation', a.operation,
                                                  'event_log', a.event_log::VARCHAR)) AS json_result
                  FROM tt_task_log.v_task_log a
                 WHERE a.id::integer = :task_id
            """;

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final JsonNodeRowMapper jsonNodeRowMapper;

    public void insert(LogLine logLine) {
        try {
            jdbcTemplate.update(INSERT, logLineToSql(logLine));
        } catch (Exception e) {
            log.error(e.getMessage());
            log.error(e.getCause().toString());
            log.error(logLine.toString());
        }
    }

    public JsonNode getLog(Long id) {
        try {
            return jdbcTemplate.queryForObject(SELECT, new MapSqlParameterSource("task_id", id), jsonNodeRowMapper);

        } catch (Exception e) {
            throw DataBaseException.create(e.getMessage());
        }
    }

    private MapSqlParameterSource logLineToSql(LogLine logLine) throws JSONException {
        MapSqlParameterSource params = new MapSqlParameterSource();

        params.addValue("operation", logLine.getLogOperation().name());
        params.addValue("task_id", logLine.getTask().get("id"));
        params.addValue("task_doc", logLine.getTask().toString());
        return params;
    }
}