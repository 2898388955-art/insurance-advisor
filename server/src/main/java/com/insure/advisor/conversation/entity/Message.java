package com.insure.advisor.conversation.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("message")
public class Message {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long conversationId;

    private String role;

    private String content;

    private String intent;

    private Integer tokenIn;

    private Integer tokenOut;

    private Integer latencyMs;

    private String traceId;

    private String citationsJson;

    private String toolsJson;

    private Integer elapsedMs;

    private LocalDateTime createdAt;
}
