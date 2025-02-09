package org.worldfinder.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Date;

@Getter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class ReportVO {

    private long r_idx;
    private String r_content;
    private Date reg_date;
    private String r_category;
    private long idx;
    private String u_writer;
    private int r_count;
}
