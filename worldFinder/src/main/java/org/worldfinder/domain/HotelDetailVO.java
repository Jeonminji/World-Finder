package org.worldfinder.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HotelDetailVO {
	
//	HOTEL_IDX        NOT NULL NUMBER        
//	ITEM_IDX                  NUMBER        
//	HOTEL_ROOM       NOT NULL VARCHAR2(50)  
//	HOTELROOM_PRICE  NOT NULL NUMBER        
//	HOTELROOM_SIZE            NUMBER        
//	HOTELROOM_VIEW            VARCHAR2(200) 
//	HOTEL_CATEGORY            VARCHAR2(100) 
//	HOTELROOM_PEOPLE          NUMBER 

	private int hotel_idx;
	private int item_idx;
	private String hotel_room;
	private int hotelRoom_price;
	private int hotelRoom_size;
	private String hotelRoom_view;
	private String hotel_category;
	private int hotelRoom_people;
	
}
