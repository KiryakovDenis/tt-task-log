package ru.kdv.study.taskTrackerLog.repository.mapper;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import ru.kdv.study.taskTrackerLog.model.LogOperation;
import ru.kdv.study.taskTrackerLog.model.dto.LogResponse;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

@Component
public class LogResponseMapper implements RowMapper<LogResponse> {
    @Override
    public LogResponse mapRow(ResultSet rs, int rowNum) throws SQLException {
        return LogResponse.builder()
                .logTime(rs.getObject("logtime", LocalDateTime.class))
                .logOperation(LogOperation.valueOf(rs.getString("operation")))
                .logText(rs.getString("event_log"))
                .build();
    }
}
