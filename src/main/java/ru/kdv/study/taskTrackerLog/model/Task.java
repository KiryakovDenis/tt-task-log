package ru.kdv.study.taskTrackerLog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@AllArgsConstructor
@Data
@Builder
public class Task {
    private Long id;
    private String title;
    private String description;
    private String status;
    private LocalDateTime deadLine;
    private Long assignee;
    private Long author;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Long editor;
}