package org.worldfinder.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FoodFilterVO {

	private String country;
	
	private int page;
	private int amount;
	private int total;
}
