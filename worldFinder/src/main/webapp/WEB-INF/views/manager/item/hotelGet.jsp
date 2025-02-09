<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri= "http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- jQuery 사용 설치 파일 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- 구글 맵 api 사용 설치 파일 -->
<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDMR_wbRSxhUfjlmG_Pbk6OHjr6mJvgkMI"></script>

<!-- 부트스트랩 달력 사용 설치 파일 -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="../../resources/js/datapicker.js"></script>


</head>
<body>
	<h1>HOTEL 상세 (예약) 페이지</h1>
	<button id="toItemList">목록으로</button>
	
	<div id="hotelImg"></div>
	<br>
	<div id="hotelDate">
		날짜 
		<c:choose>
			<c:when test="${itemInfo.startDay eq '1900-01-01'}"><label>체크인 <input type="text" id="datepickerStart" class="startEvent" value="" readonly="readonly" autocomplete="off"></label></c:when>
			<c:otherwise><label>체크인 <input type="text" id="datepickerStart" class="startEvent" value="${itemInfo.startDay }" readonly="readonly" autocomplete="off"></label></c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${itemInfo.endDay eq '1900-01-01'}"><label>체크아웃 <input type="text" id="datepickerEnd" class="endEvent" value="" readonly="readonly" autocomplete="off"></label></c:when>
			<c:otherwise><label>체크아웃 <input type="text" id="datepickerEnd" class="endEvent" value="${itemInfo.endDay }" readonly="readonly" autocomplete="off"></label></c:otherwise>
		</c:choose>
	</div>
	<br>
	<div id="hotelPeople">
		인원 <input type="number" id="peopleNum" value="${itemInfo.people }" autocomplete="off">명
	</div>
	<br>
	<div id="hotelRoom"></div>
	<br>
	<div id="hotelPrice">가격</div>
	<button>결제</button>
	
	<br><hr><br>
	
	<div id="hotelInfo"></div>
	<form id="actionForm" method = "post"></form>
<!-- onload -->
<script type="text/javascript">

	$(function(){
		var itemInfo = new Object();
		itemInfo.idx = '${itemInfo.idx }';
		itemInfo.people = '${itemInfo.people }';
		itemInfo.startDay = '${itemInfo.startDay }';
		itemInfo.endDay = '${itemInfo.endDay }';
		
		hotelGetAjax(itemInfo);
	});

</script>

<!-- hotel 상세정보 받아오는 ajax -->
<script type="text/javascript">

	function hotelGetAjax(itemInfo){

		$.ajax({
	         type : 'POST',
		     data : JSON.stringify(itemInfo),
	         url : '/manager/item/ajaxHotelGet',  
	         dataType : "json",
	         contentType : "application/json; charset=utf-8",
	         success : function(result) {
	        	 //console.log(result)
	        	 $("#hotelImg").html('<img src="../../resources/img/'+ result.image +'.jpg" width="200px" height="160px"/>')
	        	 
	        	 //객실 선택
	        	 var strRoom = '';
        		 strRoom += '객실선택 ';
       			 strRoom += '<select id = "hotelRoomSelect">';
       			 strRoom += '<option value="">::객실선택::</option>';
       			 
	        	 if(result.hotel_detail_list.length == 0){
	        		 alert("선택할 수 있는 객실정보가 없습니다.");
	        	 }
	        	 else{
	        		 $.each(result.hotel_detail_list, function(index, item) {	        			 
	        			 
        				strRoom += '<option value="' + item.hotel_idx + '">';
        				strRoom += '' + item.hotel_room + '호실(' + item.hotelRoom_people + '인)</option>';   			 	        			 
        				
	        		 });
	        	 }
        		 strRoom += '</select>';
	        	 $("#hotelRoom").html(strRoom);
	        	 
	        	 //호텔 정보
	        	 var str = '';
	        	 str += "숙소명 : " + result.item_Name + "<br>";
	        	 str += "주소 : " + result.address + "<br>";
	        	 str += "전화번호 : " + result.tel + "<br>";
	        	 str += "숙소 소개 : " + result.introduce;
	        	 
	        	 $("#hotelInfo").html(str);
	         }			
		});
		
		
		
		
		
		
		
		
	}

	
	
	
	
	
	
	
</script>


