package org.worldfinder.service;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.NestedCVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class UserPostCommentTests {
	@Setter(onMethod_ = @Autowired)
	UserPostCommentService service;
	
	/*
	@Test
	public void testGetList() {
		List<CommentVO> list1 = service.getCommentList(24);		// up_idx 
		List<NestedCVO> list2 = service.getNestedComList(2);	// c_idx
		
		for (CommentVO vo : list1) {
			log.info(vo);
		}

		for (NestedCVO vo : list2) { 
			log.info(vo); 
		} 
	}
	*/
	
	
	@Test
	public void testInsert() {
		CommentVO vo = new CommentVO();
		vo.setU_writer("tw123");
		vo.setC_content("adsasdas~~");
		vo.setUp_idx(3);
		
		service.registerComment(vo);
	}
	
	
	
	/*
	@Test
	public void testInsertNes() {
		NestedCVO vo = new NestedCVO();
		vo.setC_idx(2);
		vo.setU_writer("tw123");
		vo.setUp_idx(24);
		vo.setNc_content("12312sadzcxzc");
		
		service.registerNestedCom(vo);
	}
	*/
	
	
	/*
	@Test
	public void testModify() {
		CommentVO vo = service.viewComment(1);
		
		vo.setC_content("ㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁ");
		service.modifyComment(vo);
		
		log.info(service.viewComment(1));
	}
	*/
	
	/*
	@Test
	public void testModifyNes() {
		NestedCVO vo = service.viewNestedCom(1);
		
		vo.setNc_content("adadsada");
		service.modifyNestedCom(vo);
		
		log.info(service.viewNestedCom(1));
	}
	*/
	
	/*
	@Test
	public void testCount() {
		log.info("댓글 개수" + service.getTotalComment());
		log.info("대댓글 개수" + service.getTotalNestedCom());
		log.info("총 댓글 개수" + (service.getTotalComment() + service.getTotalNestedCom()));
	}
	*/
	
	/*
	@Test
	public void testRemove() {
		service.removeComment(2);
	} 
	*/
	
}
