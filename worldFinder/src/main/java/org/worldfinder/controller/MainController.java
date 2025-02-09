package org.worldfinder.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.worldfinder.domain.*;
import org.worldfinder.service.MainService;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Log4j
@Controller
public class MainController {

	@Setter(onMethod_ = @Autowired)
	private MainService service;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String mainPage(Model model) {
		List<CountryClassVO> country = service.readCountry();

//		Gson gson = new Gson();
//
//		String test = gson.toJson(country);
//
//
//
//		model.addAttribute("country", test);

		return "main/index";
	}
	// 건의사항 페이지 처리
	@GetMapping("/request")
	public String requestPage() {
		return "main/request";
	}

	@PostMapping("/request")
	public String requestData(RequestVO vo, Model model) {

		int result = service.writeRequest(vo);

		model.addAttribute("result", result);

		return "main/request_clear";
	}
	// 관리자 페이지 이동
	@GetMapping("/adminPage")
	public String adminPage(Model model, Criteria cri) {

//		model.addAttribute("request", service.readRequest(cri));
//		model.addAttribute("reqPageMaker", new PageDTO(cri, service.getTotalCount()));
		return "main/admin";
	}

// 나라 메인페이지
	@GetMapping("/country/{country}")
	public String country(@PathVariable String country,Model model) {

		model.addAttribute("countryPage",service.readCountryPage(country));
		model.addAttribute("reCountry",country);
		model.addAttribute("userPostSample",service.userPostSample(country));

		return "country/country";
	}
	// 나라 페이지 수정
	@GetMapping("/country/modify/{country}")
	public String countryModify(@PathVariable String country,Model model) {

		model.addAttribute("countryPage",service.readCountryPage(country));
		model.addAttribute("reCountry",country);

		return "country/countryModify";
	}
	// 나라 작성페이지
	@GetMapping("/countryWrite")
	public String countryWrite(Model model) {

		List<CountryClassVO> vos = service.readContinent();

		Gson gson = new Gson();

		String cont = gson.toJson(vos);

		model.addAttribute("cont", cont);
		model.addAttribute("clearCountry", gson.toJson(service.clearCountList()));


		return "country/countryWrite";
	}

	// 세부대륙 검색결과 가져오기
	@GetMapping("/countrySearch/{details_continent}")
	public  String countrySearch(Model model, @PathVariable String details_continent) {

		model.addAttribute("countryList",service.countrySearch(details_continent));
		model.addAttribute("details_continent",details_continent);

		return "country/countrySearch";
	}




