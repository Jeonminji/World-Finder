package org.worldfinder.controller;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.worldfinder.mapper.MainMapper;
import org.worldfinder.service.UserPostCommentTests;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml","file:src/main/webapp/WEB-INF/spring/security-context.xml"})
public class test {
	
	@Setter(onMethod_ = @Autowired )
	MainMapper m;
	
	@Test
	public void test() {
		log.info(m.countrySearch("서아시아"));
	}
}