<!-- 날짜 선택 스크립트 -->
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
		    ,minDate: "2023-08-01" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		    ,maxDate: "2023-08-31" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)
			,beforeShowDay: disableAllTheseDays 
		});
		//input을 datepicker로 선언
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
		    ,minDate: "2023-08-01" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		    ,maxDate: "2023-08-31" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)
			,beforeShowDay: disableAllTheseDays 
		});
		
		// 특정일 배열(선택 비활성화)
	   	//var disabledDays = ["2023-08-01","2023-07-27","2023-8-12" ,"2023-8-12"];
		var disabledDays = [];
		
		
		//객실 선택할 때마다 예약된 기간 배열에 추가 => 해당 날짜 선택 불가
		$(document).on('change', '#hotelRoomSelect', function(){
			//alert($(this).val());
			
			let hotelIdx = $(this).val();
			$.ajax({
		         type : 'POST',
			     data : {"hotelIdx" : hotelIdx},
		         url : '/manager/item/getNoDate',  
		         dataType : "json",
		         success : function(result) {
		        	 console.log(result);
		         }
		         
			});
			
			
		});
		
		
		
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


</script>

<!-- 정보 변경할 때마다 ajax 실행 -->
<script type="text/javascript">

	var itemInfo = new Object();
	itemInfo.idx = '${itemInfo.idx }';
	itemInfo.people = '${itemInfo.people }';
	itemInfo.startDay = '${itemInfo.startDay }';
	itemInfo.endDay = '${itemInfo.endDay }';

	//검색 필터에 시작일, 종료일 정보 삽입
	var startDay = $(".startEvent");
	var endDay = $(".endEvent");
		
	
	$(endDay).change(function(){	//숙소 체크아웃 날짜 선택시 시작일 이전날짜는 선택 제한
		if($(this).val() < $(startDay).val()){
			alert("시작일보다 빠른 날짜를 선택일 수 없습니다.");
			$(this).val("");
		}
		itemInfo.endDay = $(this).val();
		hotelGetAjax(itemInfo);
	
	});
	
	$(startDay).change(function(){	//숙소 체크인 날짜 선택시 종료일보다 늦는 날 선택 불가
		if(($(endDay).val() != "") && ($(this).val() > $(endDay).val())){
			alert("종료일보다 늦은 날짜를 선택할 수 없습니다.");
			$(this).val("");
		}
		itemInfo.startDay = $(this).val();
		hotelGetAjax(itemInfo);
	});
	
	
	//검색 필터에 인원수 정보 삽입
	$("#peopleNum").change(function(){
		var peopleNum = $(this).val();
		
		if(isNaN(peopleNum) || peopleNum == "" || peopleNum <= 0){
			alert("올바르지 않은 형식입니다.");
			$(this).val("1");
		}
		
		itemInfo.people = $(this).val();		
		hotelGetAjax(itemInfo);
	});



</script>

<script type="text/javascript">

	const toListButton = document.querySelector("#toItemList");
	const actionForm = $("#actionForm");
	
	toListButton.addEventListener('click', (e) => {
   		
		e.preventDefault();
		
		var idxGet = '${itemInfo.idx }'; 
		
		var url = '/manager/item/itemList3';
		actionForm.attr('action', url);	//경로 변경	
				
		var peopleGet = '${itemInfo.people }';
		var pageGet = '${itemInfo.page }';
		
		
		var countryGet = '${itemInfo.country }';
		var item_CategoryGet = '${itemInfo.people }';
		var startDayGet = '${itemInfo.startDay }';
		var endDayGet = '${itemInfo.endDay }';
		
		actionForm.empty();
 		actionForm.append("<input type='hidden' name='idx' value = '" + idxGet + "'/>");		
 		actionForm.append("<input type='hidden' name='people' value = '" + peopleGet + "'/>");		
 		actionForm.append("<input type='hidden' name='country' value = '" + countryGet + "'/>");		
 		actionForm.append("<input type='hidden' name='item_Category' value = '" + item_CategoryGet + "'/>");		
 		actionForm.append("<input type='hidden' name='startDay' value = '" + startDayGet + "'/>");		
 		actionForm.append("<input type='hidden' name='endDay' value = '" + endDayGet + "'/>");		
 		actionForm.append("<input type='hidden' name='page' value = '" + pageGet + "'/>");		
	
 		//actionForm.submit();
 		location.href = '/manager/item/itemList3#';
		
   	});
	
</script>







</body>
</html>