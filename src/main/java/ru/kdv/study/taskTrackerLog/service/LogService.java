package ru.kdv.study.taskTrackerLog.service;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kdv.study.taskTrackerLog.model.LogLine;
import ru.kdv.study.taskTrackerLog.repository.LogRepository;

@Service
@RequiredArgsConstructor
public class LogService {

    private final LogRepository logRepository;

    @Transactional(rollbackFor = Exception.class)
    public void insert(LogLine logLine) {
        logRepository.insert(logLine);
    }

    @Transactional(readOnly = true)
    public JsonNode getLog(Long id) {
        return logRepository.getLog(id);
    }
}
