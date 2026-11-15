package com.insure.advisor.conversation.service;

import com.insure.advisor.common.exception.BizException;
import com.insure.advisor.conversation.dto.ConversationVO;
import com.insure.advisor.conversation.dto.MessageVO;
import com.insure.advisor.conversation.entity.Conversation;
import com.insure.advisor.conversation.entity.Message;
import com.insure.advisor.conversation.mapper.ConversationCleanupMapper;
import com.insure.advisor.conversation.mapper.ConversationMapper;
import com.insure.advisor.conversation.mapper.MessageMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ConversationServiceTest {

    @Mock
    private ConversationMapper conversationMapper;

    @Mock
    private MessageMapper messageMapper;

    @Mock
    private ConversationCleanupMapper cleanupMapper;

    @InjectMocks
    private ConversationService conversationService;

    private Conversation conversation(long id, String title) {
        Conversation c = new Conversation();
        c.setId(id);
        c.setTitle(title);
        c.setUserId(0L);
        c.setCreatedAt(LocalDateTime.now());
        c.setUpdatedAt(LocalDateTime.now());
        return c;
    }

    @Test
    void renameUpdatesTitle() {
        Conversation c = conversation(1, "旧标题");
        when(conversationMapper.selectById(1L)).thenReturn(c);

        ConversationVO vo = conversationService.rename(1L, "  新标题  ");

        assertThat(vo.getTitle()).isEqualTo("新标题");
        verify(conversationMapper).updateById(c);
    }

    @Test
    void renameRejectsBlankTitle() {
        assertThatThrownBy(() -> conversationService.rename(1L, "  "))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("标题不能为空");
    }

    @Test
    void deleteCascadesMessagesAndMemory() {
        when(conversationMapper.selectById(1L)).thenReturn(conversation(1, "会话"));

        conversationService.delete(1L);

        verify(messageMapper).delete(any());
        verify(cleanupMapper).deleteCheckpoints(1L);
        verify(cleanupMapper).deleteSummaries(1L);
        verify(conversationMapper).deleteById(1L);
    }

    @Test
    void deleteMissingConversationThrows() {
        when(conversationMapper.selectById(2L)).thenReturn(null);

        assertThatThrownBy(() -> conversationService.delete(2L))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("会话不存在");
    }

    @Test
    void messagesMapToVo() {
        when(conversationMapper.selectById(1L)).thenReturn(conversation(1, "会话"));
        Message m = new Message();
        m.setId(10L);
        m.setRole("user");
        m.setContent("等待期是多久");
        m.setIntent("rag");
        m.setCitationsJson("[]");
        when(messageMapper.selectList(any())).thenReturn(List.of(m));

        List<MessageVO> messages = conversationService.messages(1L);

        assertThat(messages).hasSize(1);
        assertThat(messages.get(0).getContent()).isEqualTo("等待期是多久");
        assertThat(messages.get(0).getCitationsJson()).isEqualTo("[]");
    }
}
