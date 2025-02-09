package org.worldfinder.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@Log4j	// 로그를 찍기 위함(안 하고 sysout 해도 상관 없음)
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class DataSourceTests {
	@Autowired
	private DataSource dataSource;	// 이미 new 되어있음
	
	@Test
	public void testConnection() {
		try(Connection con = dataSource.getConnection()) {
			log.info(con);
		} catch(Exception e) {
			fail(e.getMessage());
		}
	}
	
	@Autowired
	private SqlSessionFactory sqlSessionFactory;
	
	@Test
	public void testMybatis() {
		try(SqlSession session = sqlSessionFactory.openSession()) {
			log.info(session);
		} catch (Exception e) {
			fail(e.getMessage());
			 
		}
	}	
}
