package com.insure.advisor.conversation.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insure.advisor.conversation.entity.Message;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MessageMapper extends BaseMapper<Message> {
}
