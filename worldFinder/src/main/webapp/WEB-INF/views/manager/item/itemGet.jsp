<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri= "http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

<style type="text/css">

	.Highlighted{
	
	
	
	   /* background-color : #456baf !important; */
	   background-color : red !important;	
	   background-image :none !important;	
	   color: black !important;	
	   font-weight:bold !important;	
	   font-size: 12px;	
	}

	
</style>
</head>
<body>
	<%@include file="../../include/logoSerach.jsp"%>
	<h1>${cate } 상세 (예약) 페이지</h1>
	<button id="toItemList">목록으로</button>
	
	<div id="hotelImg"></div>
	<br>
	<div id="hotelDate">
		날짜 
		<c:choose>
			<c:when test="${cate eq 'spot'}"><label>예약일 <input type="text" id="datepickerStart" class="startEvent" value="" readonly="readonly" autocomplete="off"></label></c:when>
			<c:when test="${itemInfo.startDay eq '1900-01-01'}"><label>체크인 <input type="text" id="datepickerStart" class="startEvent" value="" readonly="readonly" autocomplete="off"></label></c:when>
			<c:otherwise><label>체크인 <input type="text" id="datepickerStart" class="startEvent" value="${itemInfo.startDay }" readonly="readonly" autocomplete="off"></label></c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${cate eq 'spot'}"><label></label></c:when>
			<c:when test="${itemInfo.endDay eq '1900-01-01'}"><label>체크아웃 <input type="text" id="datepickerEnd" class="endEvent" value="" readonly="readonly" autocomplete="off"></label></c:when>
			<c:otherwise><label>체크아웃 <input type="text" id="datepickerEnd" class="endEvent" value="${itemInfo.endDay }" readonly="readonly" autocomplete="off"></label></c:otherwise>
		</c:choose>
		<label id="limitPeople"></label>
		<br>
		*빨간색으로 강조된 날짜는 이미 예약된 날짜입니다.
	</div>
	<br>
	<div id="hotelPeople">
		인원 <input type="number" id="peopleNum" value="${itemInfo.people }" autocomplete="off">명
	</div>
	<br>
	<div id="hotelRoom"></div>
	<br>
	<div>가격 : <label id="hotelPrice">0</label>원</div>
	<button id = "payment">결제</button>
	
	<br><hr><br>
	
	<div id="hotelInfo"></div>
	<form id="actionForm" method = "post"></form>
	
	<sec:authorize access="hasAuthority('admin')">
		<br><hr><br>
		
		<div>
			<button id="updateItem">수정하기</button>
			<button id="deleteItem">삭제하기</button>
		</div>
	</sec:authorize>
	
<!-- onload -->
<script type="text/javascript">

	$(function(){
		
		var itemInfo = new Object();
		itemInfo.idx = '${itemInfo.idx }';
		itemInfo.people = '${itemInfo.people }';
		itemInfo.startDay = '${itemInfo.startDay }';
		itemInfo.endDay = '${itemInfo.endDay }';
		itemInfo.category = '${cate }';
		
		console.log(itemInfo.category);
		getItemImage(itemInfo);
		
		if('${cate}' == 'hotel'){
			hotelGetAjax(itemInfo);			
		}
	});

</script>