	// --------------AJAX 처리---------------------
	// 나라 게시글 수정
	@PostMapping(value = "/country/modify" , produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String countryModify(CountryVO vo) {
		log.info(vo.getCountry());
		String result = Integer.toString(service.countryModify(vo));
		log.info("data : " + result);
		return result;
	}
	// 나라 게시글 작성
	@PostMapping("/countryWrite")
	@ResponseBody
	public String countryWrite(CountryVO vo) {
		log.info(vo.getCountry());
		String result = Integer.toString(service.writeCountry(vo));
		log.info("data : " + result);
		return result;
	}


	@PostMapping(value = "/adminPage/getRequest/{pageNum}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String,Object> adminRequest(@PathVariable String pageNum) {

		Criteria cri = new Criteria();
		cri.setPageNum(Integer.parseInt(pageNum));

		Map<String,Object> map = new HashMap<>();

		map.put("requestVO",service.readRequest(cri));
		map.put("reqPageMaker", new PageDTO(cri, service.getTotalCount("request")));

		return map;
	}


	// 나라 게시글 삭제
	@DeleteMapping(value = "/country/modify" , produces = MediaType.TEXT_PLAIN_VALUE,
			consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String deleteCountry(@RequestBody CountryVO vo){
		// 이미지 삭제
		log.info("url : " + vo.getC_img());

		File file = null;
		try {
			file = new File("c:\\upload\\countryMain\\" + URLDecoder.decode(vo.getC_img(),"utf-8"));
			file.delete();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return Integer.toString(service.deleteCountry(vo.getCountry()));

	}



	// ajax 로 데이터 받는 애들
	@PostMapping(value = "/adminPage/getReport/{category}/{pageNum}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String,Object> adminReport(@PathVariable String category, @PathVariable String pageNum) {

		Criteria cri = new Criteria();
		cri.setPageNum(Integer.parseInt(pageNum));
		log.info("check");


		Map<String,Object> map = new HashMap<>();
		map.put("reportVO",service.readReport(category,cri));
		log.info("check1");
		map.put("reqPageMaker", new PageDTO(cri, service.getTotalCount(category)));
		log.info("check2");
		log.info(map.toString());

		return map;

	}

	// 나라 불러오기
	@GetMapping(value = "/logoSeach", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<CountryClassVO> logoSearch() {

		return service.readCountry();
	}

	@PostMapping(value = "/countryWrite/countryList/{details_continent}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<Map<String, String>> countryList(@PathVariable String details_continent) {

		List<Map<String, String>> result = service.countryList(details_continent);


		return result;
	}
	// 필터 값 가져오기
	@PostMapping(value = "/filter/{filterValue}/{category}" , produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<Map<String,String>> filterAjax(@PathVariable String filterValue , @PathVariable String category){

		String values;
		if (category.equalsIgnoreCase("detail_c")){
			values = "DETAILS_CONTINENT";
		} else {
			values = "COUNTRY";
		}


		List<Map<String,String>> map = service.readfilter(filterValue,values);
		return map;

	}

	
	// 이미지 저장
	@PostMapping(value = "/country/imgAjax", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String, String> uploadAjaxAction(MultipartFile uploadFile) {
		log.info("uploadAjaxAction --");


		String uploadFolder = "c:\\upload";

		File uploadPath = new File(uploadFolder, "countryMain");
		log.info("upload path : " + uploadPath);

		if (uploadPath.exists() == false) { // uploadPath 형태의 파일이 없을 경우
			uploadPath.mkdirs(); // 디랙토리(파일) 생성
		}

		log.info("----------------------------");
		log.info("upload File Name : " + uploadFile.getOriginalFilename());
		log.info("upload File Size : " + uploadFile.getSize());

		UUID uuid = UUID.randomUUID();

		String uploadFileName = uuid.toString() + "_" + uploadFile.getOriginalFilename();

		try {
			File saveFile = new File(uploadPath, uploadFileName);
			uploadFile.transferTo(saveFile);

		} catch (Exception e) {
			log.error(e.getMessage());
		}
		Map<String, String> result = new HashMap<>();

		result.put("c_img", uploadFileName);

		return result;

	}

	// 파일 보여주기
	@GetMapping( value = "/country/viewImg")
	public ResponseEntity<Resource> viewImg(@RequestParam String filename){
		String path = "c:\\upload\\countryMain\\";

		Resource resource = new FileSystemResource(path + filename);

		if (!resource.exists()){
			return  new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}

		HttpHeaders headrs = new HttpHeaders();
		Path filePath = null;

		try {
			filePath = Paths.get(path + filename);
			headrs.add("Content-Type" , Files.probeContentType(filePath));
		} catch (IOException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<Resource>(resource, headrs, HttpStatus.OK);
	}


	//신고 게시글, 댓글 가져오기
	@PostMapping(value = "/admin/repPost", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String repPost(@RequestBody ReportVO rVo) {

		return service.repPost(rVo);
	}

	//신고 사유 가져오기
	@PostMapping(value = "/admin/repReason", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String repReason(@RequestBody ReportVO rVo) {

		return service.repReason(rVo);
	}

	//blind 처리
	@PostMapping(value = "/admin/blind", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String blind(@RequestBody ReportVO rVo) {

		return service.blind(rVo);
	}
}