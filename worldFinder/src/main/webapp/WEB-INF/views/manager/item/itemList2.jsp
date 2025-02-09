<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.itemList table{	/* 테이블 가운데 정렬 */
		margin: auto;
	}
	
	.page-btn{	/* 페이지 이동 버튼 */
		list-style: none;
		background-color: black;
		font-size: 1.5em;
		float: left;
		margin-right: 20px;
		border: solid black 1px;
		color: white;
		text-decoration-line: none;
	}
	
	.mapDetailButton{
		background-color: yellow;
		z-index: 3;
		position: relative;
		top: -160px;
		left: 5px;
	}
	.detail{	/* detial 클릭시 나오는 자세한 지도 */
		margin: auto;
		width: 90%;
		height: 600px;
	}
	#detailMap{
		display: none;
	}
	th, td{
		border: solid black 1px;
	}
	
	.itemList #serachFilter{	/* 검색 필터랑 등록하기 버튼 공간 */
		width: 800px;
		margin: auto;
	}
	
	.disable{
		background-color: white;
		color: black;
		width: 100px;
		height: 30px;
	}

	.able{
		background-color:black;
		color:white;
		width: 100px;
		height: 30px;
	}
	
	/* 상제 지도를 띄우는 modal창 */
	#modalMap {	
	  position: fixed;
	  z-index: 999;
	  left: 0;
	  top: 0;
	  width: 100%;
	  height: 100%;
	  overflow: hidden;
	  background-color: rgba(0, 0, 0, 0.4);
	  display: none;
	}
	.modalMap-content {
	  background-color: #fefefe;
	  margin: 2% auto;
	  padding: 20px;
	  border: 1px solid #888;
	  width: 70%;
	}
	.closeMap {
	  color: #aaa;
	  float: right;
	  font-size: 28px;
	  font-weight: bold;
	}
	.closeMap:hover,
	.closeMap:focus {
	  color: black;
	  text-decoration: none;
	  cursor: pointer;
	}

</style>

<!-- jQuery 사용 설치 파일 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- 구글 맵 api 사용 설치 파일 -->
<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDMR_wbRSxhUfjlmG_Pbk6OHjr6mJvgkMI"></script>

<!-- 부트스트랩 달력 사용 설치 파일 -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<!-- <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> -->
<script src="../../resources/js/datapicker.js"></script>


</head>
<body>
	<h1>item 페이지</h1>
	
<!-- 	CREATE TABLE item_table3 (
   ITEM_IDX   NUMBER   primary key,
   country   VARCHAR2(50)   references c_class_table3(country),
   item_Name   VARCHAR2(50)   NOT NULL,
   regdate   date   DEFAULT sysdate,
   introduce   VARCHAR2(200)   NOT NULL,
   image   VARCHAR2(50)   NOT NULL,
   address   VARCHAR2(100)   NOT NULL,
   item_Category   VARCHAR(255)   NOT NULL,
   people   NUMBER   NOT NULL,
   price   NUMBER,
   tel   varchar2(30)   NOT NULL,
   item_Option   VARCHAR2(20),
   item_Url   varchar2(50)
); -->
	

	<div class = "itemList" id="wholeDiv">
		<div id="serachFilter">
			<input type="button" value="등록하기" style="float: right;"><br><br>
			
			<select name='country' id="country">
			  <option value='' selected>-- 선택 --</option>
			  <option value='대한민국'>대한민국</option>
			  <option value='일본'>일본</option>
			</select>
			
			<br><br>
			
			<button id="spotAble" class="disable">관광지</button>
			<button id="hotelAble" class="disable">숙소</button><br><br>
			
			날짜 
			<label>Start Event <input type="text" id="datepickerStart" class="startEvent" value="" readonly="readonly"></label>
			<label style="display: none" class="endDay">End Event <input type="text" id="datepickerEnd" class="endEvent"></label>
			<br>
			인원	<input type="number" id="peopleNum" value="1">명
			<br>
			<button class="filterReset">필터초기화</button>
			
		</div>
		
		<br><hr><br>
	
		<table style="border: solid black 1px;">
			<tbody id="itemTbody">
			</tbody>
			<tfoot id="itemPgaeButton">
			</tfoot>
		</table>
		
	</div>
	
	<div id="modalMap">
		<div class="modalMap-content">
			<h3>자세한 지도</h3>
  				<div class="detail" id="randomMap"></div>
			<button id="close-modalMap">닫기</button>
		</div>
	</div>
	
	
	
