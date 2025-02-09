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
	.pagination{	/* 페이징 버튼 css (ul) */
		list-style: none;
	}
	.pagination li{	/* 페이징 버튼 css (li) */
		background-color: black;
		font-size: 1.5em;
		float: left;
		margin-right: 20px;
		border: solid black 1px;
	}
	.pagination li a{	/* 페이징 버튼 css (a) */
		color: white;
		text-decoration-line: none;
	}

/* 구글맵에 마우스 오버시 지도 확대	
	.map {								
	  transition: all 0.2s linear;
	  z-index: 1;
	  width: 200px;
	  height: 160px;
	}
	.map:hover {
		position: absolute;
		z-index: 2;
		transform: scale(2);
 	 	width: 400px;
		height: 400px; 
		position: fixed; 
	} */
	
	.mapDetailButton{
		background-color: yellow;
		z-index: 3;
		position: relative;
		top: -160px;
		left: 5px;
	}
	.detail{	/* detial 클릭시 나오는 자세한 지도 */
		margin: auto;
		width: 1000px;
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
			
			<button id="spotAble" class="disable">관광지</button>
			<button id="hotelAble" class="disable">숙소</button><br><br>
			
			날짜 
			<label>Start Event <input type="text" id="datepickerStart" class="startEvent" value=""></label>
			<label style="display: none" class="endDay">End Event <input type="text" id="datepickerEnd" class="endEvent"></label>
			<button class="reset">필터초기화</button>
			<br>
			인원	<input type="number">명
			
		</div>
		
		<br><hr><br>
	
		<table style="border: solid black 1px;">
			<tbody>
				<c:forEach var="item" items="${list }">
					<tr>
						<td>	<!-- 상품 이미지 삽입 -->
							<img src="../../resources/img/${item.image }.jpg" width="200px" height="160px"/>
						</td>
						<td width="600px">	<!-- 상품에 대한 정보 (이름, 가격 등) -->
							<ul>
								<li>${item.item_Name }</li>
								<li>${item.address }</li>
								<li>${item.price }</li>
							</ul>
						</td>
						<td>	<!-- 구글맵 api -->
						<div class="${item.item_Idx }" style="width: 200px; height: 160px;">
							<div id="${item.item_Idx }" class="map" ad="${item.address }" tel="${item.tel }" name="${item.item_Name }"
							style="width: 200px; height: 160px; z-index: 2;">
							</div>
							<input type="button" value="detail" class="mapDetailButton" id="${item.item_Idx }"
							ad="${item.address }" tel="${item.tel }" name="${item.item_Name }">
						</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr><td colspan="4">
				   <ul class="pagination">
				      <c:if test="${pageMaker.prev }">
				         <li class="paginate_button previous">
				            <a href="${pageMaker.startPage-1 }">&lt;</a>
				         </li>
				      </c:if>
				      <c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }" step="1">
				         <li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : '' }">   
				            <a href="${num }">${num }</a>
				         </li>
				      </c:forEach>
				      <c:if test="${pageMaker.next }">
				         <li class="paginate_button">
				            <a href="${pageMaker.endPage+1 }">&gt;</a>
				         </li>
				      </c:if>
				   </ul>
				</td></tr>
			</tfoot>
		</table>
		
		
		
		
		<form action="/manager/item/itemList" method="get" id="actionForm">
			<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
			<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		</form>
		
	</div>
	
	<div id="detailMap">
		<h3>자세한 지도</h3>
		<div class="detail" id="randomMap"></div>
		<input type="button" value="돌아가기" id="backList" style="float: right;">
	</div>
	