<!-- hotel 상세정보 받아오는 ajax -->
<script type="text/javascript">

	function getItemImage(itemInfo){
		$.ajax({
			
			 type : 'POST',
		     data : JSON.stringify(itemInfo),
	         url : '/manager/item/ajaxHotelGet',  
	         dataType : "json",
	         contentType : "application/json; charset=utf-8",
	         success : function(result) {
	        	 
				$("#hotelImg").html('<img src="../../resources/img/'+ result.image +'" width="200px" height="160px"/>');
				
	        	 //호텔 정보
	        	 var str = '';
	        	 str += "상품명 : " + result.item_Name + "<br>";
	        	 str += "주소 : " + result.address + "<br>";
	        	 str += "전화번호 : " + result.tel + "<br>";
	        	 str += "상품 소개 : " + result.introduce;
	        	 str += "<input type='hidden' name='spotPrice' value='" + result.price +"'/>";
	        	 
	        	 $("#hotelInfo").html(str);
	        	 if('${categoryInfo }' == 'spot'){
		        	 $("#hotelPrice").html($("#peopleNum").val() * result.price);	        		 
	        	 }
	         }	
	         
			
			
		});
	}


	function hotelGetAjax(itemInfo){

		$.ajax({
	         type : 'POST',
		     data : JSON.stringify(itemInfo),
	         url : '/manager/item/ajaxHotelGet',  
	         dataType : "json",
	         contentType : "application/json; charset=utf-8",
	         success : function(result) {

	        	 
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
        				strRoom += '<option name="' + item.hotel_idx + '" value="' + item.hotel_idx + '" class = "' + item.hotelRoom_price + '">';
        				strRoom += '' + item.hotel_room + '호실(' + item.hotelRoom_people + '인)</option>';   			 	        			 
        				
	        		 });
	        	 }
        		 strRoom += '</select>';
	        	 $("#hotelRoom").html(strRoom);
	         }			
		});
	
	}


</script>

