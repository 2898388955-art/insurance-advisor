package com.insure.advisor.conversation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Schema(description = "会话")
public class ConversationVO {

    private Long id;

    private String title;

    private String lastIntent;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
