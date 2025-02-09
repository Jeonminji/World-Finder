package org.worldfinder.controller;


import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.worldfinder.domain.AttachFileDTO;
import org.worldfinder.domain.Criteria;
import org.worldfinder.domain.HotelDetailVO;
import org.worldfinder.domain.ItemFilterConVO;
import org.worldfinder.domain.ItemFilterVO;
import org.worldfinder.domain.ItemVO;
import org.worldfinder.domain.PageDTO;
import org.worldfinder.domain.UserOrderVO;
import org.worldfinder.service.ManagerItemService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/manager/item/*")
public class ManagerItemController {

	
	@Setter(onMethod_ = @Autowired)
	private ManagerItemService service;
	
	
	@GetMapping("/itemList3")
	public String toList3(Model model, @RequestParam("country") String country) {
		log.info("controller itemList3...");
		
		model.addAttribute("itemInfo", null);
		model.addAttribute("country", service.countryCategory(country));
		
		System.out.println("!!!!!!!!!!!!!!!!!!!!!");
		System.out.println(country);
		return "manager/item/itemList3";
	}
		
	
   	//아이템 리스트를 비동기로 받아오기 (검색기능 + 날짜 검색기능 추가)
   	//@RequestBody : JSON 으로 받아온 데이터를 java 객체로 사용
   	@RequestMapping(value = "/ajaxItemListFilterDate",
   			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_VALUE})
   	@ResponseBody
   	public Map<String, Object> getItemListFilterDate( 
   			@RequestBody ItemFilterVO itemFiltervo) throws Exception {
   		
   		Criteria cri = new Criteria(itemFiltervo.getPage());
   		
   		Map<String, Object> result = new HashMap<String, Object>();
   		itemFiltervo.setCountTotal(service.getCountwithFilterDate(itemFiltervo));
   		PageDTO pdto = new PageDTO(cri, itemFiltervo.getCountTotal());
   		itemFiltervo.setAmount(cri.getAmount());   
   		                                                                     
   		List<ItemVO> list = service.getListwithFilterDate(itemFiltervo);     
   		result.put("list",  list);                                           
   		result.put("page",  itemFiltervo.getPage());                         
   		result.put("startpage",  pdto.getStartPage());                       
   		result.put("endpage",  pdto.getEndPage());                           
   		                                                                     
   		log.info("controller ajaxItemListFilter...");                        
   		
   		return result;
   	}
	
   
   	//아이템 상세페이지로 이동 (예약페이지)
   	@PreAuthorize("isAuthenticated()")
   	@PostMapping(value = "/itemGet")
   	public String hotelGet(ItemFilterConVO icvo, Model model) {
   		
   		String cate = service.getItemWithIdx(icvo.getIdx()).getItem_Category();
   		model.addAttribute("cate", cate);
   		model.addAttribute("itemInfo", icvo);
   		return "manager/item/itemGet";
   	}
   	
   	
   	
   	//상세페이지 내에서 세부정보 받아오기
   	@RequestMapping(value = "/ajaxHotelGet",
   			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_VALUE})
   	@ResponseBody
   	public ItemVO ajaxHotelGet(@RequestBody ItemFilterConVO icvo) throws ParseException {

   		
   		log.info("controller ajaxHotelGet...");
   		return service.getItemDetail(icvo);
   	}
   	
   	//상세페이지 내에서 숙소 날짜 정보 받아오기
   	@PostMapping("/getNoDate")
   	@ResponseBody
   	public Map<String, Object> getNoDate(@RequestParam("hotelIdx") int hotelIdx) throws ParseException{
   		
   		log.info("controller getNoDate...");
   		
   		Map<String, Object> result = service.getNoDate(hotelIdx);
   		
   		return result;	
   	}
   	
   	//상세페이지 내에서 관광지 날짜정보 받아오기
   	@PostMapping("/getNoDateSpot")
   	@ResponseBody
   	public Map<String, Object> getNoDateSpot(@RequestParam("itemIdx") int itemIdx,
   											@RequestParam("people") int people,
   											@RequestParam("startDay") String startDay) throws ParseException{
   		
   		log.info("controller getNoDateSpot...");
   		
   		Map<String, Object> result = service.getNoDateSpot(itemIdx, people, startDay);
   		
   		return result;	
   	}
   	
   	//아이템 등록 페이지로
   	@PreAuthorize("hasAuthority('admin')")
   	@PostMapping("/itemInsert")
   	public String itemInsert(@RequestParam("country") String country,
   							@RequestParam("categoryInfo") String categoryInfo,
   							Model model) {
   		
   		log.info("controller itemInsert...");
   		
   		service.itemInsertSet();
   		
   		int itemIdx = 0;
   		model.addAttribute("itemIdx", itemIdx);
   		model.addAttribute("countryInfo", service.countryCategory(country));
   		model.addAttribute("categoryInfo", categoryInfo);
   		model.addAttribute("country", country);
   		
   		return "manager/item/hotelRegister";
   	}
   	
   	//아이템 등록 취소하고 목록으로
   	@PreAuthorize("hasAuthority('admin')")
   	@GetMapping("/cancelInsert")
   	public String cancelInsert(@RequestParam("itemIdx") int itemIdx) {
   		log.info("controller cancelInsert...");
   		
   		return "manager/item/itemList3#";
   	}
   	
   	//아이템 등록할 때 숙소 객실 추가하기
   	@PreAuthorize("hasAuthority('admin')")
   	@PostMapping("/hotelRoomInsert")
   	@ResponseBody
   	public Map<String, Object> hotelRoomInsert(@RequestBody HotelDetailVO hdvo){
   		log.info("controller hotelRoomInsert...");
   		System.out.println(hdvo);
   		Map<String, Object> result = service.hotelRoomInsert(hdvo);  		
   		return result;
   	}
   	
   	//아이템 등록할 때 숙소 객실 삭제하기
   	@PreAuthorize("hasAuthority('admin')")
   	@PostMapping("/hotelRoomDelete")
   	@ResponseBody
	public Map<String, Object> hotelRoomDelete(@RequestBody Map<String, String> inputData){
   		
   		log.info("controller hotelRoomDelete...");
   		int hotelIdx = Integer.parseInt(inputData.get("hotelIdx"));
   		int itemIdx = Integer.parseInt(inputData.get("itemIdx"));
   		
   		Map<String, Object> result = service.hotelRoomDelete(hotelIdx, itemIdx);
   		
   		return result;
   	}
   	
   	//모든 숙소 객실 삭제하기
   	@PreAuthorize("hasAuthority('admin')")
   	@PostMapping("/allRoomDelete")
   	@ResponseBody
   	public Map<String, Object> allRoomDelete(@RequestParam("itemIdx") int itemIdx){
   		
   		log.info("controller allRoomDelete...");
   		//int itemIdx = Integer.parseInt(inputData.get("itemIdx"));
   		
   		Map<String, Object> result = service.allRoomDelete(itemIdx);
   		
   		return result;
   	}
   	
   	//이미지 파일 업로드
   	@PreAuthorize("hasAuthority('admin')")
   	@PostMapping(value = "/uploadItemImage", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<AttachFileDTO> uploadAjaxPost(MultipartFile[] uploadFile) {

		log.info("upload");
		
		AttachFileDTO fileDTO = new AttachFileDTO();
		
		
		String uploadFolder = "C:\\dev\\project_team3\\worldFinder\\src\\main\\webapp\\resources\\img";
		
		//make folder
		File uploadPath = new File(uploadFolder);

		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("-------------------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			
			
			UUID uuid = UUID.randomUUID();	//랜덤 값 부여 객체 => 파일 이름을 다르게 만듦
			
			String uploadFileName = uuid.toString() + "_" + multipartFile.getOriginalFilename();
						
			
			try {
				File saveFile = new File(uploadFolder, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				fileDTO.setFileName(multipartFile.getOriginalFilename());
				fileDTO.setUuid(uuid.toString());
				//fileDTO.setUploadPath(getFolder());
				
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
	
		return new ResponseEntity<>(fileDTO, HttpStatus.OK);
		
	}
   	
   	//아이템 등록하기
   	@PreAuthorize("hasAuthority('admin')")
   	@PostMapping("/realItemInsert")
   	public String realItemInsert(ItemVO ivo, RedirectAttributes attr) {
   		
   		log.info("controller realItemInsert...");
   		service.realItemInsert(ivo);
   		attr.addAttribute("country", ivo.getCountry());
   		return "redirect:/manager/item/itemList3";
   	}
   	
	//아이템 삭제하기
   	@PreAuthorize("hasAuthority('admin')")
	@PostMapping("/deleteItem")
	public String deleteItem(@RequestParam("idx") int itemIdx,
			@RequestParam("country") String country,
			RedirectAttributes attr) {
		
		log.info("controller deleteItem...");
		service.removeItem(itemIdx);
		
		attr.addAttribute("country", country);
		return "redirect:/manager/item/itemList3";
	}
	
   	//아이템 수정 페이지로
   	@PreAuthorize("hasAuthority('admin')")
	@PostMapping("/updateItem")
	public String updateItem(@RequestParam("idx") int itemIdx, Model model) {
		
		log.info("controller updateItem...");
		model.addAttribute("itemInfo", service.getItemWithIdx(itemIdx));
		return "manager/item/hotelUpdate";
	}
	
   	//아이템 수정 페이지에서 객실 정보 가져오기
   	@PreAuthorize("hasAuthority('admin')")
	@PostMapping("/getOnehotelDetail")
	@ResponseBody
	public HotelDetailVO getOnehotelDetail(@RequestParam("item_idx") int item_idx,
										@RequestParam("hotel_idx") int hotel_idx) {
		
		log.info("controller getOnehotelDetail...");
		HotelDetailVO hvo = service.getOnehotelDetail(item_idx, hotel_idx);
		
		return hvo;
	}
   	
   	//아이템 수정 페이지에서 객실 정보 수정하기
   	@PreAuthorize("hasAuthority('admin')")
	@PostMapping("/updateRoom")
	@ResponseBody
	public String updateRoom(@RequestBody HotelDetailVO hdvo) {
		
		log.info("controller updateRoom...");
		service.updateRoom(hdvo);
		return "1";
	}
   	
//   	//아이템 리스트로 이동 (redirect용)
//   	@GetMapping("/itemList3Get")
//   	public String itemList3Get() {
//   		return "manager/item/itemList3#";
//   	}
	
	//나라페이지, 아이템 상세페이지에서 목록으로 이동 (기존 검색 정보 가지고감)
	@PostMapping("/itemList3")
	public String toList3Get(Model model, ItemFilterConVO icvo) {
		
		
		log.info("controller itemList3Get...");
		
		
		System.out.println("setCountry: " + icvo);
		
		model.addAttribute("itemInfo", icvo);
		if(icvo.getCountry() != null || !icvo.getCountry().equals("")) {
			model.addAttribute("country", service.countryCategory(icvo.getCountry()));
		}
		return "manager/item/itemList3";
	}
	
	//숙소의 모든 객실 정보 가져오기
	@PreAuthorize("hasAuthority('admin')")
	@PostMapping("/getAllHotelRoom")
	@ResponseBody
	public List<HotelDetailVO> getAllHotelRoom(@RequestParam("item_idx") int item_idx){
		return service.getAllHotelRoom(item_idx);
	}
	
	//아이템 수정하기
	@PreAuthorize("hasAuthority('admin')")
	@PostMapping("/refreshItem")
	public String updateItem(ItemVO ivo, RedirectAttributes attr) {
		
		log.info("controller updateItem...");
		service.oneItemUpdate(ivo);
		
		attr.addAttribute("country", ivo.getCountry());
		return "redirect:/manager/item/itemList3";
	}
	
	//=======================카카오페이 연동 컨트롤러========================================
	
	
	@PostMapping("/toKakaoPay")
	public String toKakaoPay(UserOrderVO uovo, RedirectAttributes attr) {
		
		log.info("controller toKakaoPay...");
		System.out.println("uovo : " + uovo);
		attr.addAttribute("country", "대한민국");
		return "redirect:/manager/item/itemList3";
	}
	
	//=================================================================================
	
	
}