<!-- onload -->
<script type="text/javascript">
	$(function(){
		var itemFilter = new Object();	//검색 필터 정보 요소
		itemFilter.people = '1';	//인원수는 기본값이 1이므로 미리 추가
		itemFilter.country = '';
		itemFilter.category = '';
		itemFilter.startDay = '';
		itemFilter.endDay = '';
		itemFilter.page = '1';
		
		ajaxItemList(1);	            
	});	
</script>

<!-- 본문 글 삽입 + 페이징 (ajax 비동기 처리)  -->
<script type="text/javascript">	

	//비동기 처리 리스트 불러오기 
	function ajaxItemList(page){
		$.ajax({
	         url : '/manager/item/ajaxItemList',         
	         type : 'GET',
		         data : {
	              'page' : page
	          }, 
	         dataType:"json",
	         async: "false",
	         success : function(data) {
	        	 
	            var str = '';		//상품 리스트 본문
	            var strPage= '';	//페이지 버튼
				
	            var list = data.list;
	            var page = data.page;
	            var startpage = data.startpage;
	            var endpage = data.endpage;
	              
				//본문 아이템 리스트
				$.each(data.list, function(index, item) {
	
					//상품 이미지 삽입
					str += "<tr>";
					str += '<td><img src="../../resources/img/'+ item.image +'.jpg" width="200px" height="160px"/></td>';
	               
					//상품 정보
					str += '<td width="600px"><ul>';
					str += '<li>'+ item.item_Name +'</li>';
					str += '<li>'+ item.address +'</li>';
					str += '<li>'+ item.price +'</li>';
					str += '</ul></td>';    
					
					//구글맵 api 삽입
					str += '<td>';
					str += '<div class="' + item.item_Idx + '" style="width: 200px; height: 160px;">';
					str += '<div id="' + item.item_Idx + '" class="map" ad="' + item.address + '"';
					str += 'tel="' + item.tel + '" name="' + item.item_Name + '"';
					str += 'style="width: 200px; height: 160px; z-index: 2;"></div>';
					str += '<input type="button" value="detail" class="mapDetailButton" id="' + item.item_Idx + '"';
					str += 'ad="' + item.address + '" tel="' + item.tel + '" name="' + item.item_Name + '">';
					
					str += '</div>';
					str += '</td>';
	               
					str += "</tr>";
	            	  
				});
	              
				//페이징 처리 ajax 부분
	            for (var num=startpage; num<=endpage; num++) {
	            	if (num == page) {
	            		strPage += '<a href = "#" onclick="ajaxItemList(' + num + ')"; return false;" class="page-btn">' + num + '</a>';
	                } else {
	                	strPage += '<a href = "#" onclick="ajaxItemList(' + num + ')"; return false;" class="page-btn">' + num + '</a>';
	            	}
	            }
	            $('#itemTbody').html(str);
	            $('#itemPgaeButton').html(strPage); 
	            
	            //본문 내용을 불러온 후 구글맵 api 생성
				initialize();
	           
	         }
	      });
	}

</script>

