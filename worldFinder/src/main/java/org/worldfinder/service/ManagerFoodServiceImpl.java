package org.worldfinder.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.FoodFilterVO;
import org.worldfinder.domain.FoodPostVO;
import org.worldfinder.domain.PageDTO;
import org.worldfinder.mapper.FoodPostMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ManagerFoodServiceImpl implements ManagerFoodService{

	@Autowired
	private FoodPostMapper mapper;
	
	@Override
	public int countFoodList(FoodFilterVO ffvo) {
		log.info("foodservice countFoodList...");

		return mapper.countFoodList(ffvo);
	}
	
	@Override
	public List<FoodPostVO> getFoodList(FoodFilterVO ffvo) {
		log.info("foodservice getFoodList...");
		return mapper.getFoodList(ffvo);
	}
	
	@Override
	public List<FoodPostVO> getListWithPaging(Criteria cri) {
		log.info("foodservice getListWithPaging...");
		return mapper.getListwithPaging(cri);
	}
	
	@Override
	public void registerFood(FoodPostVO fvo) {
		log.info("foodservice registerFood...");
		mapper.insertFood(fvo);
	}
	
	@Override
	public void removeFood(int fp_Idx) {
		log.info("foodservice removeFood...");
		mapper.removeFood(fp_Idx);
	}
	
	@Override
	public void updateFood(FoodPostVO fvo) {
		log.info("foodservice updateFood...");
		mapper.updateFood(fvo);
	}
	
	@Override
	public void foodInsert(FoodPostVO fvo) {
		mapper.insertFood(fvo);
	}
	
	@Override
	public FoodPostVO getFoodPost(int fpIdx) {
		return mapper.getFoodPost(fpIdx);
	}

}
