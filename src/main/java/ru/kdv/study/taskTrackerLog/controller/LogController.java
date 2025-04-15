package ru.kdv.study.taskTrackerLog.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.kdv.study.taskTrackerLog.model.dto.LogResponse;
import ru.kdv.study.taskTrackerLog.service.LogService;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/tasklog")
@Tag(name = "tt_task_log", description = "Endpoint логирования изменений задач для системы Task Tracker")
public class LogController {

    private final LogService logService;

    @GetMapping("/{id}")
    @Operation(summary = "Получение лога по указанной задаче")
    public List<LogResponse> create(@PathVariable Long id) {
        return logService.getLog(id);
    }
}