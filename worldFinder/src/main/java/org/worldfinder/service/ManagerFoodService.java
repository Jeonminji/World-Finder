package org.worldfinder.service;

import java.util.List;

import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.FoodFilterVO;
import org.worldfinder.domain.FoodPostVO;
import org.worldfinder.domain.PageDTO;


public interface ManagerFoodService {

	public List<FoodPostVO> getFoodList(FoodFilterVO ffvo);	//맛집 전체 리스트 가져오기
	public void registerFood(FoodPostVO fvo);
	public void updateFood(FoodPostVO fvo);
	public void removeFood(int fp_Idx);
	public int countFoodList(FoodFilterVO ffvo);	//맛집 개시물 전체 개수 가져오기
	public List<FoodPostVO> getListWithPaging(Criteria cri);
	
	public void foodInsert(FoodPostVO fvo);	//맛집 삽입
	
	public FoodPostVO getFoodPost(int fpIdx);	//맛집 정보 가져오기
}
