package org.worldfinder.service;


import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.worldfinder.domain.CountryClassVO;
import org.worldfinder.domain.HotelDetailVO;
import org.worldfinder.domain.ItemFilterConVO;
import org.worldfinder.domain.ItemFilterVO;
import org.worldfinder.domain.ItemVO;
import org.worldfinder.domain.UserOrderVO;

public interface ManagerItemService {
	
	//public void registerItem(ItemVO ivo);
	//public void updateItem(ItemVO ivo);
	public void removeItem(int item_Idx);

	
	//날짜 선택 안했을 때 리스트 검색
	public List<ItemVO> getListwithFilter(ItemFilterVO itemFiltervo);
	public int countApplyFilter(ItemFilterVO itemFiltervo);
	
	//날짜 선택 했을 때 리스트 검색
	public List<ItemVO> getListwithFilterDate(ItemFilterVO itemFiltervo) throws ParseException;
	public int getCountwithFilterDate(ItemFilterVO itemFiltervo) throws ParseException;
	
	//아이템 세부정보 가져오기
	public ItemVO getItemDetail(ItemFilterConVO icvo) throws ParseException;
	public List<HotelDetailVO> getHotelDetail(ItemFilterConVO icvo);
	
	public Map<String, Object> getNoDate(int hotelIdx) throws ParseException;
	public Map<String, Object> getNoDateSpot(int itemIdx, int people, String startDay) throws ParseException;
	
	//아이템 추가하기
	//public int semiItemInsert();
	public void itemInsertSet();
	public Map<String, Object> hotelRoomInsert(HotelDetailVO hdvo);
	public Map<String, Object> hotelRoomDelete(int hotelIdx, int item_idx);
	public Map<String, Object> allRoomDelete (int item_idx);
	public int realItemInsert(ItemVO ivo);
	
	//아이템 수정하기
	public ItemVO getItemWithIdx(int itemIdx);	//idx로 아이템 정보 가져오기
	public HotelDetailVO getOnehotelDetail(int item_idx, int hotel_idx);	//호텔 방 하나 정보 가져오기
	public void updateRoom(HotelDetailVO hdvo);
	public void oneItemUpdate(ItemVO ivo);
	public List<HotelDetailVO> getAllHotelRoom(int item_idx);
	
	//나라페이지 => 상품페이지
	public CountryClassVO countryCategory(String country);
	
	// 카카오페이 결제
	public int payInsert(UserOrderVO vo);
	
}
