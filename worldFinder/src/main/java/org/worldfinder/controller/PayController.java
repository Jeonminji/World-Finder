package org.worldfinder.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.worldfinder.domain.CommentVO;
import org.worldfinder.domain.UserOrderVO;
import org.worldfinder.service.ManagerItemService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class PayController {
	
	@Setter(onMethod_ = @Autowired)
	private ManagerItemService service;
	
	@PostMapping(value="/pay", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String write(@RequestBody UserOrderVO vo) {
        log.info("pay controller.." + vo);
        
        try {
            int result = service.payInsert(vo);
            if (result > 0) {
                return "Success"; // 또는 원하는 응답 메시지
            } else {
                return "Failed"; // 또는 실패 응답 메시지
            }
        } catch (Exception e) {
            log.error("Error occurred: " + e.getMessage());
            return "Error"; // 에러 응답 메시지
        }
    }
}
