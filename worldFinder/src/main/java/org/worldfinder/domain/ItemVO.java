package org.worldfinder.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ItemVO {

	
//	-- 상품 상세 테이블
//	CREATE TABLE item_table3 (
//	   ITEM_IDX   NUMBER   primary key,
//	   country   VARCHAR2(50)   references c_class_table3(country),
//	   item_Name   VARCHAR2(50)   NOT NULL,
//	   regdate   date   DEFAULT sysdate,
//	   introduce   VARCHAR2(200)   NOT NULL,
//	   image   VARCHAR2(50)   NOT NULL,
//	   address   VARCHAR2(100)   NOT NULL,
//	   item_Category   VARCHAR(255)   NOT NULL,
//	   people   NUMBER   NOT NULL,
//	   price   NUMBER,
//	   tel   varchar2(30)   NOT NULL,
//	   item_Option   VARCHAR2(20),
//	   item_Url   varchar2(50)
//	);
	
	private int item_Idx;			//상품 기본키
	private String country;			//상품 출처 (나라)
	private String item_Name;		//상품 이름
	private String regdate;			//등록 날짜
	private String introduce;		//상품 소개
	private String image;			//이미지 파일 이름
	private String address;			//주소
	private String item_Category;	//유형(숙소, 관광지)
	private int people;				//인원수
	private int price;				//가격
	private String tel;				//전화번호
	private String item_Option;			//관광지 유형 (박물관, 공원 등)
	private String item_Url;				//상품(관광지, 호텔 등의) 관련 링크
	
	private List<HotelDetailVO> hotel_detail_list; 	//호텔 객실 정보 리스트
	
}
