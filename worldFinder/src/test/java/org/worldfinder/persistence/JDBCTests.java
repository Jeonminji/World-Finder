package org.worldfinder.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

import lombok.extern.log4j.Log4j;

@Log4j	// 화면 출력할 때 주로 사용
public class JDBCTests {
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
		
	// 단위 테스트는 주로 메소드 단위로 실행
	// 테스트할 때는 @Test 어노테이션 붙이기
	@Test
	public void testConnection() {
		try (Connection con = DriverManager.getConnection(
				"jdbc:oracle:thin:@localhost:1521:xe", 
				"scott", 
				"tiger"
				)
			) 
		{
			log.info(con);
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}
}