<!-- 구글맵 api -->
<script type="text/javascript">

	
	function initialize() {
		
		var maps = [];
		var markers = [];
	    var mapOptions = {
	                        zoom: 15, // 지도를 띄웠을 때의 줌 크기
	                        disableDefaultUI:true,	//컨트롤러 제거
	                        mapTypeId: google.maps.MapTypeId.ROADMAP
	                    };
	        
	    
	    var $maps = $('.map');
	    console.log($maps);
	    
	    $.each($maps, function (i, value) {
	    
	    	//구글맵 div 에서 받아온 요소 정의
	    	var name = $(value).attr('name');
	    	var ad = $(value).attr('ad');
	    	var tel = $(value).attr('tel');
	    	var idx = $(value).attr('id');
	    	
	    	
	    	makeMap(name, ad, tel, idx, mapOptions);
	    
		});
	}
	
	
	/* 주소 입력받아 지도 만드는 함수 */
	function makeMap(name, ad, tel, idx, mapOptions){
		
		var size_x = 10; // 마커로 사용할 이미지의 가로 크기
        var size_y = 10; // 마커로 사용할 이미지의 세로 크기
     
        // 마커로 사용할 이미지 주소
        var image = new google.maps.MarkerImage( '../../resources/img/marker.png',
                                                    new google.maps.Size(size_x, size_y),
                                                    '',
                                                    '',
                                                    new google.maps.Size(size_x, size_y));
		
		var map = new google.maps.Map(document.getElementById(idx), // div의 id과 값이 같아야 함. "map-canvas"
                mapOptions);


		// Geocoding *****************************************************
		var address = ad; // DB에서 주소 가져와서 검색하거나 왼쪽과 같이 주소를 바로 코딩.
		var marker = null;
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode( { 'address': address}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				map.setCenter(results[0].geometry.location);
				marker = new google.maps.Marker({
				                map: map,
				                icon: image, // 마커로 사용할 이미지(변수)
				                title: name, // 마커에 마우스 포인트를 갖다댔을 때 뜨는 타이틀
				                position: results[0].geometry.location
				            });
			
			var content = "" + name + "<br/><br/>Tel: " + tel; // 말풍선 안에 들어갈 내용
			
			// 마커를 클릭했을 때의 이벤트. 말풍선 뿅~
			var infowindow = new google.maps.InfoWindow({ content: content});
			google.maps.event.addListener(marker, "click", function() {infowindow.open(map,marker);});
			} else {
				alert("Geocode was not successful for the following reason: " + status);
			}
		});
			// Geocoding // *****************************************************
		
	}
	

</script>

<!-- detail 구글맵 modal -->
<script type="text/javascript">

	const modalMap = $("#modalMap");
	const closeModalMapBtn = $("#close-modalMap");
	
	
	//detail 클릭 시 자세한 지도를 보여주는 modal창 띄우기
	$(document).on('click', ".mapDetailButton", function(){
		
		modalMap.show();
		document.body.style.overflow = "hidden"; // 스크롤바 제거
		
		//상세 지도 보이기
		var mapOptions = {
	            zoom: 15, // 지도를 띄웠을 때의 줌 크기
	            mapTypeId: google.maps.MapTypeId.ROADMAP
	        };
		
		
		var idx = $(this).attr('id') + "detail";	
		var name = $(this).attr('name');
		var tel = $(this).attr('tel');
		var ad = $(this).attr('ad');
		
		document.querySelector('.detail').setAttribute("id", idx);
		
		makeMap(name, ad, tel, idx, mapOptions);
		
	});
	// 모달창 닫기
	$(closeModalMapBtn).on('click', function(){
		modalMap.hide();
	  	document.body.style.overflow = "auto"; // 스크롤바 보이기
	});
	$(document).mouseup(function (e){

		if(modalMap.has(e.target).length === 0){
			modalMap.hide();
			document.body.style.overflow = "auto"; // 스크롤바 보이기
		}

	});
	
	
	//지도에 마우스 올리고 있을 때 ctrl 누르고 있는 상태로 설정
	/* $(".detail").mouseover(function(){
		console.log("마우스오버");
		var e = jQuery.Event("keydown", {keyCode : 17});
		$(this).trigger(e);
	});
	$(".detail").mouseout(function(){
		console.log("마우스리브");
	});
	 */
	
	
</script>

