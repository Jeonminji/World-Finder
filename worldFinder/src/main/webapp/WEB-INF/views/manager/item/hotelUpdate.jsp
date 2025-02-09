<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri= "http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	
	#wholePage table{
		margin: auto;
	}
	
	

</style>

<!-- jQuery 사용 설치 파일 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

</head>
<body>
	<%@include file="../../include/logoSerach.jsp"%>
	<h1>Item (상품) 수정 페이지</h1>
	<div id="wholePage">
		<table>
			<tr>
				<th>대표이미지 변경</th>
				<td><input type="file" name="image" value="${itemInfo.image }" multiple></td>
			</tr>
			<tr>
				<th>현재 이미지</th>
				<td id="nowImage"></td>
			</tr>
			<tr>
				<th>상품 명</th>
				<td><input type="text" name="item_Name" value="${itemInfo.item_Name }"></td>
			</tr>
			<tr>
				<th>나라</th>
				<td>
					<%@ include file="../../include/itemFilter.jsp"%>
					<label id=country>${itemInfo.country }</label>
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td><input type="text" name="address" value="${itemInfo.address }"></td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="tel" value="${itemInfo.tel }"></td>
			</tr>
			<tr>
				<th>상품 소개</th>
				<td><textarea rows="5px" cols="20px" name="introduce">${itemInfo.introduce }</textarea></td>
			</tr>
			<tr>
				<th>관련 홈페이지</th>
				<td><input type="text" name="item_Url" value="${itemInfo.item_Url }"></td>
			</tr>
			<tr id="addInfo1">
			</tr>
			<tr id="addInfo2">
			</tr>
		</table>
		
		<br><hr><br>
		
		<div>
			<button id="toList">목록으로</button>
			<button id="saveItem">저장하기</button>
			<form method="post" id="actionForm"></form>
		</div>
	</div>

<!-- onload -->	
<script type="text/javascript">
	
	var country = '${itemInfo.country }';
	var image = '${itemInfo.image }';
	var cate = '${itemInfo.item_Category }';

	$(function(){
		const actionForm = $("#actionForm");
		
		$("#nowImage").html('<img src="../../resources/img/' + image + '" width="200px" height="160px"/>');	
		if(cate == 'spot'){addSpotInfo(); }
		else if(cate == 'hotel'){addHotelInfo(); }
		
		

	});
	
</script>

<!-- 변경 사항 띄우기 -->
<script type="text/javascript">

 	function addSpotInfo(){
		
 		$("#addInfo1").html('');
		$("#addInfo2").html('');
 		
		let strOne = '';
		strOne += '<th>하루 입장 가능한 인원수</th>';
		strOne += '<td><input type="number" name="people" value="${itemInfo.people }"></td>';
		
		let strTwo = '';
		strTwo += '<th>1인당 입장료</th>';
		strTwo += '<td><input type="number" name="price" value="${itemInfo.price }"></td>'
		
		$("#addInfo1").html(strOne);
		$("#addInfo2").html(strTwo);
		
	};
	
	function addHotelInfo(){
		
		let strOne = '';
		strOne += '<th>객실 선택</th>';
		strOne += '<td><select id="hotelDetail">';
		strOne += '<option value="">::객실선택::</option>';
		
		$.ajax({
			type : 'POST',
		    data : {item_idx : '${itemInfo.item_Idx}'},
	      	url : '/manager/item/getAllHotelRoom',         
	      	dataType : "json",
	      	success : function(data) {
	      		
	      		$.each(data, function(index, item){
	      			console.log(item.hotel_room)
	      			strOne += '<option value="' + item.hotel_idx + '">' + item.hotel_room + '호실</option>';
	      		});
	    		strOne += '</select> <button id="plusRoom">객실 추가하기</button></td>';
	    		$("#addInfo1").html(strOne);
	      	}
		});

	};
	
	function ranName(e){
		$("#country").html(e);
		country = e;
	};
	function writeCountry(e){
		console.log(e)
	}; 
	
	$(document).on('change', '#hotelDetail', function(){
		
		let strTwo = '';
		let itemIdx = '${itemInfo.item_Idx}';
		let hotelIdx = $(this).val();
		
		if($(this).val() == ''){
			$("#addInfo2").html(strTwo);
		}
		else{
			
		
			strTwo += '<th>객실 정보 변경</th>';
			strTwo += '<td>';
			
			$.ajax({
		         type : 'POST',
			     data : {item_idx : itemIdx,
			    	 	hotel_idx : hotelIdx},
		         url : '/manager/item/getOnehotelDetail',         
		         dataType : "json",
		         success : function(data) {
		        	 strTwo += '<table>';
		        	 strTwo += '<tr><th>객실 번호 : </th>';
		        	 strTwo += '<td><input type="text" name="hotel_room" value="' + data.hotel_room + '"></td></tr>';
		        	 strTwo += '<tr><th>방 크기(단위 : 평) : </th>';
		        	 strTwo += '<td><input type="text" name="hotelRoom_size" value="' + data.hotelRoom_size + '"></td></tr>';
		        	 strTwo += '<tr><th>가격 (1인당) : </th>';
		        	 strTwo += '<td><input type="text" name="hotelRoom_price" value="' + data.hotelRoom_price + '"></td></tr>';
		        	 strTwo += '<tr><th>객실 정보 : </th>';
		        	 strTwo += '<td><input type="text" name="hotelRoom_view" value="' + data.hotelRoom_view + '"></td></tr>';
		        	 strTwo += '<tr><th>수용 인원 : </th>';
		        	 strTwo += '<td><input type="text" name="hotelRoom_people" value="' + data.hotelRoom_people + '"></td></tr>';
		        	 strTwo += '<tr><th colspan = "2"><button id="saveRoom">객실 변경사항 저장하기</button> ';
		        	 strTwo += '<button id="deleteRoom">객실 삭제하기</button></th></tr>';
		        	 strTwo += '</table>';
		        	 strTwo += '</td>';
		        	 $("#addInfo2").html(strTwo);
		         }
			});
		}
		
	});
	

