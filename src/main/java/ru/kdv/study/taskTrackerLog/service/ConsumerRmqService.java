package ru.kdv.study.taskTrackerLog.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Service;
import ru.kdv.study.taskTrackerLog.model.LogLine;
import ru.kdv.study.taskTrackerLog.model.dto.LogRequest;

@Service
@RequiredArgsConstructor
public class ConsumerRmqService {

    private final LogService logService;

    @RabbitListener(queues = "${app.rabbitmq.queue}")
    public void recive (LogRequest logRequest) {
        logService.insert(
                LogLine.builder()
                        .logOperation(logRequest.getLogOperation())
                        .task(new JSONObject(logRequest.getTask()))
                .build()
        );
    }
}