<!-- 검색 (필터) 관련 -->
<script type="text/javascript">

	//날짜선택 캘린더 스크립트
	$(function() {

		//input을 datepicker로 선언
		$("#datepickerStart, #datepickerEnd").datepicker({
		    dateFormat: 'yy-mm-dd' //달력 날짜 형태
		    ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		    ,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
		    ,changeYear: true //option값 년 선택 가능
		    ,changeMonth: true //option값  월 선택 가능                
		    ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
		    ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
		    ,buttonImageOnly: true //버튼 이미지만 깔끔하게 보이게함
		    ,buttonText: "선택" //버튼 호버 텍스트              
		    ,yearSuffix: "년" //달력의 년도 부분 뒤 텍스트
		    ,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
		    ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
		    ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 텍스트
		    ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip
		    ,minDate: "0D" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		    ,maxDate: "+1M" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)
			,beforeShowDay: disableAllTheseDays 
		});
		
		
		// 특정일 배열(선택 비활성화)
	   	//var disabledDays = ["2023-8-1","2023-7-27","2023-8-12"];
   		var disabledDays = [];
	   	// 특정일 선택 막기
	   	function disableAllTheseDays(date) {
	   	    var m = date.getMonth(), d = date.getDate(), y = date.getFullYear();
	   	    for (i = 0; i < disabledDays.length; i++) {
	   	        if($.inArray(y + '-' +(m+1) + '-' + d,disabledDays) != -1) {
	   	            return [false];
	   	        }
	   	    }
	   	    return [true];
	   	}
	    
       //날짜 초기값 설정
       //$('#datepicker').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
		
		
	});
	
	
	
	
	
	$(function(){
		
		var itemFilter = new Object();	//검색 필터 정보 요소
		itemFilter.people = '1';	//인원수는 기본값이 1이므로 미리 추가
		itemFilter.country = '';
		itemFilter.category = '';
		itemFilter.startDay = '';
		itemFilter.endDay = '';
		
		
		
		//검색 필터에 나라정보 삽입
		$("#country").change(function(){
			itemFilter.country = $(this).val();
		});
		
	
		//검색 필터에 카테고리 정보 삽입
		$("#spotAble").on('click', function(){
			
			
			if($('#hotelAble').attr('class') == 'able'){
				$('#hotelAble').attr('class', 'disable');
			}
			
			if($(this).attr('class') == 'able'){
				$(this).attr('class', 'disable');
				itemFilter.category = null;
			}
			else{
				$(this).attr('class', 'able');
				itemFilter.category = 'spot';
			}
			
			$(".endDay").hide();
			itemFilter.endDay = "";
		});
		
		$("#hotelAble").on('click', function(){
			if($('#spotAble').attr('class') == 'able'){
				$('#spotAble').attr('class', 'disable');
			}
			
			if($(this).attr('class') == 'able'){
				$(this).attr('class', 'disable');
				$(".endDay").hide();
				$(".endEvent").val("");
				itemFilter.category = null;
			}
			else{
				$(this).attr('class', 'able');
				$(".endDay").show();
				itemFilter.category = 'hotel';
			}
			
	
		});
		
		
		//검색 필터에 시작일, 종료일 정보 삽입
		var startDay = $(".startEvent");
		var endDay = $(".endEvent");
			
		
		$(endDay).change(function(){	//숙소 체크아웃 날짜 선택시 시작일 이전날짜는 선택 제한
			if($(this).val() < $(startDay).val()){
				alert("시작일보다 빠른 날짜를 선택일 수 없습니다.");
				$(this).val("");
			}
			itemFilter.endDay = $(this).val();
		
		});
		
		$(startDay).change(function(){	//숙소 체크인 날짜 선택시 종료일보다 늦는 날 선택 불가
			if(($(endDay).val() != "") && ($(this).val() > $(endDay).val())){
				alert("종료일보다 늦은 날짜를 선택할 수 없습니다.");
				$(this).val("");
			}
			itemFilter.startDay = $(this).val();
		});
		
		//검색 필터에 인원수 정보 삽입
		$("#peopleNum").change(function(){
			var peopleNum = $(this).val();
			
			if(isNaN(peopleNum) || peopleNum == "" || peopleNum <= 0){
				alert("올바르지 않은 형식입니다.");
				$(this).val("1");
			}
			
			itemFilter.people = $(this).val();			
		});
		
		//필터초기화 버튼 클릭시
		$(".filterReset").click(function(){
			$("#hotelAble, #spotAble").attr('class', 'disable');
			$(".endDay").hide();
			
			$("#country").val("");
			$(".startEvent").val("");
			$(".endEvent").val("");
			$("#peopleNum").val("1");
			
			itemFilter.people = '1';	//인원수는 기본값이 1이므로 미리 추가
			itemFilter.country = '';
			itemFilter.category = '';
			itemFilter.startDay = '';
			itemFilter.endDay = '';
		});
	
		
		
	});
</script>

</body>
</html>