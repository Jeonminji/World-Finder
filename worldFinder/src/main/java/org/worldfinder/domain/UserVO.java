package org.worldfinder.domain;

import java.sql.Date;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Repository
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserVO {
	private String u_writer, u_pw, u_name, phone, mail, nationality, auth, old_pw, birth, gender;
	private Date reg_date;

	private List<AuthVO> authList;


	
	
	
	
	
}
