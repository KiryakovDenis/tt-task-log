package ru.kdv.study.taskTrackerLog.exception;

public class MappingException extends RuntimeException {
    public static MappingException create(String message) {
        return new MappingException(message);
    }

    public MappingException(String message) {
        super(message);
    }
}
