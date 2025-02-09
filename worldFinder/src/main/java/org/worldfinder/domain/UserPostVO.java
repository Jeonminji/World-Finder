package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserPostVO {
	private long up_idx;
	private String u_writer, country, title, up_content, up_hide, thumbnail;
	private Date reg_date, update_date;
	private int hit, up_like;
}
