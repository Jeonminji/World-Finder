package org.worldfinder.mapper;

import org.apache.ibatis.annotations.Param;
import org.worldfinder.domain.*;

import java.nio.channels.Pipe;
import java.util.List;
import java.util.Map;

public interface MainMapper {
    // 대륙 세부대륙 나라 가져오기
    public List<CountryClassVO> readCountry();
    // 건의사항 입력
    public int writeRequest(RequestVO vo);
    // 신고내역 가져오기
    public  List<ReportVO> readUserReport(Criteria cri);
    // 댓글 신고내역 가져오기
    public  List<ReportVO> readCommentReport(Criteria cri);
    // 건의사항 가져오기
    public  List<RequestVO> readRequest(Criteria cri);
    //     대륙, 세부대륙 가져오기
    public  List<CountryClassVO> readContinent();
    // 특정 대륙 나라 가져오기
    public  List<Map<String,String>> countryList(String details_continet);
    //나라 페이지 내용 인설트하기
    public int writeCountry(CountryVO vo);
    // 나라 메인페이지 가져오기
    public CountryVO readCountryPage(String country);
    
    // 필터에 필요한값 가져오기
    public  List<Map<String,String>> readfilter(@Param("filterValue") String filterValue , @Param("category") String category);

    // 페이지 카운트 세기
    public  int getTotalCount( @Param("category") String category);

    // 나라 페이지 업데이트
    public int countryModify(CountryVO vo);
    // 이미 작성한 나라게시글 가져오기
    public List<Map<String,String>> clearCountList();

    // 나라게시글 삭제
    public  int deleteCountry(String country);

    // 세부대륙 검색 결과 가져오기
    public  List<String> countrySearch(String details_continent);

    public List<UserPostVO> userPostSample(String country);


    public UserPostVO repPost(long idx);
    public CommentVO repComment(long idx);
    public NestedCVO repNestedC(long idx);

    public List<Map<String,String>> repReason(ReportVO vo);
    // 블라인드
    public int blind(ReportVO vo);
    // 블라인드
    public int removeReport(ReportVO vo);
}
