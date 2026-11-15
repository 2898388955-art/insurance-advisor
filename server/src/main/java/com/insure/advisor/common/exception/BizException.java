package com.insure.advisor.common.exception;

/**
 * 业务异常：可预期、需要把 message 返回给调用方的错误。
 * 系统异常交给 GlobalExceptionHandler 兜底，不暴露内部细节。
 */
public class BizException extends RuntimeException {

    private final int code;

    public BizException(String message) {
        this(4000, message);
    }

    public BizException(int code, String message) {
        super(message);
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