<!-- 페이징 처리 스크립트 -->
<script type="text/javascript">
	var actionForm = $("#actionForm"); //폼태그 정보 가져오기

	//페이징 버튼 이벤트 처리
	$(".paginate_button a").on('click', function(e){
		e.preventDefault();
		
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
</script>

<!-- 구글맵 api 스크립트 ********************************************* -->
<script type="text/javascript">

	var maps = [];
	var markers = [];
	
    function initialize() {

    	
        var mapOptions = {
                            zoom: 15, // 지도를 띄웠을 때의 줌 크기
                            disableDefaultUI:true,	//컨트롤러 제거
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };
            
        
        var $maps = $('.map');
        
        
        $.each($maps, function (i, value) {
        
        	//구글맵 div 에서 받아온 요소 정의
        	var name = $(value).attr('name');
        	var ad = $(value).attr('ad');
        	var tel = $(value).attr('tel');
        	var idx = $(value).attr('id');
        	
        	//console.log("lat: " + name + ad + tel);
        	
        	makeMap(name, ad, tel, idx, mapOptions);
        
    	});
    }

    google.maps.event.addDomListener(window, 'load', initialize);
    
    
</script>

<script type="text/javascript">


	//자세한 구글 맵을 보여주는 버튼
	$(".mapDetailButton").click(function(){
		
		$("#wholeDiv").hide();
		$("#detailMap").show();
		
		
        var mapOptions = {
                zoom: 15, // 지도를 띄웠을 때의 줌 크기
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
		
		
		var idx = $(this).attr('id') + "detail";	
		var name = $(this).attr('name');
		var tel = $(this).attr('tel');
		var ad = $(this).attr('ad');
		
		document.querySelector('.detail').setAttribute("id", idx);
		
		console.log($(".detail").attr("id"));
		
		makeMap(name, ad, tel, idx, mapOptions);
		
		
	});
	
	
	$("#backList").click(function(){
		$("#wholeDiv").show();
		$("#detailMap").hide();
	});
	


</script>

<script type="text/javascript">

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


<script type="text/javascript">

	//날짜선택 캘린더 스크립트
	 $(function() {
		 

		 
       //input을 datepicker로 선언
       $("#datepickerStart").datepicker({
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
       
       
       $("#datepickerEnd").datepicker({
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
           ,minDate: "0" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
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
	
	
       
       
       //초기값을 오늘 날짜로 설정해줘야 합니다.
       //$('#datepicker').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)            
   });

	
	//검색 필터 관련 자바스크립트	
	//<button id="spotAble" class="disable">관광지</button>
	//<button id="hotelAble" class="able">숙소</button><br><br>
	var category = null;
	
	$(function(){
		
	
	
		$("#spotAble").on('click', function(){
			
			
			if($('#hotelAble').attr('class') == 'able'){
				$('#hotelAble').attr('class', 'disable');
			}
			
			if($(this).attr('class') == 'able'){
				$(this).attr('class', 'disable');
			}
			else{
				$(this).attr('class', 'able');
			}
			
			$(".endDay").hide();
			
			categoey = 'spot';
	
		});
		
		$("#hotelAble").on('click', function(){
			if($('#spotAble').attr('class') == 'able'){
				$('#spotAble').attr('class', 'disable');
			}
			
			if($(this).attr('class') == 'able'){
				$(this).attr('class', 'disable');
				$(".endDay").hide();
				$(".endEvent").val("");
			}
			else{
				$(this).attr('class', 'able');
				$(".endDay").show();
			}
			
			category = 'hotel';
	
		});
		
		//Start Event <input type="text" id="datepickerStart" class="startEvent">
		//End Event <input type="text" id="datepickerEnd" class="endEvent">
		var startDay = $(".startEvent");
		var endDay = $(".endEvent");
			
		
		$(endDay).change(function(){	//숙소 체크아웃 날짜 선택시 시작일 이전날짜는 선택 제한
			if($(this).val() < $(startDay).val()){
				alert("시작일보다 빠른 날짜를 선택일 수 없습니다.");
				$(this).val("");
			}
		});
		
		$(startDay).change(function(){	//숙소 체크인 날짜 선택시 종료일보다 늦는 날 선택 불가
			if(($(endDay).val() != "") && ($(this).val() > $(endDay).val())){
				alert("종료일보다 늦은 날짜를 선택할 수 없습니다.");
				$(this).val("");
			}
		});
		
		$(".reset").click(function(){
			$(".startEvent").val("");
			$(".endEvent").val("");
		});
		

	
	});
		
</script>

<script type="text/javascript">

	//비동기 처리 리스트 불러오기
	function ajaxItemList(){
		$.ajax({
	           url : '/manger/item/ajaxItemList',
	           type : 'POST',
	           data : {
	              'board_id' : board_id,
	              'page' : pageNum
	          },
	           dataType:"json",
	           success : function(data) {
	              var a = '';
	              var page = data.page;
	              var startpage = data.startpage;
	              var endpage = data.endpage;
	              var boardList = data.boardList;

	              $.each(boardList, function(key, value) {
	                 console.log("data : " + boardList);
	                 console.log(boardList);
	                 console.log(page + "," + startpage + "," + endpage);
	                 console.log("start : " + startpage);
	                 console.log("end : " + endpage);
	                 a += '<div class="commentArea" style="boarder-bottom:1px solid darkgray; margin-bottom: 15px;">';
	                 a += '<div class="commentInfo'+value.board_re_id+'">'+'댓글번호 : '+value.board_re_id+' / 작성자 : '+value.mem_id;
	                 a += '<a onclick="commentUpdate('+value.board_re_id+',\''+value.board_re_content+'\');"> 수정 </a>';
	                 a += '<a onclick="commentDelete('+value.board_re_id+');"> 삭제 </a> </div>';
	                 a += '<div class="commentContent'+value.board_re_id+'"> <p> 내용 : '+value.board_re_content +'</p>';
	                 a += '</div></div>';
	              });
	              
	              for (var num=startpage; num<=endpage; num++) {
	                 if (num == page) {
	                      a += '<a href="#" onclick="commentList(' + board_id + ', ' + num + '); return false;" class="page-btn">' + num + '</a>';
	                 } else {
	                      a += '<a href="#" onclick="commentList(' + board_id + ', ' + num + '); return false;" class="page-btn">' + num + '</a>';
	                 }
	              }
	            $('.commentList').html(a);
	         }
	      });

	}
	

</script>

</body>
</html>