package ru.kdv.study.taskTrackerLog.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kdv.study.taskTrackerLog.model.LogLine;
import ru.kdv.study.taskTrackerLog.model.dto.LogResponse;
import ru.kdv.study.taskTrackerLog.repository.LogRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LogService {

    private final LogRepository logRepository;

    @Transactional(rollbackFor = Exception.class)
    public void insert(LogLine logLine) {
        logRepository.insert(logLine);
    }

    public List<LogResponse> getLog(Long id) {
        return logRepository.getLog(id);
    }
}