<!-- 날짜 선택 스크립트 -->
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
		    ,minDate: "2023-08-01" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		    ,maxDate: "2023-08-31" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)
			,beforeShowDay: disableAllTheseDays 
		});
		
		// 특정일 배열(선택 비활성화)
	   	//var disabledDays = ["2023-8-13"];
	   	var disabledDaysT = [];
		var disabledDaysF = [];
		
		
		//호텔 카테고리일때만 실행됨
		//객실 선택할 때마다 예약된 기간 배열에 추가 => 해당 날짜 선택 불가
 		$(document).on('change', '#hotelRoomSelect', function(){
			//alert($(this).val());
			
			let hotelIdx = $(this).val();
			let startDayTmp = $(".startEvent").val();
			let endDayTmp = $(".endEvent").val();
			
			$.ajax({
		         type : 'POST',
			     data : {"hotelIdx" : hotelIdx},
		         url : '/manager/item/getNoDate',  
		         dataType : "json",
		         success : function(result) {
		        	 disabledDaysT = result.resultT
		        	 disabledDaysF = result.resultF
		         }
		         
			});
			
			
		});
		
 		$(document).ready(function(){
 			
 			if('${cate }' == 'spot'){
 				
 				
 				let itemIdx = '${itemInfo.idx }';
 				let people = 1;
 				
 				$.ajax({
 			         type : 'POST',
 				     data : {"itemIdx" : itemIdx,
 				    	 	"people" : people,
 				    	 	"startDay" : '1900-01-01'},
 			         url : '/manager/item/getNoDateSpot',  
 			         dataType : "json",
 			         success : function(result) {
 			        	 
 			        	 disabledDaysT = result.resultT
 			        	 disabledDaysF = result.resultF
 			         }
 			         
 				});
 			}
 			
 		});
		
		
		$(document).on('change', '#peopleNum, .startEvent', function(){
			
			let itemIdx = '${itemInfo.idx }';
			let people = $(document).find('#peopleNum').val();
			let startDayRev = $(".startEvent").val();

			if(startDayRev == ''){
				startDayRev = '1900-01-01';
			}			
			
			$.ajax({
		         type : 'POST',
			     data : {"itemIdx" : itemIdx,
			    	 	"people" : people,
			    	 	"startDay" : startDayRev},
		         url : '/manager/item/getNoDateSpot',  
		         dataType : "json",
		         success : function(result) {
		        	 
		        	 disabledDaysT = result.resultT;
		        	 disabledDaysF = result.resultF;
		        	 
		        	 let reservePeople = result.reservePeople;
		        	 let countPeople = Number(people) + Number(reservePeople);
		        	 
		        	 
		        	 
		        	 if('${cate }' == 'spot'){	
		        		 
		        		 if(countPeople > result.fullPeople){
			        		 alert("예약 가능 인원을 초과하였습니다.");
			        		 countPeople = Number(reservePeople) + 1;
			        		 $(document).find('#peopleNum').val('1');
			        	 }
		        		 
		        		 
			        	 var peopleInfo = '제한인원 : ';
			        	 peopleInfo += countPeople + '/' + result.fullPeople;
			        	 $("#limitPeople").html(peopleInfo);
		        	 }
		         }
		         
			});
			
		});
		
		
		
		
		
	   	// 특정일 선택 막기
	   	function disableAllTheseDays(date) {
	   		
	   		const category = '${cate }';
	   	    var m = date.getMonth(), d = date.getDate(), y = date.getFullYear();
	   		
	   		if(category == 'hotel'){   		
		   	    for (i = 0; i < disabledDaysF.length; i++) {
		   	        if($.inArray(y + '-' +(m+1) + '-' + d,disabledDaysF) != -1) {
		   	        	if(disabledDaysT.includes('' + y + '-' + (m+1) + '-' + d)){
		   	        		return[true, "Highlighted"];
		   	        	}
		   	        	else{
		   	        		return[false, "Highlighted"];
		   	        	}
		   	        }
		   	    }
	   		}
	   		else{
		   	    for (i = 0; i < disabledDaysT.length; i++) {
		   	        if($.inArray(y + '-' +(m+1) + '-' + d,disabledDaysT) != -1) {
		   	        	if(disabledDaysF.includes('' + y + '-' + (m+1) + '-' + d)){
		   	        		return[false, "Highlighted"];
		   	        	}
		   	        	else{
		   	        		return[true, "Highlighted"];
		   	        	}
		   	        }
		   	    }
	   		}
	   		return [true, ''];
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
	itemInfo.category = '${cate }';

	//검색 필터에 시작일, 종료일 정보 삽입
	var startDay = $(".startEvent");
	var endDay = $(".endEvent");
		
	
	$(endDay).change(function(){	//숙소 체크아웃 날짜 선택시 시작일 이전날짜는 선택 제한
		if($(startDay).val() != ""){
			if($(this).val() < $(startDay).val()){
				alert("시작일보다 빠른 날짜를 선택일 수 없습니다.");
				$(this).val("");				
			}
			else if($(this).val() == $(startDay).val()){
				alert("같은 날짜를 선택할 수 없습니다.");
				$(this).val("");
			}
		}
		itemInfo.endDay = $(this).val();
		
		if('${cate }' == 'hotel'){
			hotelGetAjax(itemInfo);		
		}
	
	});
	
	$(startDay).change(function(){	//숙소 체크인 날짜 선택시 종료일보다 늦는 날 선택 불가
		if($(endDay).val() != ""){
			if($(this).val() > $(endDay).val()){
				alert("종료일보다 늦은 날짜를 선택할 수 없습니다.");
				$(this).val("");				
			}
			else if($(this).val() == $(endDay).val()){
				alert("같은 날짜를 선택할 수 없습니다.");
				$(this).val("");
			}
		}
		itemInfo.startDay = $(this).val();
		if('${cate }' == 'hotel'){
			hotelGetAjax(itemInfo);		
		}
	});
	
	
	
	
	//검색 필터에 인원수 정보 삽입
	$("#peopleNum").change(function(){
		var peopleNum = $(this).val();
		
		if(isNaN(peopleNum) || peopleNum == "" || peopleNum <= 0){
			alert("올바르지 않은 형식입니다.");
			$(this).val("1");
		}
		
		itemInfo.people = $(this).val();		
		if('${cate }' == 'hotel'){
			hotelGetAjax(itemInfo);		
		}
	});



</script>

<!-- 가격보기, 결제하기 -->
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script type="text/javascript">
	
	var price = '';

	//가격 보기
	$(document).on('change', '#peopleNum, #hotelRoomSelect', function(){
		let pricePer = '';
		if('${cate }' == 'hotel'){
			let num = $("#hotelRoomSelect").val();
			
			if(num == null || num == ''){
				num = 0;
			}
			
			pricePer = $("option[name=" + num + "]").attr('class');
		}
		else{
			pricePer = $("input[name=spotPrice]").val();
		}
			
		price = $("#peopleNum").val() * pricePer;
		
		if(('' + price) == 'NaN'){
			price = 0;
		}
		
	
		$("#hotelPrice").html(price);
	});
	
	$(".startEvent").change(function(){

		if('${cate }' == 'spot'){
			
			let pricePer = $("input[name=spotPrice]").val();
			price = $("#peopleNum").val() * pricePer;
			
			if(('' + price) == 'NaN'){
				price = 0;
			}
			$("#hotelPrice").html(price);
		}
		
	});
	
	
	
	//결제 버튼 클릭
	$("#payment").click(function(){
		
		if($(".startEvent").val() == '' || $(".endEvent").val() == ''){
			alert("날짜를 선택하세요");
			return;
		}
		if($("#hotelRoomSelect").val() == ''){
			alert("객실을 선택하세요")
			return;
		}
		
		let check_Out_Date = '';
		if('${cate }' == 'spot'){
			check_Out_Date = $(".startEvent").val();
		}
		else{
			check_Out_Date = $(".endEvent").val();
		}
		
		//const actionForm = $("#actionForm");
		
		//actionForm.empty();
		//let str = '';
		let hotel_idx = $("#hotelRoomSelect").val();
		if(hotel_idx == undefined){
			hotel_idx = -1;
		}
		
/* 		private int item_Idx;			//구매한 상품 idx
		private String u_Writer;		//구매한 유저 idx
		private Date buy_Date;			//구매 날짜
		private Date check_In_Date;		//이벤트 시작일
		private Date check_Out_Date;	//이벤트 종료일
		private int people;				//이벤트 인원
		private int final_Price;		//최종 가격
		private int hotel_idx;			//호텔 객실 번호 */
		
		console.log(hotel_idx)
		
		//var totalPrice = $("input[name=final_Price]").val();
		// 현재 로그인 한 계정
        var principal;
        '<sec:authorize access="isAuthenticated()">';
			principal = '<sec:authentication property="principal.username"/>';
		'</sec:authorize>';
		
			
			var currentDate = new Date();
		    var formattedDate = currentDate.getFullYear() + 
		                        ('0' + (currentDate.getMonth() + 1)).slice(-2) +
		                        ('0' + currentDate.getDate()).slice(-2) +
		                        ('0' + currentDate.getHours()).slice(-2) +
		                        ('0' + currentDate.getMinutes()).slice(-2) +
		                        ('0' + currentDate.getSeconds()).slice(-2);
		    
		    var merchant_uid = "userOrder_" + formattedDate;
			
		    var check_In_Date = $(".startEvent").val();
			var people = $("#peopleNum").val();
			var final_price = Number($("#hotelPrice").html());
			var item_idx = '${itemInfo.idx }';
			
		    var payWrite = {
		    	item_Idx : item_idx,
		    	u_Writer : principal,
		    	check_In_Date : check_In_Date,
		    	check_Out_Date : check_Out_Date,
		    	people : people,
		    	final_Price : final_price,
		    	hotel_idx : hotel_idx
		    }
		    
			
			IMP.init('imp65675182');
			IMP.request_pay({
				pg: 'kakaopay',
				pay_method : 'card',
				merchant_uid: merchant_uid, // 상점에서 관리하는 주문 번호, 결제할 때마다 바꿔야함
				name : 'World Finder 상품 결제', 	// 상품명
				amount : final_price, // 결제 금액
				customer_uid : principal, // 필수 입력
				//buyer_email : 'iamport@siot.do',
				//buyer_name : '아임포트',
				//buyer_tel : '02-1234-1234'
			}, function(rsp) {
				if ( rsp.success ) {
					alert('결제 성공');
					
					$.ajax({
						type: "POST",
						url: "/pay",
						data: JSON.stringify(payWrite),
		            	contentType: "application/json; charset=utf-8",
		            	success : function(result) {
		            		alert("결제가 되었습니다.");
		            		console.log(merchant_uid);
		            		console.log("결제 등록 결과:", result);
		            	},
		            	error : function(xhr, status, er) {
		            		alert("결제가 되지 않았습니다.");
		            		console.log("결제 실패 결과:", er);
		            	}
					});
					
				} else {
					alert('결제 실패');
				}
			});
		
		
		
		
		/* str += '<input type="hidden" name="buy_Date" value="' + '1900-01-01' + '"/>';
		
		str += '<input type="hidden" name="final_Price" value="' + Number($("#hotelPrice").html()) + '"/>';
		str += '<input type="hidden" name="item_Idx" value="' + '${itemInfo.idx }' + '"/>';
		str += '<input type="hidden" name="hotel_idx" value="' + hotel_idx + '"/>';
		str += '<input type="hidden" name="people" value="' + $("#peopleNum").val() + '"/>';
		str += '<input type="hidden" name="check_In_Date" value="' + $(".startEvent").val() + '"/>';
		str += '<input type="hidden" name="check_Out_Date" value="' + check_Out_Date + '"/>';
		
		str += '<input type="hidden" name="u_Writer" value="' + '<sec:authentication property="principal.username"/>' + '"/>'; */
		
		//actionForm.append(str);
		//actionForm.attr('action', '/manager/item/toKakaoPay');

/* 		console.log($("input[name=buy_Date]").val());
		console.log($("input[name=final_Price]").val());
		console.log($("input[name=item_Idx]").val());
		console.log($("input[name=hotel_idx]").val());
		console.log($("input[name=people]").val());
		console.log($("input[name=check_In_Date]").val());
		console.log($("input[name=check_Out_Date]").val());
		console.log($("input[name=u_Writer]").val()); */
		
		//actionForm.submit();
	});
	
	
	
	
</script>

<!-- 목록으로 돌아갈 때 -->
<script type="text/javascript">

	const toListButton = document.querySelector("#toItemList");
	const actionForm = $("#actionForm");
	
	$(toListButton).click(function(e){
		

   		
		e.preventDefault();
		
		let idxGet = '${itemInfo.idx }'; 
		
		let url = '/manager/item/itemList3';
		actionForm.attr('action', url);	//경로 변경	
				
		let peopleGet = '${itemInfo.people }';
		let pageGet = '${itemInfo.page }';
		
		
		let countryGet = '${itemInfo.country }';
		let item_CategoryGet = '${itemInfo.item_Category }';
		let startDayGet = '${itemInfo.startDay }';
		let endDayGet = '${itemInfo.endDay }';
		
		actionForm.empty();
 		actionForm.append("<input type='hidden' name='idx' value = '" + idxGet + "'/>");		
 		actionForm.append("<input type='hidden' name='people' value = '" + peopleGet + "'/>");		
 		actionForm.append("<input type='hidden' name='country' value = '" + countryGet + "'/>");		
 		actionForm.append("<input type='hidden' name='item_Category' value = '" + item_CategoryGet + "'/>");		
 		actionForm.append("<input type='hidden' name='startDay' value = '" + startDayGet + "'/>");		
 		actionForm.append("<input type='hidden' name='endDay' value = '" + endDayGet + "'/>");		
 		actionForm.append("<input type='hidden' name='page' value = '" + pageGet + "'/>");		
	
 		actionForm.submit();
 		//location.href = '/manager/item/itemList3#';
		
   	});
	
</script>

<!-- 수정, 삭제 버튼 클릭 -->
<script type="text/javascript">

	//삭제하기 버튼 클릭했을 때
	$("#deleteItem").click(function(){
		
		if(confirm("삭제하시겠습니까? (이 상품을 구매한 유저의 내역도 함께 삭제됩니다.)")){
			/* actionForm.empty();
			actionForm.append("<input type='hidden' name='idx' value = '" + '${itemInfo.idx }' + "'/>"); */
			
			
			let idxGet = '${itemInfo.idx }'; 
		
			let countryGet = '${itemInfo.country }';

			
			actionForm.empty();
	 		actionForm.append("<input type='hidden' name='idx' value = '" + idxGet + "'/>");		
	 		actionForm.append("<input type='hidden' name='country' value = '" + countryGet + "'/>");		
	 
		
			actionForm.attr('action', '/manager/item/deleteItem');	//경로 변경	
			actionForm.submit();
		}
		else{
			return;
		}
		
	});
	
	
	//수정하기 버튼 클릭했을 때
	$("#updateItem").click(function(){
		
		
		actionForm.empty();
		actionForm.append("<input type='hidden' name='idx' value = '" + '${itemInfo.idx }' + "'/>");
		actionForm.attr('action', '/manager/item/updateItem');	//경로 변경	
		actionForm.submit();
	});
	
	
	
	
	
	
	
	
	
</script>







</body>
</html>