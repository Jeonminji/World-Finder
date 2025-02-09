package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MyPagePayVO {
	private String u_writer, item_name, country;
	private Date buy_date;
	private long hotel_idx, item_idx;
	private int final_price;
}
