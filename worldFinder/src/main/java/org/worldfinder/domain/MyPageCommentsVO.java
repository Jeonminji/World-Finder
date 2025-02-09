package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MyPageCommentsVO {
	private String u_writer, title, c_content, country;
	private Date reg_date;
	private long up_idx;
}
