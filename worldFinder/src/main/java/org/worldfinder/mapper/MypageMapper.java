package org.worldfinder.mapper;

import java.util.List;

import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.MyPageCommentsVO;
import org.worldfinder.domain.MyPagePayVO;
import org.worldfinder.domain.MyPageRepliesVO;
import org.worldfinder.domain.NestedCVO;
import org.worldfinder.domain.ScrapVO;
import org.worldfinder.domain.UserPostVO;
import org.worldfinder.domain.UserVO;

public interface MypageMapper {
	
	public List<UserVO> getUserInfo(String currentUser);
	
	public List<UserPostVO> getUserPost(String currentUser);
	
	public List<MyPageCommentsVO> getUserComment(String currentUser);
	public List<MyPageRepliesVO> getUserReply(String currentUser);
	
	public List<UserPostVO> getUserScrap(String currentUser);
	
	public List<MyPagePayVO> getUserPay(String currentUser);
	//public List<Pay>
}
