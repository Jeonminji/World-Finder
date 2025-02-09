<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.foodList table{	/* 테이블 가운데 정렬 */
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
	.page-btn-now{
		list-style: none;
		background-color: white;
		pointer-events: none; /* 현재 페이지 클릭 막기 */
		font-size: 1.5em;
		float: left;
		margin-right: 20px;
		border: solid black 1px;
		color: black;
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
	
	.foodList #serachFilter{	/* 검색 필터랑 등록하기 버튼 공간 */
		width: 800px;
		margin: auto;
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
	
	li #updateDelete{
		float: right;
	}

</style>

<!-- jQuery 사용 설치 파일 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- 구글 맵 api 사용 설치 파일 -->
<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDMR_wbRSxhUfjlmG_Pbk6OHjr6mJvgkMI"></script>


</head>
<body>
	<%@include file="../../include/logoSerach.jsp"%>
	<h1>foodPost 페이지</h1>
	
	<div class = "foodList" id="wholeDiv">
		<div id="serachFilter">
			<sec:authorize access="isAuthenticated()">
				<input id="foodInsert" type="button" value="등록하기" style="float: right;"><br><br>
			</sec:authorize>
			
			 <%@ include file="../../include/itemFilter.jsp"%>
			<label id="countryInform"></label>
			
			<br><br>
			
			<button class="filterReset">필터초기화</button>
			
			<form method="post" id="actionForm"></form>
			
		</div>
		
		<br><hr><br>
	
		<table style="border: solid black 1px;">
			<tbody id="foodTbody">
				<c:forEach var="item" items="${list }">
						<tr>
							<td><img src="../../resources/img/${item.fp_Image }" width="200px" height="160px"/></td>
							<td width="600px">
								<ul>
									<li>상호명 : ${item.fp_Image }</li>
									<li>주소 : ${item.fp_Address }</li>
									<li>가게 전화번호 : ${item.fp_Tel }</li>
									<li>분류 : ${item.fp_Category }</li>
									<li>대표메뉴 : ${item.fp_Menu }</li>
								<sec:authorize access="isAuthenticated()">			
									<li><button id="updateDelete" class="${item.fp_Idx }">수정/삭제하기</button></li>
								</sec:authorize>
								</ul>
							</td>  
							<td>
								<div class="${item.fp_Idx }" style="width: 200px; height: 160px;">
									<div id="${item.fp_Idx }" class="map" ad="${item.fp_Address }"
												tel="${item.fp_Tel }" name="${item.fp_Name }"
												style="width: 200px; height: 160px; z-index: 2;"></div>
									<input type="button" value="detail" class="mapDetailButton" id="${item.fp_Idx }"
											ad="${item.fp_Address }" tel="${item.fp_Tel }" name="${item.fp_Name }">					
								</div>
							</td>		               
						</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
				<th colspan="3">
					<!-- page -->
		            <div class="pull-right">
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
		            </div>			
					<form action="/manager/food/foodList" method="get" id="actionForm">
						<input type="hidden" name="page" value="${pageMaker.cri.pageNum }">
						<input type="hidden" name="amount" value="10">
						<input type="hidden" name="country" value="${countryInfo.country }">
						<input type="hidden" name="total" value="0">
					</form>
				</th>
				</tr>
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

	var foodFilter = new Object();	//검색 필터 정보 요소
	$(function(){
		foodFilter.country = '';
		foodFilter.page = '1';

		//나라 상속
 		if('${country }' != 'None'){
 			foodFilter.country = '${country.country }';			
			let str = '${country.continent }' + ' > ' + '${country.details_continent }' + ' > ' + '${country.country }';
			$("#countryInform").html(str);
		}
	 	if('${country }' == ''){
			$("#countryInform").html('');
			foodFilter.country = '';
		}
		
/* 		//페이지 상속
		let page = '${foodFilter.page }';
		if(page > 0){
			foodFilter.page = page;
		} */
		
		//ajaxFoodList(foodFilter);	            
	});	
	
	
</script>

<script type="text/javascript">

	var actionForm = $("#actionForm"); //폼태그 정보 가져오기
	
	//페이징 버튼 이벤트 처리
	$(".paginate_button a").on('click', function(e){
		e.preventDefault();
		
		$("input[name='page']").val($(this).attr("href"));
		actionForm.find("input[name='page']").val($(this).attr("href"));
		//alert($(this).attr("href"))
		//actionForm.append('<input type="hidden" name="pageNum" value="' + $(this).attr("href") + '"/>');
		console.log($("input[name='page']").val());
		actionForm.submit();
	});

</script>

<!-- 본문 글 삽입 + 페이징 (ajax 비동기 처리)  -->
<script type="text/javascript">	

	//비동기 처리 리스트 불러오기 
	function ajaxFoodListdsfa(foodFilter){
		
		
		
		$.ajax({
			 anyne : true,
	         type : 'POST',
		     data : JSON.stringify(foodFilter),
	         url : '/manager/food/ajaxfoodList',         
	         dataType : "json",
	         contentType : "application/json; charset=utf-8",
	         success : function(data) {
	        	 
	            var str = '';		//상품 리스트 본문
	            var strPage= '';	//페이지 버튼
				
	            var list = data.list;
	            var page = data.page;
	            var startpage = data.startpage;
	            var endpage = data.endpage;
	             
				//본문 아이템 리스트
				if(list.length == '0'){
					str += '<label style="font-size: 1.5em;">결과가 존재하지 않습니다...</label>';
				}
				else{
					$.each(data.list, function(index, item) {
		
						//상품 이미지 삽입
						str += "<tr>";
						str += '<td><img src="../../resources/img/'+ item.fp_Image +'" width="200px" height="160px"/></td>';
		               
						//상품 정보
						str += '<td width="600px"><ul>';
						str += '<li>상호명 : '+ item.fp_Name +'</a></li>';
						str += '<li>주소 : '+ item.fp_Address +'</li>';
						str += '<li>가게 전화번호 : '+ item.fp_Tel +'</li>';
						str += '<li>분류 : '+ item.fp_Category +'</li>';
						str += '<li>대표메뉴 : '+ item.fp_Menu +'</li>';
						/* str += '<li>작성일 : '+ item.reg_Date +'</li>'; */
						str += '<sec:authorize access="isAuthenticated()">';				
						str += '<li><button id="updateDelete" class="' + item.fp_Idx + '">수정/삭제하기</button></li>';
						str += '</sec:authorize>';
						str += '</ul></td>';    
						
						//구글맵 api 삽입
						str += '<td>';
						str += '<div class="' + item.fp_Idx + '" style="width: 200px; height: 160px;">';
						str += '<div id="' + item.fp_Idx + '" class="map" ad="' + item.fp_Address + '"';
						str += 'tel="' + item.fp_Tel + '" name="' + item.fp_Name + '"';
						str += 'style="width: 200px; height: 160px; z-index: 2;"></div>';
						str += '<input type="button" value="detail" class="mapDetailButton" id="' + item.fp_Idx + '"';
						str += 'ad="' + item.fp_Address + '" tel="' + item.fp_Tel + '" name="' + item.fp_Name + '">';
						
						str += '</div>';
						str += '</td>';
		               
						str += "</tr>";
		            	  
					});
	
					//페이징 처리 ajax 부분
		            for (var num=startpage; num<=endpage; num++) {
		            	if (num == page) {
		            		strPage += '<a href = "#" class="page-btn-now" id="' + num + '">' + num + '</a>';
		                } else {
		                	strPage += '<a href = "#" class="page-btn" id="' + num + '">' + num + '</a>';
		            	}
		            }
				}
				
	            $('#foodTbody').html(str);
	            $('#foodPgaeButton').html(strPage); 
	            
	            //본문 내용을 불러온 후 구글맵 api 생성
				initialize();
	           
	         }
	      });
	};
	

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
	
	//모달창 바깥쪽 클릭하면 모달창 닫기
 	$(document).mouseup(function (e){

		if(modalMap.has(e.target).length === 0){
			modalMap.hide();
			document.body.style.overflow = "auto"; // 스크롤바 보이기
		}

	});
	
	
</script>

<!-- 검색 (필터) 관련 기능 -->
<script type="text/javascript">
	
	
	var foodFilter = new Object();	//검색 필터 정보 요소
	foodFilter.page = '1';		//페이지도 기본값이 1이므로 미리 추가
	foodFilter.country = '';
	
	if('${country.country }' != ''){
		foodFilter.country = '${country.country }';
	}
	
	//검색 필터에 나라이름 삽입
	function ranName(e){
		foodFilter.country = e;
		foodFilter.page = '1';
		ajaxFoodList(foodFilter);
	}	
	
	function writeCountry(e){
		$("#countryInform").html(e);
	}
		
	//페이지 이동 버튼
	$(document).on('click', '.page-btn', function(){
		foodFilter.page = $(this).attr("id");
		ajaxFoodList(foodFilter);
	});
	
	//필터초기화 버튼 클릭시
	$(".filterReset").click(function(){
		
		$("#country").val("");
		
		foodFilter.page = '1';
		foodFilter.country = '';

		
        /* filter_country.html("");
        filter_detail_continent.html("");
        $("#filter_continent").find(".filter_click").removeAttr('class'); */
		$("#countryInform").html('');
		ajaxFoodList(foodFilter);
	});
	
		
	
	
	
	
	

</script>

<!-- 등록/수정/삭제 -->
<script type="text/javascript">

	$("#foodInsert").click(function(e){
		e.preventDefault();
		
		let country = '${country.country }';
		const actionForm = $("#actionForm");
		
		actionForm.empty();
		actionForm.append('<input type="hidden" name="country" value="' + country + '"/>');
		actionForm.attr('action', '/manager/food/foodInsertPage');
		actionForm.submit();
		
	});
	
	$("#updateDelete").click(function(e){
		e.preventDefault();
		
		let fpIdx = $(this).attr('class');
		const actionForm = $("#actionForm");
		
		actionForm.empty();
		actionForm.append('<input type="hidden" name="fpIdx" value="' + fpIdx + '"/>');
		actionForm.attr('action', '/manager/food/foodUpdatePage');
		actionForm.submit();
	});

</script>

</body>
</html>