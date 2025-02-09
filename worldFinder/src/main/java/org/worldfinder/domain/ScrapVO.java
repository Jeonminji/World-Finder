package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScrapVO {
	private String u_writer;	// 현재 로그인한 사용자의 아이디 값
	private long up_idx;
	
	//private String country;
	//private String title;
	//private Date reg_date;
}
