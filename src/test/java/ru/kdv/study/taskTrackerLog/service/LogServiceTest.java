package ru.kdv.study.taskTrackerLog.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.json.JSONObject;
import ru.kdv.study.taskTrackerLog.exception.DataBaseException;
import ru.kdv.study.taskTrackerLog.model.LogLine;
import ru.kdv.study.taskTrackerLog.model.LogOperation;
import ru.kdv.study.taskTrackerLog.model.Task;
import ru.kdv.study.taskTrackerLog.repository.LogRepository;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertThrows;

@ExtendWith(MockitoExtension.class)
public class LogServiceTest {

    @Mock
    private LogRepository logRepository;

    @InjectMocks
    private LogService logService;

    private final LogLine validLogLine = LogLine.builder()
            .logOperation(LogOperation.INSERT)
            .task(new JSONObject(
                    Task.builder()
                            .id(1L)
                            .status("TO_DO")
                            .description("description")
                            .title("title")
                            .deadLine(LocalDateTime.of(2025,8,01,0,0, 0))
                            .assignee(1L)
                            .author(1L)
                            .createdAt(LocalDateTime.now())
                            .build()
                    )
            )
            .build();

    @Test
    @DisplayName("Ошибка БД при запросле лога по ид задачи")
    public void validateDataBaseExceptionGetLog() {
        Mockito.when(logService.getLog(1L)).thenThrow(DataBaseException.class);
        assertThrows(DataBaseException.class, () -> logService.getLog(1L));
    }
}