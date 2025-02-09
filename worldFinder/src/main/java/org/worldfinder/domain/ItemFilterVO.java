package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ItemFilterVO {
	
	private String country;				//나라
	private String item_Category;		//카테고리 (관광지, 숙소)
	private int people;					//인원수
	private Date startDay;				//시작일
	private Date endDay;				//종료일
	
	private Date startDayHotel;			//숙소 이벤트 시작일
	private Date endDayHotel;			//숙소 이벤트 종료일
	private Date startDaySpot;			//관광지 이벤트 시작일
	private Date endDaySpot;			//관광지 이벤트 종료일
	
	
	private int page;					//페이지
	private int amount;					//한 페이지에 띄울 게시글 수
	private int countTotal;				//전체 게시글 수
}
