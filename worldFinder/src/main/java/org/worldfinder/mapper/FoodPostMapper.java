package org.worldfinder.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.FoodFilterVO;
import org.worldfinder.domain.FoodPostVO;
import org.worldfinder.domain.PageDTO;


public interface FoodPostMapper {
	
	
	public void insertFood(FoodPostVO fvo);
	public List<FoodPostVO> getFoodList(FoodFilterVO ffvo);	//맛집 전체 개시글 가져오기
	public void updateFood(FoodPostVO fvo);
	public void removeFood(int fp_Idx);
	public int countFoodList(FoodFilterVO ffvo);	//맛집 게시글 전체 개수 가져오기
	public List<FoodPostVO> getListwithPaging(Criteria cri);
	
	public FoodPostVO getFoodPost(int fpIdx);

}
