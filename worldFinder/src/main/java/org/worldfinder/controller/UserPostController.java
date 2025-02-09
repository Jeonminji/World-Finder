package org.worldfinder.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.LikeVO;
import org.worldfinder.domain.PageDTO;
import org.worldfinder.domain.ReportVO;
import org.worldfinder.domain.ScrapVO;
import org.worldfinder.domain.UserPostVO;
import org.worldfinder.service.UserPostCommentService;
import org.worldfinder.service.UserPostService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/userPost/*")
public class UserPostController {

	@Setter(onMethod_ = @Autowired)
	private UserPostService userService;

	@Setter(onMethod_ = @Autowired)
	private UserPostCommentService userCommentService;

	@GetMapping("/main")
	public String list(Model model, Criteria cri, @RequestParam("country") String country) {
		log.info("userPost controller list..");
		List<UserPostVO> vo = userService.getList(cri, country);
		log.info(vo.toString());
	 	model.addAttribute("list", vo);
	 	model.addAttribute("country", country);
		model.addAttribute("pageMaker", new PageDTO(cri, userService.getTotal()));
		return "userPost/userPostList";
	}

	@GetMapping("/view")
	public String view(@RequestParam("up_idx") long up_idx, @RequestParam("country") String country, Model model, Criteria cri, Authentication authentication, HttpSession session) {
		log.info("userPost controller view.." + up_idx);
		model.addAttribute("list", userService.postView(up_idx));
		model.addAttribute("cri", cri);
		model.addAttribute("country", country);
		
		// 조회수
		UserPostVO vo = userService.postView(up_idx);
		int hit = vo.getHit() + 1;
		vo.setHit(hit);
		userService.modifyHit(vo);
		/*
		String open = (String)session.getAttribute("open");
		if (open == null) {
			session.setAttribute("open", "yes");
			int hit = vo.getHit() + 1;
			vo.setHit(hit);
			userService.modifyHit(vo);
			System.out.println("조회 수 : " + hit);
		}
		System.out.println("open session null");
		*/

		String currentUser = null;
		
		if (authentication == null) {
			currentUser = "";
		} else {
			currentUser = authentication.getName();
		}
		

		// 현재 로그인한 사용자의 스크랩 상태
		boolean scrapStatus = userService.checkScrapStatus(up_idx, currentUser);
		
		// 현재 로그인한 사용자의 좋아요 상태
		boolean likeStatus = userService.checkLikeStatus(up_idx, currentUser);
		
		// 좋아요 수
		int likeCount = userService.getLikeCount(up_idx);
		System.out.println("좋아요: " + likeCount);
		vo.setUp_like(likeCount);
		userService.modifyLike(vo);
		
		
		model.addAttribute("currentUser", currentUser);
		model.addAttribute("likeStatus", likeStatus);
		model.addAttribute("likeCount", likeCount);

		model.addAttribute("scrapStatus", scrapStatus);
		
		return "userPost/userPostView";
	}

	@PreAuthorize("isAuthenticated()")
	@GetMapping("/write")
	public String register(Model model, Criteria cri, @RequestParam("country") String country) {
		log.info("userPost controller register(get)..");
		model.addAttribute("cri", cri);
		model.addAttribute("country", country);
		return "userPost/userPostWrite";
	}

	@PreAuthorize("isAuthenticated()")
	@PostMapping("/write")
	public String register(UserPostVO vo, RedirectAttributes rttr, @RequestParam("country") String country, Model model) {
		log.info("userPost controller register(post).." + vo);
		userService.postRegister(vo);
		log.info(country);
		
		rttr.addAttribute("country", country);

		return "redirect:/userPost/main";
	}

	@GetMapping("/update")
	public String update(@RequestParam("up_idx") long up_idx, Model model, Criteria cri, @RequestParam("country") String country) {
		log.info("userPost controller update(get).." + up_idx);
		model.addAttribute("list", userService.postView(up_idx));
		model.addAttribute("cri", cri);
		model.addAttribute("country", country);
		return "userPost/userPostUpdate";
	}

	@PreAuthorize("principal.username == #vo.u_writer") // list.u_writer 가 아니라 vo.u_writer (파라미터에서 값 찾아야함)
	@PostMapping("/update")
	public String update(UserPostVO vo, RedirectAttributes rttr, @RequestParam("country") String country, Model model) {
		log.info("userPost controller update(post).." + vo.getUp_idx());
		model.addAttribute("country", country);
		if (userService.postModify(vo)) {
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("country", country);
		return "redirect:/userPost/view?up_idx=" + vo.getUp_idx();
	}

	@PostMapping("/delete")
	public String delete(@RequestParam("up_idx") long up_idx, RedirectAttributes rttr, @RequestParam("country") String country) {
		log.info("userPost controller delete(post).." + up_idx);
		if (userService.postRemove(up_idx)) {
			rttr.addAttribute("result", "success");
		}
		rttr.addAttribute("country", country);
		return "redirect:/userPost/main";
	}
	
    @PostMapping(value = "/like", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public ResponseEntity<String> like(@RequestBody Map<String, Long> requestBodyMap, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");
        }

        String u_writer = authentication.getName();
        Long up_idx = requestBodyMap.get("up_idx");
        LikeVO vo = new LikeVO(up_idx, u_writer);

        try {
            userService.like(vo);
            return ResponseEntity.ok("ok");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error");
        }
    }

    @DeleteMapping(value = "/dislike", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public ResponseEntity<String> dislike(@RequestBody Map<String, Long> requestBodyMap, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");
        }

        String u_writer = authentication.getName();
        Long up_idx = requestBodyMap.get("up_idx");
        LikeVO vo = new LikeVO(up_idx, u_writer);

        try {
            userService.dislike(vo);
            return ResponseEntity.ok("ok");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error");
        }
    }
	
	
    @GetMapping("/checkLike")
    public ResponseEntity<String> checkLike(@RequestParam int up_idx) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("not_authenticated");
        }

        String u_writer = authentication.getName();
        int likeCount = userService.checkLikeStatus(up_idx, u_writer) ? 1 : 0;	// 좋아요 유무 확인
        
        // return: ajax의 response
        if (likeCount > 0) {
            return ResponseEntity.ok("liked"); // 이미 좋아요 버튼 누름
        } else {
            return ResponseEntity.ok("not_liked");	// 좋아요 버튼 누른적 없음
        }
    }
    
    
    
    
    // 스크랩 ==================================
    @PostMapping(value = "/scrap", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public ResponseEntity<String> scrap(@RequestBody Map<String, Long> requestBodyMap, Authentication authentication) {
    	if (authentication == null || !authentication.isAuthenticated()) {
    		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");
    	}
    	
    	String u_writer = authentication.getName();
    	Long up_idx = requestBodyMap.get("up_idx");
    	ScrapVO vo = new ScrapVO(u_writer, up_idx);
    	
    	try {
    		userService.scrap(vo);
    		//return ResponseEntity.ok("ok");
    		return new ResponseEntity<String>("ok", HttpStatus.OK);
    	} catch (Exception e) {
    		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error");
    	}
    }
    
    @DeleteMapping(value = "/scrapCancle", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public ResponseEntity<String> scrapCancle(@RequestBody Map<String, Long> requestBodyMap, Authentication authentication) {
    	if (authentication == null || !authentication.isAuthenticated()) {
    		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");
    	}
    	
    	String u_writer = authentication.getName();
    	Long up_idx = requestBodyMap.get("up_idx");
    	ScrapVO vo = new ScrapVO(u_writer, up_idx);
    	
    	try {
    		userService.scrapCancle(vo);
    	 	return ResponseEntity.ok("ok");
    	} catch (Exception e) {
    		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error");
    	}
    }
    
    @GetMapping("/checkScrap")
    public ResponseEntity<String> checkScrap(@RequestParam int up_idx) {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
    		return ResponseEntity.status(HttpStatus.FORBIDDEN).body("not_authenticatied");
    	}
    	
    	String u_writer = authentication.getName();
    	int scrapCount = userService.checkScrapStatus(up_idx, u_writer) ? 1 : 0;
    	
    	if (scrapCount > 0) {
    		return ResponseEntity.ok("scraped");
    	} else {
    		return ResponseEntity.ok("not_scraped");
    	}
    }
    
    
    
    // 신고 ==================================
    @PostMapping(value="/report", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String report(@RequestBody ReportVO vo) {
    	log.info("userPost controller report...." + vo);
    	
    	String result = Integer.toString(userService.postReport(vo));
    	
    	return result;
    }
	
}