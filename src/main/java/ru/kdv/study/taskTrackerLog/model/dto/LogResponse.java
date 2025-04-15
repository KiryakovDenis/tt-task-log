package ru.kdv.study.taskTrackerLog.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import ru.kdv.study.taskTrackerLog.model.LogOperation;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@Builder
public class LogResponse {
    private LocalDateTime logTime;
    private LogOperation logOperation;
    private String logText;
}
