package org.worldfinder.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.NestedCVO;
import org.worldfinder.service.UserPostCommentService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/comment/")
public class UserPostCommentController {
	
	// write : /write
	// getList : /:up_idx
	// get, update, remove : /:c_idx
	
	
	@Setter(onMethod_ = @Autowired)
	private UserPostCommentService comService;
	
	// 삽입
	@PostMapping(value="/write", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String write(@RequestBody CommentVO vo) {
		log.info("userComment controller write..");
		
		String result = Integer.toString(comService.registerComment(vo));
		
		return result;
	}
	
	// 댓글 리스트(up_idx)
	@GetMapping(value="/{up_idx}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<CommentVO>> getList(@PathVariable("up_idx") long up_idx, Model model, Authentication authentication) {
		log.info("userComment controller getList..");
		
		int totalComment = comService.getTotalComment(up_idx) + comService.getTotalNestedCom(up_idx);
		model.addAttribute("totalComment", totalComment);
		
		
		return new ResponseEntity<>(comService.getCommentList(up_idx), HttpStatus.OK);
	}
	
	// 수정
	@PutMapping(value = "/{c_idx}", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String modify(@PathVariable("c_idx") long c_idx, @RequestBody CommentVO vo) {
		log.info("userComment controller modify.." + vo);
		log.info("userComment controller modify.." + c_idx);

		vo.setC_idx(c_idx);

		String result = Integer.toString(comService.modifyComment(vo));

		return result;

	}
	
	// 삭제
	@DeleteMapping(value="/{c_idx}", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String remove(@PathVariable("c_idx") long c_idx) {
		log.info("userComment controller remove.." + c_idx);
		
		String result = Integer.toString(comService.removeComment(c_idx));
		
		return result;
	}
	
	
	// 총 댓글 수 ------------------------------
	@GetMapping("/total/{up_idx}")
	@ResponseBody
	public ResponseEntity<Integer> getTotalCommentCount(@PathVariable("up_idx") long up_idx) {
	    int totalComment = comService.getTotalComment(up_idx) + comService.getTotalNestedCom(up_idx);
	    return new ResponseEntity<>(totalComment, HttpStatus.OK);
	}
	
	// 좋아요 ------------------------------
	/*
	@PostMapping(value = "/like", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public ResponseEntity<String> likeComment(@RequestBody Map<String, Long> requestBodyMap, Authentication authentication) {
		if (authentication == null || !authentication.isAuthenticated()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");
		}
		
		String u_writer = authentication.getName();
		Long c_idx = requestBodyMap.get("c_idx");
		LikeVO vo = new LikeVO(c_idx, u_writer);
		
		System.out.println("--------------------------");
		System.out.println(c_idx);
		System.out.println(u_writer);
		
		try {
			comService.likeComment(vo);
			return ResponseEntity.ok("ok");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error");
		}
	}
	
	@DeleteMapping(value = "/dislike", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public ResponseEntity<String> dislikeComment(@RequestBody Map<String, Long> requestBodyMap, Authentication authentication) {
		if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");
        }
		
		String u_writer = authentication.getName();
		Long c_idx = requestBodyMap.get("c_idx");
		LikeVO vo = new LikeVO(c_idx, u_writer);
		
		try {
			comService.dislikeComment(vo);
			return ResponseEntity.ok("ok");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error");
		}
	}
	
	@GetMapping("/checkLike")
	public ResponseEntity<String> checkCommentLike(@RequestParam("c_idx") int c_idx) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("not_authenticated");
        }
        
		String u_writer = authentication.getName();
		int likeCommentCount = comService.checkCommentLikeStatus(c_idx, u_writer) ? 1 : 0;
		System.out.println("----------");
		System.out.println(c_idx);
		System.out.println(u_writer);
		
		if (likeCommentCount > 0) {
			return ResponseEntity.ok("cliked");
		} else {
			return ResponseEntity.ok("not_cliked");
		}
		
	}
	*/
	
	
	// 대댓글(reply) --------------------------------------
	
	// 대댓글 삽입
	@PostMapping(value="/reply/write", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String replyWrite(@RequestBody NestedCVO vo) {
		log.info("userReply controller write.." + vo);
		
		String result = Integer.toString(comService.registerNestedCom(vo));
		
		return result;
	}
	
	// 대댓글 리스트(c_idx)
	@GetMapping(value="/reply/{c_idx}", produces = {MediaType.APPLICATION_ATOM_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<NestedCVO>> getReplyList(@PathVariable("c_idx") long c_idx) {
		log.info("userReply controller getList.." + c_idx);
		
		return new ResponseEntity<>(comService.getNestedComList(c_idx), HttpStatus.OK);
	}
	
	// 대댓글 삭제
	@DeleteMapping(value="/reply/{nc_idx}", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String replyRemove(@PathVariable("nc_idx") long nc_idx) {
		log.info("userReply controller remove.." + nc_idx);
		
		String result = Integer.toString(comService.removeNestedCom(nc_idx));
		
		return result;
	}
	
	// 대댓글 수정
	@PutMapping(value="/reply/{nc_idx}", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String replyModify(@PathVariable("nc_idx") long nc_idx, @RequestBody NestedCVO vo) {
		log.info("userReply controller modify.." + nc_idx);
		log.info("userReply controller modify.." + vo);
		
		vo.setNc_idx(nc_idx);
		
		String result = Integer.toString(comService.modifyNestedCom(vo));
		
		return result;
		
	}
	
}
