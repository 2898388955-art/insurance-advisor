package com.insure.advisor.conversation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@Schema(description = "新建会话")
public class CreateConversationRequest {

    @Size(max = 200, message = "标题不能超过 200 字")
    private String title;
}
