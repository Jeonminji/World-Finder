package org.worldfinder.mapper;

import java.util.List;
import java.util.Map;

import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.ReportVO;
import org.worldfinder.domain.ScrapVO;
import org.worldfinder.domain.UserPostVO;

public interface UserPostMapper {
   public List<UserPostVO> getAllList(Map<String, Object> map);
   public int getTotalCount();
   public void postInsert(UserPostVO vo);
   public UserPostVO postGet(long up_idx);
   public int postUpdate(UserPostVO vo);
   public int postDelete(long up_idx);
   public void updateHit(UserPostVO vo);
   
   
   // 좋아요
   public void updateLike(UserPostVO vo);
   public void like(LikeVO vo);		// 좋아요 + 1
   public void dislike(LikeVO vo);	// 좋아요 - 1
   public int getLikeCount(long up_idx);
   boolean checkLike(LikeVO vo);

   
   // 스크랩
   public void scrap(ScrapVO vo);
   public void scrapCancle(ScrapVO vo);
   boolean checkScrap(ScrapVO vo);
   
   
   // 신고
   public int postReport(ReportVO vo);
}