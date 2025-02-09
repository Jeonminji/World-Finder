package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserOrderVO {

//	-- 주문 테이블
//	CREATE TABLE USER_ODERS_TABLE3 (
//	   item_Idx   NUMBER   references item_table3(item_Idx),
//	   u_Writer   VARCHAR2(30)   references user_table3(u_Writer),
//	   buy_Date   DATE   DEFAULT SYSDATE,
//	   check_In_Date   DATE   NOT NULL,
//	   check_Out_Date   DATE   NOT NULL,
//	   people   number   NOT NULL,
//	   final_Price   NUMBER   NOT NULL
//	);
	
	private int item_Idx;			//구매한 상품 idx
	private String u_Writer;		//구매한 유저 idx
	private Date buy_Date;			//구매 날짜
	private Date check_In_Date;		//이벤트 시작일
	private Date check_Out_Date;	//이벤트 종료일
	private int people;				//이벤트 인원
	private int final_Price;		//최종 가격
	private int hotel_idx;			//호텔 객실 번호
	
}
