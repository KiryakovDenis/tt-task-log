package ru.kdv.study.taskTrackerLog.repository.mapper;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import ru.kdv.study.taskTrackerLog.exception.MappingException;

@Component
@RequiredArgsConstructor
public class JsonNodeRowMapper implements RowMapper<JsonNode> {
    private final ObjectMapper objectMapper;

    @Override
    public JsonNode mapRow(java.sql.ResultSet resultSet, int rowNum)  {
        try {
            return objectMapper.readTree(resultSet.getString("json_result"));
        } catch (Exception e) {
            throw MappingException.create(e.getMessage());
        }
    }

}
