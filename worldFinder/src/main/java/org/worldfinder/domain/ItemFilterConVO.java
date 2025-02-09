package org.worldfinder.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class ItemFilterConVO {
//	model.addAttribute("idx", idx);
//		model.addAttribute("people", people);
//		model.addAttribute("country", country);
//		model.addAttribute("item_Category", item_Category);
//		model.addAttribute("startDay", startDay);
//		model.addAttribute("endDay", endDay);
//		model.addAttribute("page", page);
	
	private int idx;
	private int people;
	private String country;
	private String item_Category;
	private Date startDay;
	private Date endDay;
	private int page;
}
