package ru.kdv.study.taskTrackerLog.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import ru.kdv.study.taskTrackerLog.model.LogOperation;
import ru.kdv.study.taskTrackerLog.model.Task;

@Data
@AllArgsConstructor
public class LogRequest {
    private LogOperation logOperation;
    private Task task;

}
