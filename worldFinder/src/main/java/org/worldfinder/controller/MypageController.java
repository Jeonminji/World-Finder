package org.worldfinder.controller;

import java.util.List;

import javax.print.attribute.standard.Media;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.MyPageCommentsVO;
import org.worldfinder.domain.MyPagePayVO;
import org.worldfinder.domain.MyPageRepliesVO;
import org.worldfinder.domain.NestedCVO;
import org.worldfinder.domain.ScrapVO;
import org.worldfinder.domain.UserPostVO;
import org.worldfinder.domain.UserVO;
import org.worldfinder.service.MypageService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/myPage/*")
public class MypageController {
	
	@Setter(onMethod_ = @Autowired)
	private MypageService service;
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/main")
	public String myPage(Model model, Authentication authentication) {
		
		String currentUser = null;
		
		if (authentication == null) {
			currentUser = "";
		} else {
			currentUser = authentication.getName();
		}
		
		model.addAttribute("currentUser", currentUser);
		
		return "user/myPage";
	}
	
	@GetMapping(value="/userInfo/{currentUser}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<UserVO>> getUserInfoList(@PathVariable("currentUser") String currentUser, Model model) {
		log.info("myPage controller userInfoList..." + currentUser);
		
		return new ResponseEntity<List<UserVO>>(service.getUserInfo(currentUser), HttpStatus.OK);
	}

	@GetMapping(value="/postInfo/{currentUser}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<UserPostVO>> getPostInfoList(@PathVariable("currentUser") String currentUser, Model model) {
		log.info("myPage controller postInfoList..." + currentUser);
		
		return new ResponseEntity<List<UserPostVO>>(service.getUserPost(currentUser), HttpStatus.OK);
	}

	@GetMapping(value="/commentInfo/{currentUser}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<MyPageCommentsVO>> getCommentInfoList(@PathVariable("currentUser") String currentUser) {
		log.info("myPage controller commentInfoList...." + currentUser);
		
		return new ResponseEntity<List<MyPageCommentsVO>>(service.getUserComment(currentUser), HttpStatus.OK);
	}
	
	@GetMapping(value="/replyInfo/{currentUser}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<MyPageRepliesVO>> getReplyInfoList(@PathVariable("currentUser") String currentUser) {
		log.info("myPage controller replyInfoList..." + currentUser);
		
		return new ResponseEntity<List<MyPageRepliesVO>>(service.getUserReply(currentUser), HttpStatus.OK);
	}
	
	@GetMapping(value="/scrapInfo/{currentUser}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<UserPostVO>> getScrapInfoList(@PathVariable("currentUser") String currentUser, Model model) {
		log.info("myPage controller scrapInfoList..." + currentUser);
		
		return new ResponseEntity<List<UserPostVO>>(service.getUserScrap(currentUser), HttpStatus.OK);
	}
	
	@GetMapping(value="/payInfo/{currentUser}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<MyPagePayVO>> getPayInfoList(@PathVariable("currentUser") String currentUser, Model model) {
		log.info("myPage controller payInfoList..." + currentUser);
		
		System.out.println("=======================");
		System.out.println(currentUser);
		
		return new ResponseEntity<List<MyPagePayVO>>(service.getUserPay(currentUser), HttpStatus.OK);
	}
}