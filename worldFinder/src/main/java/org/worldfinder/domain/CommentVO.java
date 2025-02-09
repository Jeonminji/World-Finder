package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentVO {
	private long c_idx, up_idx;
	private int c_like;
	private String c_content, c_hide, u_writer;
	private Date reg_date;
}
