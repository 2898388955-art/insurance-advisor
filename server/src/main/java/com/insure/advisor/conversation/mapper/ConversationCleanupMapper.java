package com.insure.advisor.conversation.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 会话删除时清理 AI 侧数据。
 * 这些表由 Python 服务写入，Java 没有对应实体，用显式 SQL 清理。
 */
@Mapper
public interface ConversationCleanupMapper {

    @Delete("DELETE FROM agent_checkpoint WHERE conversation_id = #{id}")
    int deleteCheckpoints(@Param("id") Long id);

    @Delete("DELETE FROM conversation_summary WHERE conversation_id = #{id}")
    int deleteSummaries(@Param("id") Long id);
}
