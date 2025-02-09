package org.worldfinder.service;

import java.util.List;

import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.NestedCVO;

public interface UserPostCommentService {
	public List<CommentVO> getCommentList(long n_idx);
	public List<NestedCVO> getNestedComList(long c_idx);
	
	public int registerComment(CommentVO vo);
	public int registerNestedCom(NestedCVO vo);
	
	public CommentVO viewComment(long c_idx);
	public NestedCVO viewNestedCom(long nc_idx);
	
	public int modifyComment(CommentVO vo);
	public int modifyNestedCom(NestedCVO vo);
	
	public int removeComment(long c_idx);
	public int removeNestedCom(long nc_idx);
	
	public int getTotalComment(long up_idx);
	public int getTotalNestedCom(long up_idx);
	
	// 댓글 좋아요 -------------------
	public void likeComment(LikeVO vo);
	public void dislikeComment(LikeVO vo);
	public int getCommentLikeCount(long c_idx);
	public boolean checkCommentLikeStatus(long c_idx, String u_writer);
}
