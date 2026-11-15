package com.insure.advisor.conversation.controller;

import com.insure.advisor.common.web.ApiResponse;
import com.insure.advisor.common.web.PageResult;
import com.insure.advisor.conversation.dto.ConversationVO;
import com.insure.advisor.conversation.dto.CreateConversationRequest;
import com.insure.advisor.conversation.dto.MessageVO;
import com.insure.advisor.conversation.dto.RenameConversationRequest;
import com.insure.advisor.conversation.service.ConversationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "会话")
@RestController
@RequestMapping("/api/v1/conversations")
@RequiredArgsConstructor
public class ConversationController {

    private final ConversationService conversationService;

    @Operation(summary = "新建会话")
    @PostMapping
    public ApiResponse<ConversationVO> create(@Valid @RequestBody(required = false) CreateConversationRequest request) {
        return ApiResponse.ok(conversationService.create(request == null ? null : request.getTitle()));
    }

    @Operation(summary = "会话列表")
    @GetMapping
    public ApiResponse<PageResult<ConversationVO>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ApiResponse.ok(conversationService.list(page, size));
    }

    @Operation(summary = "查询会话")
    @GetMapping("/{id}")
    public ApiResponse<ConversationVO> get(@PathVariable Long id) {
        return ApiResponse.ok(conversationService.get(id));
    }

    @Operation(summary = "会话历史消息")
    @GetMapping("/{id}/messages")
    public ApiResponse<List<MessageVO>> messages(@PathVariable Long id) {
        return ApiResponse.ok(conversationService.messages(id));
    }

    @Operation(summary = "重命名会话")
    @PatchMapping("/{id}")
    public ApiResponse<ConversationVO> rename(@PathVariable Long id,
                                              @Valid @RequestBody RenameConversationRequest request) {
        return ApiResponse.ok(conversationService.rename(id, request.getTitle()));
    }

    @Operation(summary = "删除会话")
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        conversationService.delete(id);
        return ApiResponse.ok(null);
    }
}
