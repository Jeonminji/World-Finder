package org.worldfinder.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.worldfinder.domain.CountryClassVO;
import org.worldfinder.domain.HotelDetailVO;
import org.worldfinder.domain.ItemFilterConVO;
import org.worldfinder.domain.ItemFilterVO;
import org.worldfinder.domain.ItemVO;
import org.worldfinder.domain.UserOrderVO;


public interface ItemMapper {

	//public void insertItem(ItemVO ivo);
	public void updateItem(ItemVO ivo);
	
	
	public int removeHotelDetail(int itemIdx);	//호텔 객실 삭제 (외래키 때문에 먼저 삭제해야 함)
	public int removeItem(int itemIdx);		//아이템 삭제

	public List<ItemVO> getListwithFilter(ItemFilterVO itemFiltervo);
	public int countApplyFilter(ItemFilterVO itemFiltervo);
	
	public List<UserOrderVO> getUserOrder(ItemFilterVO itemFiltervo);
	
	public int countWithSpot(ItemFilterVO itemFiltervo);
	public int countWithHotel(ItemFilterVO itemFiltervo);
	
	public List<ItemVO> listWithNull(ItemFilterVO itemFiltervo);
	public List<ItemVO> listWithSpot(ItemFilterVO itemFiltervo);
	public List<ItemVO> listWithHotel(ItemFilterVO itemFiltervo);
	
	public ItemVO getItemDetail(int idx);
	public List<HotelDetailVO> getAllHotelDetail(int itemIdx);	//모든 객실정보 가져오기
	public List<HotelDetailVO> getHotelDetail(ItemFilterConVO icvo);	//선택 가능한 객실 정보만 가져오기
	
	public List<UserOrderVO> getNoDate(int hotelIdx);
	public List<String> dupliDate(int hotelIdx);
	
	public List<String> getNoDateSpot(@Param("itemIdx") int itemIdx, @Param("people") int people);
	public List<String> getNoDateSpotRep(@Param("itemIdx") int itemIdx, @Param("people") int people);
	public int getFullPeople(int itemIdx);
	public String reservePeople(@Param("itemIdx") int itemIdx, @Param("startDay") String startDay);
	
	public int isZeroIdx();	//itemIdx = 0인 컬럼 있는지 확인
	public void deleteZero();	//itemIdx가 0인 hotelRoom 삭제
	public void semiItemInsert();	//등록하기 눌렀을때 더미 itemIdx 추가
	public int semiItemIdx();		//추가된 itemIdx 가져오기
	public int hotelRoomUnique(HotelDetailVO hdvo);	//객실 번호 중복 확인
	public int hotelRoomInsert(HotelDetailVO hdvo);	//숙소 객실 추가
	public List<HotelDetailVO> hotelRoomGet(int itemIdx);	//숙소 객실 리스트 가져오기
	public int hotelRoomDelete(int hotelIdx);	//숙소 객실 지우기
	public int allRoomDelete(int itemIdx); 	//호텔 전체 객실 지우기
	public int realItemInsert(ItemVO ivo);	//아이템 추가
	public int itemOrderDelete(int item_idx);	//아이템 지울때 유저 구매내역도 같이 지우기
	public int hotelOrderDelete(int hotel_idx);	//객실 지울때 유저 구매내역도 같이 지우기
	public int maxPeople(int item_idx);	//호텔 삽입시 들어갈 최대 인원수 구하기
	public int realIdxUpdate();	//itemIdx = 0에다 삽입한 폼을 nextval에 insert
	
	public HotelDetailVO getOnehotelDetail(@Param("item_idx") int item_idx, @Param("hotel_idx") int hotel_idx);	//호텔 방 하나 정보 가져오기
	
	// 나라불러오기
	public CountryClassVO countryCategory(String country);
	
	public void updateRoom(HotelDetailVO hdvo);	//호텔방 하나 업데이트
	public void updatePeople(@Param("item_idx") int item_idx, @Param("people") int people);	//호텔방 업데이트시 호텔 최대 인원수 업데이트
	public void oneItemUpdate(ItemVO ivo);	//아이템 업데이트

	// 결제
	public int payInsert(UserOrderVO vo);
	
}
