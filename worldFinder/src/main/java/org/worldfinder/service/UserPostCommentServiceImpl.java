package org.worldfinder.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.NestedCVO;
import org.worldfinder.mapper.UserPostCommentMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class UserPostCommentServiceImpl implements UserPostCommentService {
	@Autowired
	private UserPostCommentMapper mapper;
	
	
	// 댓글 -----------------------
	@Override
	public List<CommentVO> getCommentList(long n_idx) {
		log.info("comment list..");
		return mapper.getAllCommentList(n_idx);
	}
	
	@Override
	public int registerComment(CommentVO vo) {
		log.info("comment register..");
		return mapper.insertComment(vo);
	}
	
	@Override
	public CommentVO viewComment(long c_idx) {
		log.info("comment view..");
		return mapper.getComment(c_idx);
	}
	
	@Override
	public int modifyComment(CommentVO vo) {
		log.info("comment modify..");
		return mapper.updateComment(vo);
	}
	
	@Override
	public int removeComment(long c_idx) {
		log.info("comment remove..");
		return mapper.deleteComment(c_idx);
	}
	
	@Override
	public int getTotalComment(long up_idx) {
		return mapper.getTotalComment(up_idx);
	}
	
	
	// 좋아요 --------------------------
	@Override
	public void likeComment(LikeVO vo) {
		log.info("likeComment.." + vo);
		
		if(!mapper.checkCommentLike(vo)) {
			mapper.likeComment(vo);
		} else {
			mapper.dislikeComment(vo);
		}
	}
	
	@Override
	public void dislikeComment(LikeVO vo) {
		log.info("dislikeComment.." + vo);
		System.out.println("dislikeCommnet 실행");
		
		if(mapper.checkCommentLike(vo)) {
			mapper.dislikeComment(vo);
		}
	}
	
	@Override
	public boolean checkCommentLikeStatus(long c_idx, String u_writer) {
		LikeVO vo = new LikeVO(c_idx, u_writer);
		return mapper.checkCommentLike(vo);
	}
	
	@Override
	public int getCommentLikeCount(long c_idx) {
		log.info("getCommentLikeCount.." + c_idx);
		return mapper.getCommentLikeCount(c_idx);
	}

	// 대댓글 -----------------------
	@Override
	public List<NestedCVO> getNestedComList(long c_idx) {
		log.info("nested comment list..");
		return mapper.getAllNestedComList(c_idx);
	}
	
	@Override
	public int registerNestedCom(NestedCVO vo) {
		log.info("nested comment register..");
		return mapper.insertNestedCom(vo);
	}
	
	@Override
	public NestedCVO viewNestedCom(long nc_idx) {
		log.info("nested comment view..");
		return mapper.getNestedCom(nc_idx);
	}
	
	@Override
	public int modifyNestedCom(NestedCVO vo) {
		log.info("nested comment modify...");
		return mapper.updateNestedCom(vo);
	}
	
	@Override
	public int removeNestedCom(long nc_idx) {
		log.info("nested comment remove..");
		return mapper.deleteNestedCom(nc_idx);
	}
	
	@Override
	public int getTotalNestedCom(long up_idx) {
		return mapper.getTotalNestedCom(up_idx);
	}
}
