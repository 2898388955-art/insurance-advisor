package com.insure.advisor.conversation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Schema(description = "会话消息")
public class MessageVO {

    private Long id;

    private String role;

    private String content;

    private String intent;

    @Schema(description = "引用条款 JSON 数组字符串")
    private String citationsJson;

    @Schema(description = "工具调用 JSON 数组字符串")
    private String toolsJson;

    private Integer elapsedMs;

    private LocalDateTime createdAt;
}
