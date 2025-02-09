package org.worldfinder.service;

import java.util.List;

import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.ReportVO;
import org.worldfinder.domain.ScrapVO;
import org.worldfinder.domain.UserPostVO;

public interface UserPostService {
   public List<UserPostVO> getList(Criteria cri, String country);
   public int getTotal();
   public void postRegister(UserPostVO vo);
   public UserPostVO postView(long up_idx);
   public boolean postModify(UserPostVO vo);
   public boolean postRemove(long up_idx);
   public void modifyHit(UserPostVO vo);
   
   // 좋아요
   public void modifyLike(UserPostVO vo);
   public void like(LikeVO vo);		// 좋아요 + 1
   public void dislike(LikeVO vo);	// 좋아요 - 1
   public int getLikeCount(long up_idx);
   public boolean checkLikeStatus(long up_idx, String u_writer);
   
   // 스크랩
   public void scrap(ScrapVO vo);
   public void scrapCancle(ScrapVO vo);
   public boolean checkScrapStatus(long up_idx, String u_writer);
   
   // 신고
   public int postReport(ReportVO vo);
}