</script>

<!-- 변경사항 저장 -->
<script type="text/javascript">

	$(document).on('click', '#saveRoom', function(){
		
		let roomInfo = new Object();
		roomInfo.hotel_room = $('input[name=hotel_room]').val();
		roomInfo.hotelRoom_size = $('input[name=hotelRoom_size]').val();
		roomInfo.hotelRoom_price = $('input[name=hotelRoom_price]').val();
		roomInfo.hotelRoom_view = $('input[name=hotelRoom_view]').val();
		roomInfo.hotelRoom_people = $('input[name=hotelRoom_people]').val();
		roomInfo.hotel_idx = $("#hotelDetail").val();
		roomInfo.item_idx = '${itemInfo.item_Idx}';
		
		$.ajax({
			 type : 'POST',
		     data :  JSON.stringify(roomInfo),
	         url : '/manager/item/updateRoom',         
	         dataType : "json",
	         contentType : "application/json; charset=utf-8",
	         success : function(data) {
	        	 if(data == '1'){
		        	 alert("저장되었습니다.");	        		 
	        	 }
	         }		
		});
		
		
	});
	
	$("#saveItem").click(function(){
		
		let item_Name = $("input[name=item_Name]").val();
		let introduce = $("textarea[name=introduce]").val();
		let address = $("input[name=address]").val();
		let tel = $("input[name=tel]").val();
		let item_Url = $("input[name=item_Url]").val();
		let price = $("input[name=price]").val();
		let people = $("input[name=people]").val();
		
		if(typeof people == "undefined" || people == null || people == ""){
			people = 0;
		}
		if(typeof price == "undefined" || price == null || price == ""){
			price = 0;
		}
		
		const actionForm = $("#actionForm");
		actionForm.empty();
		actionForm.append("<input type='hidden' name='item_Idx' value='" + '${itemInfo.item_Idx}' + "'/>");
		actionForm.append("<input type='hidden' name='country' value='" + country + "'/>");
		actionForm.append("<input type='hidden' name='item_Name' value='" + item_Name + "'/>");
		actionForm.append("<input type='hidden' name='introduce' value='" + introduce + "'/>");
		actionForm.append("<input type='hidden' name='image' value='" + image + "'/>");
		actionForm.append("<input type='hidden' name='address' value='" + address + "'/>");
		actionForm.append("<input type='hidden' name='tel' value='" + tel + "'/>");
		actionForm.append("<input type='hidden' name='item_Url' value='" + item_Url + "'/>");
		actionForm.append("<input type='hidden' name='price' value='" + price + "'/>");
		actionForm.append("<input type='hidden' name='people' value='" + people + "'/>");
		actionForm.append("<input type='hidden' name='item_Category' value='" + cate + "'/>");
		
		actionForm.attr('action', '/manager/item/refreshItem');
		actionForm.submit();
		
	});
	
	
	$("#toList").click(function(e){
		
		e.preventDefault();
		const actionForm = $("#actionForm");
		actionForm.empty();
		
		actionForm.append("<input type='hidden' name='country' value='" + country + "'/>");
		
		actionForm.attr('mothod', 'get');
		actionForm.attr('action', '/manager/item/itemList3');
		actionForm.submit();
	});
	
