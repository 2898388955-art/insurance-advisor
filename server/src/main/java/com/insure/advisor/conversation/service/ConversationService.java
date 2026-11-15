package com.insure.advisor.conversation.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insure.advisor.common.exception.BizException;
import com.insure.advisor.common.web.PageResult;
import com.insure.advisor.conversation.dto.ConversationVO;
import com.insure.advisor.conversation.dto.MessageVO;
import com.insure.advisor.conversation.entity.Conversation;
import com.insure.advisor.conversation.entity.Message;
import com.insure.advisor.conversation.mapper.ConversationCleanupMapper;
import com.insure.advisor.conversation.mapper.ConversationMapper;
import com.insure.advisor.conversation.mapper.MessageMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ConversationService {

    private final ConversationMapper conversationMapper;
    private final MessageMapper messageMapper;
    private final ConversationCleanupMapper cleanupMapper;

    public ConversationVO create(String title) {
        Conversation c = new Conversation();
        c.setUserId(0L);
        c.setTitle(StringUtils.hasText(title) ? title.trim() : "新对话");
        conversationMapper.insert(c);
        return toVO(conversationMapper.selectById(c.getId()));
    }

    public PageResult<ConversationVO> list(int page, int size) {
        Page<Conversation> p = conversationMapper.selectPage(
                new Page<>(Math.max(1, page), Math.min(50, Math.max(1, size))),
                new LambdaQueryWrapper<Conversation>().orderByDesc(Conversation::getUpdatedAt));
        List<ConversationVO> records = p.getRecords().stream().map(this::toVO).toList();
        return PageResult.of(records, p.getTotal(), p.getCurrent(), p.getSize());
    }

    public List<MessageVO> messages(Long conversationId) {
        get(conversationId); // 不存在直接 404
        return messageMapper.selectList(new LambdaQueryWrapper<Message>()
                        .eq(Message::getConversationId, conversationId)
                        .orderByAsc(Message::getId))
                .stream().map(m -> {
                    MessageVO vo = new MessageVO();
                    vo.setId(m.getId());
                    vo.setRole(m.getRole());
                    vo.setContent(m.getContent());
                    vo.setIntent(m.getIntent());
                    vo.setCitationsJson(m.getCitationsJson());
                    vo.setToolsJson(m.getToolsJson());
                    vo.setElapsedMs(m.getElapsedMs());
                    vo.setCreatedAt(m.getCreatedAt());
                    return vo;
                }).toList();
    }

    public ConversationVO rename(Long id, String title) {
        if (!StringUtils.hasText(title)) {
            throw new BizException("标题不能为空");
        }
        Conversation c = conversationMapper.selectById(id);
        if (c == null) {
            throw new BizException(4040, "会话不存在");
        }
        c.setTitle(title.trim());
        conversationMapper.updateById(c);
        return toVO(c);
    }

    /**
     * 删除会话：消息、记忆快照、摘要一并清理，避免留下孤儿数据。
     */
    @Transactional
    public void delete(Long id) {
        if (conversationMapper.selectById(id) == null) {
            throw new BizException(4040, "会话不存在");
        }
        messageMapper.delete(new LambdaQueryWrapper<Message>().eq(Message::getConversationId, id));
        cleanupMapper.deleteCheckpoints(id);
        cleanupMapper.deleteSummaries(id);
        conversationMapper.deleteById(id);
    }

    public ConversationVO get(Long id) {
        Conversation c = conversationMapper.selectById(id);
        if (c == null) {
            throw new BizException(4040, "会话不存在");
        }
        return toVO(c);
    }

    public void touch(Long id, String intent) {
        Conversation c = conversationMapper.selectById(id);
        if (c == null) {
            return;
        }
        c.setLastIntent(intent);
        conversationMapper.updateById(c);
    }

    private ConversationVO toVO(Conversation c) {
        ConversationVO vo = new ConversationVO();
        vo.setId(c.getId());
        vo.setTitle(c.getTitle());
        vo.setLastIntent(c.getLastIntent());
        vo.setCreatedAt(c.getCreatedAt());
        vo.setUpdatedAt(c.getUpdatedAt());
        return vo;
    }
}
