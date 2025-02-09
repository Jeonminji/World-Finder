package org.worldfinder.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FoodPostVO {
	
	private int fp_Idx;				//맛집 게시글 기본키
	private String country;			//나라
	private String fp_Image; 		//이미지 파일 이름
	private String fp_Name;			//가게(맛집) 이름
	private String fp_Address;		//주소
	private String fp_Tel; 			//가게 전화번호
	private String fp_Category;		//가게 유형 (ex 일식, 양식...)
	private String fp_Menu;			//대표 메뉴
	private Date reg_Date;			//작성일
	private Date update_Date;		//수정일

}
