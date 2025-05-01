package ru.kdv.study.taskTrackerLog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import org.json.JSONObject;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@Builder
public class LogLine {
    private LocalDateTime logTime;
    private LogOperation logOperation;
    private JSONObject task;
}
