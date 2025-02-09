package org.worldfinder.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.worldfinder.domain.CountryClassVO;
import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.FoodFilterVO;
import org.worldfinder.domain.FoodPostVO;
import org.worldfinder.domain.ItemFilterVO;
import org.worldfinder.domain.ItemVO;
import org.worldfinder.domain.PageDTO;
import org.worldfinder.service.ManagerFoodService;
import org.worldfinder.service.ManagerItemService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/manager/food/*")
public class ManagerFoodController {

	
	@Setter(onMethod_ = @Autowired)
	private ManagerFoodService service;
	
	@Setter(onMethod_ = @Autowired)
	private ManagerItemService itemService;
	
	@GetMapping("/foodListGet")
	public String list(Model model, Criteria cri) {
		log.info("controller itemList...");

		return "manager/food/foodList#";
	}
	
	@PostMapping("/foodList")
	public String foodList(Model model, RedirectAttributes redirectAttributes,
			@RequestParam("country") String country) {
		log.info("controller foodList...");
		
		redirectAttributes.addAttribute("country", country);
		return "redirect:/manager/food/foodList";
	}
	
	
	@GetMapping("/foodList")
	public String foodListGet(FoodFilterVO ffvo, Model model) {
		log.info("controller foodList...");
		
		if(ffvo.getPage() < 1) {
			ffvo.setPage(1);
		}
		
		Criteria cri = new Criteria(ffvo.getPage());
   		
   		int countTotal = service.countFoodList(ffvo); 		
   		ffvo.setTotal(countTotal);
   		
		model.addAttribute("country", itemService.countryCategory(ffvo.getCountry()));
		model.addAttribute("list", service.getFoodList(ffvo));
		model.addAttribute("pageMaker", new PageDTO(cri, countTotal));

		return "manager/food/foodList";
		
	}
	
	
	@PostMapping("/ajaxfoodList")
	@ResponseBody
	public Map<String, Object> getFoodList( 
   			@RequestBody FoodFilterVO ffvo) throws Exception {
   		
		System.out.println("country : " + ffvo.getCountry());
		
   		Criteria cri = new Criteria();
   		
   		Map<String, Object> result = new HashMap<String, Object>();
   		int countTotal = service.countFoodList(ffvo);
   		PageDTO pdto = new PageDTO(cri, countTotal);  
   		ffvo.setTotal(countTotal);
   		ffvo.setAmount(pdto.getCri().getAmount());
   		                                                                     
   		List<FoodPostVO> list = service.getFoodList(ffvo);   
   		result.put("list",  list);                                           
   		result.put("page",  ffvo.getPage());                         
   		result.put("startpage",  pdto.getStartPage());                       
   		result.put("endpage",  pdto.getEndPage());                           
   		                                                                     
   		log.info("controller ajaxFoodList...");                        
   		return result;
   	}
	
	@PostMapping("/foodInsertPage")
	public String foodInsertPage(Model model, @RequestParam("country") String country) {
		
		log.info("controller foodInsertPage...");
		model.addAttribute("countryInfo", itemService.countryCategory(country));
		
		return "manager/food/foodRegister";
	}
	
	@PostMapping("/foodInsert")
	public String foodInsert(FoodPostVO fvo) {
		
		log.info("controller foodInsert...");
		
		System.out.println(fvo);
		service.foodInsert(fvo);
		return "redirect:/manager/food/foodList";
	}
	
	@PostMapping("/foodUpdatePage")
	public String foodUpdatePage(@RequestParam("fpIdx") int fpIdx, Model model) {
		
		log.info("controller foodUpdatePage...");
		FoodPostVO fvo = service.getFoodPost(fpIdx);

		CountryClassVO cvo = itemService.countryCategory(fvo.getCountry());
		
		model.addAttribute("countryInfo", cvo);
		model.addAttribute("foodInfo", service.getFoodPost(fpIdx));
		return "manager/food/foodUpdate";
	}
	
	
	
	
	
	
	
	
	
	
}