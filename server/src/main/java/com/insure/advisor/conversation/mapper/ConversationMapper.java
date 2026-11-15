package com.insure.advisor.conversation.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insure.advisor.conversation.entity.Conversation;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ConversationMapper extends BaseMapper<Conversation> {
}
