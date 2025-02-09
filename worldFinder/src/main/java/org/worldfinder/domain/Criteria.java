package org.worldfinder.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class Criteria {

	private int pageNum; //현재 페이지 번호
	private int amount;	 //몇 개씩 볼 것인지
	
	
	
	public Criteria() {	//기본 생성자
		this.pageNum = 1;
		this.amount = 10;	//아무 값도 설정하지 않았을 때의 기본값
	}
	public Criteria(int pageNum) {	//기본 생성자
		this.pageNum = pageNum;
		this.amount = 10;	//아무 값도 설정하지 않았을 때의 기본값
	}
	
}