</script>

<!-- 이미지 변경 -->
<script type="text/javascript">


		
	var regex = new RegExp("(.*?).jpg|jpeg|png");
	var maxSize = 5242880;	//5MB
	var cloneObj = $("#uploadDiv input").clone();
	
	
	
		
	function checkExtension(filename, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(!regex.test(filename)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		
		return true;
	}
	
	
	$("input[name=image]").on('change', function(){
		var formData = new FormData();
		var inputFile = $("input[name=image]");
		var files = inputFile[0].files;
		console.log(files);
		
		for(var i = 0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			
			
			formData.append('uploadFile', files[i]);
		}
		
		$.ajax({
			type : 'post',
			url : '/manager/item/uploadItemImage',
			data : formData,
			contentType : false,
			processData : false,
			dataType : 'json',
			success : function(result){
				console.log(result.fileName);
				console.log(result.uuid);
				
				image = '' + result.uuid + '_' + result.fileName;
				$("#nowImage").html('<img src="../../resources/img/' + image + '" width="200px" height="160px"/>');

			}
		});
	
	
	});

</script>

<!-- 숙소 객실 삭제, 추가 -->
<script type="text/javascript">

	//객실 삭제하기
	$(document).on('click', '#deleteRoom', function(){
		if(confirm("객실을 삭제하시겠습니까? (이 객실을 예약한 유저의 구매 내역도 함께 삭제됩니다.)")){
			let hotel_idx = $("#hotelDetail").val();
			let item_idx = '${itemInfo.item_Idx }';
			let inputData = JSON.stringify({hotelIdx : hotel_idx,
		    	itemIdx : item_idx
		    });
		
			
			$.ajax({
				type : 'POST',
			    data : inputData,
		        url : '/manager/item/hotelRoomDelete',         
		        dataType : "json",
		        contentType : "application/json; charset=utf-8",
		        success : function(data) {
		        	if(data.eCode == 2){
		        		alert("객실 정보가 없습니다. 객실을 추가해 주세요");	
		        	}
		        	else{
		        		alert("삭제 되었습니다.")
		        	}
		        	$("#addInfo").html('');
		        	addHotelInfo();
		        }
			
			});
		}
		
	});
	
	//객실 추가 폼
	$(document).on('click', '#plusRoom', function(){
		$("#addInfo2").html('');
		let strTwo = '';
		
		strTwo += '<th>추가할 객실 정보</th>';
		strTwo += '<td><table>';		
		strTwo += '<tr><th>객실 번호 : </th><td><input type="text" name="hotel_room"></td></tr>'
		+'<tr><th>방 크기(단위 : 평) : </th><td><input type="number" name="hotelRoom_size">평</td></tr>'
		+'<tr><th>가격(일인당) : </th><td><input type="text" name="hotelRoom_price">원</td></tr>'
		+'<tr><th>객실 정보 : </th><td><input type="text" name="hotelRoom_view"></td></tr>'
		+'<tr><th>수용 인원 : </th><td><input type="number" name="hotelRoom_people"></td></tr>'		
		strTwo += '<tr><th colspan="2"><button id="insertRoom">추가하기</button></th></tr>';
		strTwo += '</table></td>';
		
		$("#addInfo2").html(strTwo);
	});
	
	//객실 추가하기
	$(document).on('click', '#insertRoom', function(){
		
		let room = new Object();
		room.hotel_room = $('input[name=hotel_room]').val();
		room.hotelRoom_size = $('input[name=hotelRoom_size]').val();
		room.hotelRoom_price = $('input[name=hotelRoom_price]').val();
		room.hotelRoom_view = $('input[name=hotelRoom_view]').val();
		room.hotelRoom_people = $('input[name=hotelRoom_people]').val();
		room.item_idx = '${itemInfo.item_Idx }';
		
		room.hotel_category = '0';
		
		$.ajax({
			type : 'POST',
		    data : JSON.stringify(room),
	        url : '/manager/item/hotelRoomInsert',         
	        dataType : "json",
	        contentType : "application/json; charset=utf-8",
	        success : function(data) {
	        	if(data.eCode == 1){
	        		alert("중복된 객실을 입력할 수 없습니다.");
	        		return;
	        	}
	        	else{
	        		alert("객실이 추가되었습니다.");
	        	}
	        	$("#addInfo2").html('');
	        	addHotelInfo();
	        }
		});
		
	});
	
	
</script>




</body>
</html>