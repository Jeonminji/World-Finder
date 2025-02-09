package org.worldfinder.service;


import java.nio.file.spi.FileSystemProvider;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.worldfinder.domain.CountryClassVO;
import org.worldfinder.domain.HotelDetailVO;
import org.worldfinder.domain.ItemFilterConVO;
import org.worldfinder.domain.ItemFilterVO;
import org.worldfinder.domain.ItemVO;
import org.worldfinder.domain.UserOrderVO;
import org.worldfinder.mapper.ItemMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ManagerItemServiceImpl implements ManagerItemService{
	
	@Autowired
	private ItemMapper mapper;
	
	
//	@Override
//	public void registerItem(ItemVO ivo) {
//		log.info("service registeritem...");
//		mapper.insertItem(ivo);
//	}
	
	//@Transactional
	@Override
	public void removeItem(int item_Idx) {
		log.info("service removeitem...");
		
		mapper.itemOrderDelete(item_Idx);
		mapper.removeHotelDetail(item_Idx);		
		mapper.removeItem(item_Idx);
	}
	
//	@Override
//	public void updateItem(ItemVO ivo) {
//		log.info("service updateItem...");
//		mapper.updateItem(ivo);
//	}
	
//	@Override
//	public List<ItemVO> getListWithPaging(Criteria cri) {
//		log.info("service getListWithPaging...");
//		return mapper.getListwithPaging(cri);
//	}
	
	@Override
	public List<ItemVO> getListwithFilter(ItemFilterVO itemFiltervo) {
		log.info("service getListwithFilter...");
		System.out.println("service getListwithFilter...");
		
	
		return mapper.getListwithFilter(itemFiltervo);
	}
	
	@Override
	public int countApplyFilter(ItemFilterVO itemFiltervo) {
		log.info("service countApplyFilter...");
		return mapper.countApplyFilter(itemFiltervo);
	}
	
	//날짜 검색 기능 추가한 getList
	@Override
	public List<ItemVO> getListwithFilterDate(ItemFilterVO itemFiltervo) throws ParseException {  
		
		
		log.info("service getListwithFilterDate...");

		itemFiltervo = setFilter(itemFiltervo);   
		
		//날짜를 선택하지 않았을 때
		if(itemFiltervo.getStartDay() == null && 
				itemFiltervo.getEndDay() == null) {
			return mapper.getListwithFilter(itemFiltervo);
		}
		else {	//날짜 하나 이상을 선택하고
			
			//카테고리를 선택하지 않았을 때
			if(itemFiltervo.getItem_Category() == null || itemFiltervo.getItem_Category().equals("")) {
				return mapper.listWithNull(itemFiltervo);
			}
			//관광지 카테고리를 선택했을 때
			else if(itemFiltervo.getItem_Category().equals("spot")) {
				return mapper.listWithSpot(itemFiltervo);
			}
			//숙소 카테고리를 선택했을 때
			else {
				return mapper.listWithHotel(itemFiltervo);
			}
			
		}

	}
	
	//날짜 검색 기능 추가한 getCount (전체 게시글 수 불러오기 위함)
	@Override
	public int getCountwithFilterDate(ItemFilterVO itemFiltervo) throws ParseException {  
		
		
		log.info("service getCountwithFilterDate...");
				
		itemFiltervo = setFilter(itemFiltervo);
		
		//날짜를 선택하지 않았을 때
		if(itemFiltervo.getStartDay() == null && 
				itemFiltervo.getEndDay() == null) {
			
			return mapper.countApplyFilter(itemFiltervo);
		}
		else {	//날짜 하나 이상을 선택하고

						
			//카테고리를 선택하지 않았을 때
			if(itemFiltervo.getItem_Category() == null || itemFiltervo.getItem_Category().equals("")) {
				return (mapper.countWithSpot(itemFiltervo) + mapper.countWithHotel(itemFiltervo));
			}
			//관광지 카테고리를 선택했을 때
			else if(itemFiltervo.getItem_Category().equals("spot")) {
				return mapper.countWithSpot(itemFiltervo);
			}
			//숙소 카테고리를 선택했을 때
			else {
				return mapper.countWithHotel(itemFiltervo);
			}
			
		}

	}
	
	//날짜에 null값 들어왔을 때 set
	private ItemFilterVO setFilter(ItemFilterVO itemFiltervo) throws ParseException {
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd"); 
		
		//같은 날 선택시 호텔 검색 결과는 안나옴
		if(	itemFiltervo.getStartDay() != null &&
				itemFiltervo.getEndDay() != null &&
				itemFiltervo.getStartDay().equals(itemFiltervo.getEndDay()) &&
				(itemFiltervo.getItem_Category() == null || itemFiltervo.getItem_Category().equals(""))) {
			itemFiltervo.setItem_Category("spot");
		}
		
		if(itemFiltervo.getStartDay() != null &&
				itemFiltervo.getEndDay() == null) {
			
			itemFiltervo.setStartDayHotel(itemFiltervo.getStartDay());
			itemFiltervo.setStartDaySpot(itemFiltervo.getStartDay());
			
			String hotelEndDay = fmt.format(itemFiltervo.getStartDay());
			hotelEndDay = AddDate(hotelEndDay, 0, 0, 1);
			itemFiltervo.setEndDayHotel(Date.valueOf(hotelEndDay));
			
			String spotEndDay = fmt.format(itemFiltervo.getStartDay());
			spotEndDay = AddDate(spotEndDay, 0, 1, 0);
			itemFiltervo.setEndDaySpot(Date.valueOf(spotEndDay));	
		}
		else if(itemFiltervo.getEndDay() != null &&
				itemFiltervo.getStartDay() == null) {
			
			itemFiltervo.setEndDayHotel(itemFiltervo.getEndDay());
			itemFiltervo.setEndDaySpot(itemFiltervo.getEndDay());
			
			String hotelStartDay = fmt.format(itemFiltervo.getEndDay());
			hotelStartDay = AddDate(hotelStartDay, 0, 0, -1);
			itemFiltervo.setStartDayHotel(Date.valueOf(hotelStartDay));
			
			String spotStartDay = fmt.format(itemFiltervo.getEndDay());
			spotStartDay = AddDate(spotStartDay, 0, 0, -1);
			itemFiltervo.setStartDaySpot(Date.valueOf(spotStartDay));
			
		}
		else {
			itemFiltervo.setStartDayHotel(itemFiltervo.getStartDay());
			itemFiltervo.setStartDaySpot(itemFiltervo.getStartDay());
			
			itemFiltervo.setEndDayHotel(itemFiltervo.getEndDay());
			itemFiltervo.setEndDaySpot(itemFiltervo.getEndDay());
		}
		
		
		return itemFiltervo;
	}

	//날짜에 하루 더하기
	private String AddDate(String strDate, int year, int month, int day) throws ParseException {
        SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd");
        
		Calendar cal = Calendar.getInstance();
        
		java.util.Date dt = dtFormat.parse(strDate);
        
		cal.setTime(dt);
        
		cal.add(Calendar.YEAR,  year);
		cal.add(Calendar.MONTH, month);
		cal.add(Calendar.DATE,  day);
        
		return dtFormat.format(cal.getTime());
	}
	
	@Override
	public List<HotelDetailVO> getHotelDetail(ItemFilterConVO icvo) {
		return mapper.getHotelDetail(icvo);
	}
	
	@Override
	public ItemVO getItemDetail(ItemFilterConVO icvo) throws ParseException {
		ItemVO ivo = mapper.getItemDetail(icvo.getIdx());	
		
		//날짜 선택 셋팅
		icvo = setIcvoDate(icvo);
				
		ivo.setHotel_detail_list(mapper.getHotelDetail(icvo));		
		return ivo;
	}
	
	//itemIdx로만 아이템 세부정보 가져오기
	@Override
	public ItemVO getItemWithIdx(int itemIdx) {
		//아이템 기본정보 가져오기
		ItemVO ivo = mapper.getItemDetail(itemIdx);
		
		//숙소 객실 정보도 가져오기
		ivo.setHotel_detail_list(mapper.getAllHotelDetail(itemIdx));
		
		return ivo;
	}
	
	private ItemFilterConVO setIcvoDate(ItemFilterConVO icvo) throws ParseException {
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		String startDay = fmt.format(icvo.getStartDay());
		String endDay = fmt.format(icvo.getEndDay());
		
		
		if(startDay.equals("1900-01-01") && !endDay.equals("1900-01-01")) {
			System.out.println("앞날짜 없음");
			startDay = fmt.format(icvo.getEndDay());
			icvo.setStartDay(Date.valueOf(AddDate(startDay, 0, 0, -1)));
		}
		else if(endDay.equals("1900-01-01") && !startDay.equals("1900-01-01")){
			System.out.println("뒷날짜 없음");
			endDay = fmt.format(icvo.getStartDay());
			icvo.setEndDay(Date.valueOf(AddDate(endDay, 0, 0, 1)));
		}
		
		return icvo;
	}
	
	
	
	@Override
	public Map<String, Object> getNoDate(int hotelIdx) throws ParseException {
		
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		List<UserOrderVO> list = mapper.getNoDate(hotelIdx);
		
		List<String> resultF = new ArrayList<String>();
		List<String> resultT = new ArrayList<String>();
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		String inStr = "", outStr = "";

		for(UserOrderVO uvo : list) {
			inStr = fmt.format(uvo.getCheck_In_Date());
			outStr = fmt.format(uvo.getCheck_Out_Date());
			
			resultT.add(deleteZero(inStr));
			resultT.add(deleteZero(outStr));
			
			while(true) {

				resultF.add(deleteZero(inStr));
				inStr = AddDate(inStr, 0, 0, 1);
				
				
				if(dateToInt(inStr) > dateToInt(outStr)) {
					break;
				}	
			}

		}
		
		List<String> repliDate = mapper.dupliDate(hotelIdx);
		
		for(String date : repliDate) {
			resultT.remove(deleteZero(date));
			resultT.remove(deleteZero(date));
		}
		
		
		result.put("resultT", resultT);
		result.put("resultF", resultF);
		
		System.out.println("service result : " + result);
		
		return result;
	}
	
	
	@Override
	public Map<String, Object> getNoDateSpot(int itemIdx, int people, String startDay) throws ParseException {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		List<String> resultT = new ArrayList<String>();
		List<String> resultF = new ArrayList<String>();
		
		for(String date : mapper.getNoDateSpot(itemIdx, people)) {
			resultT.add(deleteZero(date));
		}
		for(String date : mapper.getNoDateSpotRep(itemIdx, people)) {
			resultF.add(deleteZero(date));
		}
		
		result.put("resultT", resultT);
		result.put("resultF", resultF);
		result.put("fullPeople", mapper.getFullPeople(itemIdx));
		
		String reservePeople = mapper.reservePeople(itemIdx, startDay);
		
		if(reservePeople != null) {
			result.put("reservePeople", Integer.parseInt(reservePeople));
		}
		else {
			result.put("reservePeople", 0);
		}
		return result;
	}
	

//	@Override
//	public int semiItemInsert() {
//		mapper.semiItemInsert();
//		
//		return mapper.semiItemIdx();
//	}
	
	@Override
	public void itemInsertSet() {
		if(mapper.isZeroIdx() > 0) {
			mapper.deleteZero();
		}
		else {
			mapper.semiItemInsert();
		}
		
	}
	
	@Override
	public Map<String, Object> hotelRoomInsert(HotelDetailVO hdvo) {
		
		Map<String , Object> result = new HashMap<String, Object>();
		
		if(mapper.hotelRoomUnique(hdvo) != 0) {
			result.put("eCode", 1);
			result.put("list", null);
			return result;
		}
		
		if(mapper.hotelRoomInsert(hdvo) > 0) {
			result.put("eCode", 0);
			result.put("list", mapper.hotelRoomGet(hdvo.getItem_idx()));
			return result;
		}
		else {
			result.put("eCode", 1);
			result.put("list", null);
			return result;
		}
	}
	
	//@Transactional
	@Override
	public Map<String, Object> hotelRoomDelete(int hotelIdx, int item_idx) {
		log.info("service hotelRoomDelete...");
		
		Map<String, Object> result = new HashMap<String, Object>();
		mapper.hotelOrderDelete(hotelIdx);
		if(mapper.hotelRoomDelete(hotelIdx) > 0) {
			List<HotelDetailVO> list = mapper.hotelRoomGet(item_idx);
			result.put("list", list);
			if(list.size() == 0) {
				result.put("eCode", 2);
			}
			else {
				result.put("ecode", 0);
			}
		}
		return result;
	}
	
	@Override
	public Map<String, Object> allRoomDelete(int item_idx) {
		mapper.allRoomDelete(item_idx);
		return null;
	}
	
	@Override
	public int realItemInsert(ItemVO ivo) {
		
		if(ivo.getItem_Category().equals("hotel")) {
			int people = mapper.maxPeople(0);
			ivo.setPeople(people);
		}
			
		mapper.realItemInsert(ivo);
		mapper.realIdxUpdate();
		return 0;
	}
	
	@Override
	public HotelDetailVO getOnehotelDetail(int item_idx, int hotel_idx) {
		return mapper.getOnehotelDetail(item_idx, hotel_idx);
	}
	
	
	@Override
	public CountryClassVO countryCategory(String country) {
	   return  mapper.countryCategory(country);
	}
	
	@Override
	public void updateRoom(HotelDetailVO hdvo) {
		mapper.updateRoom(hdvo);
		int poeple = mapper.maxPeople(hdvo.getItem_idx());
		mapper.updatePeople(hdvo.getItem_idx(), poeple);
	}
	
	@Override
	public void oneItemUpdate(ItemVO ivo) {
		mapper.oneItemUpdate(ivo);
	}
	
	@Override
	public List<HotelDetailVO> getAllHotelRoom(int item_idx) {
		return mapper.hotelRoomGet(item_idx);
	}
	
	
	
	//날짜 형식을 2023-01-01 => 2023-1-1로 변경
	private String deleteZero(String dateStr) {
		
		String y = dateStr.substring(0, 4);
		String m = dateStr.substring(5, 7);
		String d = dateStr.substring(8, 10);
		
		if(isNumeric(m) && Integer.parseInt(m) < 10) {
			m = m.replaceAll("0", "");
		}
		if(isNumeric(d) && Integer.parseInt(d) < 10) {
			d = d.replaceAll("0", "");
		}
		dateStr = y + "-" + m + "-" + d;
		
		return dateStr;
	}
	
	//문자열이 숫자인지 확인
	private boolean isNumeric(String s) {
        try {
            Integer.parseInt(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
	
	//크기비교용 : 날짜 int로 변경
	private int dateToInt(String s) {
		
		int n;
		s = s.replace("-", "");
		if(isNumeric(s)) {
			
			n = Integer.parseInt(s);
		}
		else {
			n = 21000101;
		}
		return n;
	}
	
	// 결제 ==================================
	@Override
	public int payInsert(UserOrderVO vo) {
		return mapper.payInsert(vo);
	}
	
	
	
	

	

}
