package org.worldfinder.service;

import com.google.gson.Gson;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.worldfinder.domain.*;
import org.worldfinder.mapper.MainMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Log4j
@Service
public class MainServiceImpl implements MainService {

    @Autowired
    private MainMapper mapper;

    @Override
    public List<CountryClassVO> readCountry() {
        return mapper.readCountry();
    }

    @Override
    public int writeRequest(RequestVO vo) {
        return mapper.writeRequest(vo);
    }

    @Override
    public List<ReportVO> readReport(String category , Criteria cri) {
        if (category.equalsIgnoreCase("comment")){
            return mapper.readCommentReport(cri);
        } else {
            return mapper.readUserReport(cri);
        }
    }

    @Override
    public List<RequestVO> readRequest(Criteria cri) {
        return mapper.readRequest(cri);
    }

    @Override
    public List<CountryClassVO> readContinent() {
        return mapper.readContinent();
    }

    @Override
    public List<Map<String,String>> countryList(String details_continet) {
        return mapper.countryList(details_continet);
    }

    @Override
    public int writeCountry(CountryVO vo) {
        return mapper.writeCountry(vo);
    }

    @Override
    public CountryVO readCountryPage(String country) {
        return mapper.readCountryPage(country);
    }

    @Override
    public List<Map<String, String>> readfilter(String filterValue, String category) {

        return mapper.readfilter(filterValue, category);
    }

    @Override
    public int getTotalCount(String category) {
        return mapper.getTotalCount(category);
    }

    // 나라 페이지 업데이트
    @Override
    public int countryModify(CountryVO vo){
        return mapper.countryModify(vo);
    }

    @Override
    public List<Map<String,String>> clearCountList() {
        return mapper.clearCountList();
    }

    // 나라게시글 삭제
    @Override
    public int deleteCountry(String country) {
        return mapper.deleteCountry(country);
    }

    // 세부대륙 검색 결과 가져오기
    @Override
    public  List<String> countrySearch(String details_continent){
        return mapper.countrySearch(details_continent);
    }

    @Override
    public List<UserPostVO> userPostSample(String country) {
        return mapper.userPostSample(country);
    }

    // 신고된 내용 가져오기
    public String repPost(ReportVO vo){
        Gson gson = new Gson();
        if (vo.getR_category().equalsIgnoreCase("post")){
            return gson.toJson(mapper.repPost(vo.getIdx()));
        } else if (vo.getR_category().equalsIgnoreCase("comment")){
            return gson.toJson(mapper.repComment(vo.getIdx()));
        } else {
            return gson.toJson(mapper.repNestedC(vo.getIdx()));
        }
    }

    @Override
    public String repReason(ReportVO vo) {
        Gson gson = new Gson();
        return gson.toJson(mapper.repReason(vo));
    }

    @Override
    public String blind(ReportVO vo) {
        Gson gson = new Gson();
        Map<String,Boolean> map = new HashMap<>();
        if (mapper.blind(vo) > 0){
            if (mapper.removeReport(vo) > 0){
                map.put("result",true);
            } else {
                map.put("result",false);
            }
        } else {
            map.put("result",false);
        }
        return gson.toJson(map);
    }

}
