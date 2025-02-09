package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NestedCVO {
	private long nc_idx, c_idx, up_idx;
	private String nc_content, nc_hide, u_writer;
	private int nc_like;
	private Date reg_date;
}
