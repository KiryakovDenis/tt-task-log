package ru.kdv.study.taskTrackerLog.model;

public enum LogOperation {
    I ("insert"),
    U ("update");

    private final String description;

    LogOperation(String description) {
        this.description = description;
    }

    public String getDescription () {
        return this.description;
    }
}
