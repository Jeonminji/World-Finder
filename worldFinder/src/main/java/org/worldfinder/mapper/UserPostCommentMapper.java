package org.worldfinder.mapper;

import java.util.List;

import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.NestedCVO;

public interface UserPostCommentMapper {
	public List<CommentVO> getAllCommentList(long n_idx);
	public List<NestedCVO> getAllNestedComList(long c_idx);
	
	public int getTotalComment(long up_idx);
	public int getTotalNestedCom(long up_idx);
	
	public int insertComment(CommentVO vo);
	public int insertNestedCom(NestedCVO vo);
	
	public CommentVO getComment(long c_idx);
	public NestedCVO getNestedCom(long nc_idx);
	
	public int updateComment(CommentVO vo);
	public int updateNestedCom(NestedCVO vo);
	
	public int deleteComment(long c_idx);
	public int deleteNestedCom(long nc_idx);
	
	
	// 댓글 좋아요 --------------
	public void likeComment(LikeVO vo);
	public void dislikeComment(LikeVO vo);
	public int getCommentLikeCount(long c_idx);
	public boolean checkCommentLike(LikeVO vo);
	
}
