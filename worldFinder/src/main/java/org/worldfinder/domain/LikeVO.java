package org.worldfinder.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LikeVO {
	private long idx;
	private String u_writer;	// 현재 로그인한 사람의 아이디 값
}
