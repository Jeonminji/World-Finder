package org.worldfinder.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.MyPageCommentsVO;
import org.worldfinder.domain.MyPagePayVO;
import org.worldfinder.domain.MyPageRepliesVO;
import org.worldfinder.domain.NestedCVO;
import org.worldfinder.domain.ScrapVO;
import org.worldfinder.domain.UserPostVO;
import org.worldfinder.domain.UserVO;
import org.worldfinder.mapper.MypageMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class MypageServiceImpl implements MypageService{
	
	@Autowired
	private MypageMapper mapper;
	
	@Override
	public List<UserVO> getUserInfo(String currentUser) {
		log.info("userInfo list..");
		return mapper.getUserInfo(currentUser);
	}
	
	@Override
	public List<UserPostVO> getUserPost(String currentUser) {
		log.info("userPost list..");
		return mapper.getUserPost(currentUser);
	}
	
	@Override
	public List<MyPageCommentsVO> getUserComment(String currentUser) {
		log.info("userComment list..");
		return mapper.getUserComment(currentUser);
	}
	
	@Override
	public List<MyPageRepliesVO> getUserReply(String currentUser) {
		log.info("userReply list..");
		return mapper.getUserReply(currentUser);
	}
	
	@Override
	public List<UserPostVO> getUserScrap(String currentUser) {
		log.info("userScrap list..");
		return mapper.getUserScrap(currentUser);
	}
	
	@Override
	public List<MyPagePayVO> getUserPay(String currentUser) {
		log.info("userPay list..");
		return mapper.getUserPay(currentUser);
	}
}
