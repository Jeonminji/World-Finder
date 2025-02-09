<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	
	#registerTem table{
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

</head>
<body>
	<%@include file="../../include/logoSerach.jsp"%>
	<h1>item 작성 페이지</h1>
	
	<div id="registerTem">
		<table>
			<tr>
				<th>나라를 선택해 주세요
				<td><%@ include file="../../include/itemFilter.jsp"%>
				<label id="countryInfo"></label></td>
			<tr>
			<tr>
				<th>상품 카테고리를 선택해 주세요</th>
				<td>
					<button name="cate" id="spot" class="disable">관광지</button>
					<button name ="cate" id="hotel" class="disable">숙소</button>
				</td>
			</tr>
		</table>
		<!-- <form id="itemInsert" method="post"> -->
		<table>
		<tbody id="itemDetail">
			<tr>
				<th>상품명을 입력해 주세요</th>
				<td><input type="text" name="item_Name"></td>
			</tr>
			<tr>
				<th>상품을 소개해 주세요</th>
				<td><textarea rows="5px" cols="20px" name="introduce"></textarea></td>
			</tr>
			<tr>
				<th>대표이미지를 등록해 주세요</th>
				<td id="#uploadDiv"><input type="file" name="image" multiple></td>
			</tr>
			<tr>
				<th>주소를 입력해 주세요</th>
				<td><input type="text" name="address"></td>
			</tr>
			<tr>
				<th>전화번호를 입력해 주세요</th>
				<td><input type="text" name="tel"></td>
			</tr>
			<tr>
				<th>관련 홈페이지를 등록해 주세요</th>
				<td><input type="text" name="url"></td>
			</tr>
			<tr>
				<th>관광지 유형을 선택해 주세요</th>
				<td>
					<select name="item_Option">
						<option value="" id="itemOption">::관광지유형::</option>
					</select>
					<label id="ect"></label>
				</td>
			</tr>
			<tr id="people">
			</tr>
			<tr id="hotelRoomForm">
			</tr>
			<tr id="detailInfo">
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="2">
					<button id="insertItem">등록하기</button>
					<button id="cancelInsert">취소하고 목록으로</button>
					<form method="post" id="realInsertItem"></form>
				</td>
			</tr>
		</tfoot>
		</table>	
		<!-- </form> -->
	</div>



<!-- onload -->
<script type="text/javascript">
	$(function(){
		const startCategory = '${categoryInfo }';
		$("#detailInfo").html('');
		
		if(startCategory != ''){
			$("#" + startCategory).attr('class', 'able');
		}
		
		if($(document).find('#hotel').attr('class') == 'able'){
			console.log("hotel 객실 출력");
			addInfo('hotel');
		}
		else if($(document).find('#spot').attr('class') == 'able'){
			addInfo('spot');
		}
		
		let str = '${countryInfo.continent }' + ' > ' + '${countryInfo.details_continent }' + ' > ' + '${countryInfo.country }';
		$("#countryInfo").html(str);
		
	});
	

</script>

<!-- 관광지, 호텔 따라 다른 form 보이기 -->
<script type="text/javascript">
	
	$("button[name=cate]").click(function(){

		$(document).find("button[name=cate]").attr("class", "disable");
		$(this).attr("class", "able");
		
		if($(this).attr('id') == 'hotel'){
			console.log("hotel 객실 출력");
		}
		
		addInfo($(this).attr('id'));
	});
	
	var strhotelDetail = '<th></th><td><table>'
						+'<tr><th>객실 번호 : </th><td><input type="text" name="hotel_room"></td></tr>'
						+'<tr><th>방 크기(단위 : 평) : </th><td><input type="number" name="hotelRoom_size">평</td></tr>'
						+'<tr><th>가격(일인당) : </th><td><input type="text" name="hotelRoom_price">원</td></tr>'
						+'<tr><th>객실 정보 : </th><td><input type="text" name="hotelRoom_view"></td></tr>'
						+'<tr><th>수용 인원 : </th><td><input type="number" name="hotelRoom_people"></td></tr>'
						+'</table></td>';
	
	
	function addInfo(cate){
		
		let hotelOptionList = ['호텔', '모텔', '민박', '게스트하우스', '켐핑', '펜션', '기타'];
		let spotOptionList = ['박물관', '공원', '거리', '계곡', '산', '바다', '기타'];
		
		let strPeople = '';
		let strOption = '';
		let strPrice = '';
		
		strOption += '<option value="">::관광지유형::</option>';
		if(cate == "spot"){

			$.ajax({
				
				 type : 'POST',
			     data : {itemIdx : '${itemIdx}'},
		         url : '/manager/item/allRoomDelete',         
		         dataType : "json",
		         success : function(data) {
		        	 console.log(data);
		         }
					
			});
			
        	$("#detailInfo").html('');
			
			strPeople += '<th>하루 허용가능한 인원수를 입력해 주세요</th>';
			strPeople += '<td><input type="number" name="people"></td>';
			document.getElementById('hotelRoomForm').innerHTML = '';
			
			strPrice += '<th>1인당 입장료를 입력해 주세요</th>';
			strPrice += '<td><input type="number" name="price"></td>';
			$("#hotelRoomForm").html(strPrice);
			for(var str in spotOptionList){
				strOption += '<option value="' + spotOptionList[str] + '">' + spotOptionList[str] + '</option>';
			}
			
		}
		else if(cate == 'hotel'){
			$("#hotelRoomForm").html('');
			strPeople += '<th>객실 정보를 입력해 주세요</th>';
			strPeople += '<td>';
			strPeople += '<button id="plusRoom">객실추가</button>';
			strPeople += '</td>';
			document.getElementById('hotelRoomForm').innerHTML+= strhotelDetail;
			for(var str in hotelOptionList){
				strOption += '<option value="' + hotelOptionList[str] + '">' + hotelOptionList[str] + '</option>';
			}
		}
		
		$("#people").html(strPeople);
		$("select[name=item_Option]").html(strOption);
	}
	
	$(document).on('change', 'select[name=item_Option]', function(){
		if($(this).val() == '기타'){
			$("#ect").html("<input type='text' name='ectType'>");
		}
		else{
			$("#ect").html('');
		}
	});
	$("button[name=cate]").click(function(){
		$("#ect").html('');
	});
	$("button[type=reset]").click(function(){
		$("#ect").html('');
		
	});
	
	
	//객실 추가 버튼을 눌렀을 때 ajax실행해서 바로 DB에 추가
	$(document).on("click", "#plusRoom, #minusRoom", function(e){
		e.preventDefault();
		
	
		
		
		let buttonType = $(this).attr('id');
		let inputData;
		let url;
		
		//객실 추가 버튼을 클릭한 경우
		if(buttonType == 'plusRoom'){
			
			if($("input[name=hotel_room]").val() == ''){
				alert("객실 번호를 입력해 주세요");
				return;
			}
			
			if($("input[name=hotelRoom_size]").val() == '' || 
					isNaN($("input[name=hotelRoom_size]").val()) ||
					Number($("input[name=hotelRoom_size]").val()) < 0){
				alert("객실 크기를 정확히 입력해 주세요");
				return;
			}
			
			if($("input[name=hotelRoom_price]").val() == '' || 
					isNaN($("input[name=hotelRoom_price]").val()) ||
					Number($("input[name=hotelRoom_price]").val()) < 0){
				alert("객실 가격을 정확히 입력해 주세요");
				return;
			}
			
			if($("input[name=hotelRoom_view]").val() == ''){
				alert("객실 정보를 입력해 주세요");
				return;
			}
			
			if($("input[name=hotelRoom_people]").val() == '' || 
					isNaN($("input[name=hotelRoom_people]").val()) ||
					Number($("input[name=hotelRoom_people]").val()) < 0){
				alert("방 수용 인원수를 정확히 입력해 주세요");
				return;
			}
			
			
			
			url = '/manager/item/hotelRoomInsert';
		
			let hotelDetailObject = new Object();
			
			hotelDetailObject.hotel_room = $("input[name=hotel_room]").val();
			hotelDetailObject.hotelRoom_size = $("input[name=hotelRoom_size]").val();
			hotelDetailObject.hotelRoom_price = $("input[name=hotelRoom_price]").val();
			hotelDetailObject.hotelRoom_view = $("input[name=hotelRoom_view]").val();
			hotelDetailObject.hotelRoom_people = $("input[name=hotelRoom_people]").val();
			
			hotelDetailObject.item_idx = 0;
			hotelDetailObject.hotel_idx = 0;
			hotelDetailObject.hotel_category = '0';
			
			inputData = JSON.stringify(hotelDetailObject);
		}
		else{	//객실삭제 버튼을 클릭한 경우
			/* inputData = {"hotelIdx" : Number($(this).attr('class')),
						"itemIdx" : Number('${itemIdx }')}; */
			//inputData = JSON.stringify(input);
			
			let input = new Object();
			input.hotelIdx = $(this).attr('class');
			input.itemIdx = 0;
			inputData = JSON.stringify(input);
			
			url = '/manager/item/hotelRoomDelete';
		}
		
		console.log(inputData);
		console.log("url : " + url);
		
		$.ajax({
			 type : 'POST',
		     data : inputData,
	         url : url,         
	         dataType : "json",
	         contentType : "application/json; charset=utf-8",
	         success : function(data) {
				
	        	 var hotelRoomInfo = '';
	        	 if(data.eCode == 1){
	        		 alert("중복된 객실을 입력하였습니다.");
	        	 }
	        	 else if(data.eCode == 2){
	        		 document.getElementById('detailInfo').innerHTML = '';
	        	 }
	        	 else{
	        		 document.getElementById('detailInfo').innerHTML = '';
	        		 //hotelRoomInfo += '<table>';
	        		 hotelRoomInfo += '<th><td>';
	        		 $.each(data.list, function(index, item){ 
	   					
	 						hotelRoomInfo += (Number(index) + 1) + '번째 객실<br>';
	 						hotelRoomInfo += '객실 번호 : ' + item.hotel_room + '<br>';
	 						hotelRoomInfo += '방 크기(단위 : 평) : ' + item.hotelRoom_size + '<br>';
	 						hotelRoomInfo += '가격(일인당) : ' + item.hotelRoom_price + '<br>';
	 						hotelRoomInfo += '객실 정보 : ' + item.hotelRoom_view + '<br>'
	 						hotelRoomInfo += '수용 인원 : ' + item.hotelRoom_people + '<br>';
	 						hotelRoomInfo += '<button id="minusRoom" class="' + item.hotel_idx + '">객실삭제</button>' + '<br>';
	 						hotelRoomInfo += '<hr><br>';
	        			 
	        		 });  
	        		//hotelRoomInfo += '</table>';
	        		hotelRoomInfo += '</td></th>';
	        		document.getElementById('detailInfo').innerHTML = hotelRoomInfo;
	        		
	        		$("input[name=hotel_room]").val('');
	        		$("input[name=hotelRoom_size]").val('');
	        		$("input[name=hotelRoom_price]").val('');
	        		$("input[name=hotelRoom_view]").val('');
	        		$("input[name=hotelRoom_people]").val('');
	        	 }
	         }			
		});
	});
	
	
</script>

<!-- 등록하기 버튼 눌렀을때 유효성 검사 후 등록 -->
<script type="text/javascript">
	
	var country = '${country }';
	var image = '';
	function ranName(e){
		console.log(e)
		country = e;
	}	
	
	function writeCountry(e){
		$("#countryInfo").html(e);
	}

	$("#insertItem").click(function(){
		console.log(country);
		if(country == ''){
			alert("나라를 선택하세요");
			return;
		}
		
		let cate = $(document).find('.able').attr('id');
		if(cate == "undefined" || cate == null || cate == ''){
			alert("카테고리를 선택하세요(관광지/숙소)");
			return;
		}
		
		let item_Name = $("input[name=item_Name]").val();
		if(item_Name == ''){
			alert("상품명을 입력하세요");
			return;
		}
		
		let introduce = $("textarea[name=introduce]").val();
		if(introduce == ''){
			alert("상품 소개를 입력하세요");
			return;
		}
		
		//밑의 스크립트 단에서 image 정보 가져옴
		if(image == ''){
			alert("대표 이미지를 등록하세요");
			return;
		}
		
		let address = $("input[name=address]").val();
		if(address == ''){
			alert("주소를 입력하세요");
			return;
		}
		
		let tel = $("input[name=tel]").val();
		if(tel == ''){
			alert("전화번호를 입력하세요");
			return;
		}
		
		let url = $("input[name=url]").val();
		if(url == ''){
			/* if(confirm("관련 url을 작성하지 않고 넘어가시겠습니까?")){
				return;
			} */
			alert("관련 url을 입력해 주세요")
			return;
		}
		
		let option = $("select[name=item_Option]").val();
		if(option == ''){
			alert("관광지 유형을 선택해 주세요");
			return;
		}
		if(option == '기타'){
			if($("input[name=ectType]").val() == ''){
				alert("기타 란을 채워주세요");
				return;
			}
			else{
				option = $("input[name=ectType]").val();
			}
		}
		
		let people = '';
		let price = '';
		if(cate == 'spot'){
			people = $("input[name=people]").val();
			if(people == ''){
				alert("수용 가능 인원수를 입력해 주세요")
				return;
			}
			
			price = $("input[name=price]").val();
			if(price == ''){
				alert('가격을 입력해 주세요')
				return;
			}
		
		}
		
		if(cate == 'hotel'){
			console.log($("#detailInfo").html())
			if($("#detailInfo").html() == '' || $("#detailInfo").html() == null){
				alert("객실을 추가해 주세요")
				return;
			}
			
			price = 0;
			people = 9999;
			
			
		}
		
		
		const actionForm = $("#realInsertItem");

		actionForm.empty();
		
		console.log('${itemIdx}')
		
		actionForm.append("<input type='hidden' name='item_Idx' value='" + '${itemIdx}' + "'/>");
		actionForm.append("<input type='hidden' name='country' value='" + country + "'/>");
		actionForm.append("<input type='hidden' name='item_Name' value='" + item_Name + "'/>");
		actionForm.append("<input type='hidden' name='regdate' value='" + '1900-01-01' + "'/>");
		actionForm.append("<input type='hidden' name='introduce' value='" + introduce + "'/>");
		actionForm.append("<input type='hidden' name='image' value='" + image + "'/>");
		actionForm.append("<input type='hidden' name='address' value='" + address + "'/>");
		actionForm.append("<input type='hidden' name='item_Category' value='" + cate + "'/>");
		actionForm.append("<input type='hidden' name='tel' value='" + tel + "'/>");
		actionForm.append("<input type='hidden' name='item_Url' value='" + url + "'/>");
		//actionForm.append("<input type='hidden' name='hotel_detail_list' value='" + '0' + "'/>");
		actionForm.append("<input type='hidden' name='item_Option' value='" + option + "'/>");
		actionForm.append("<input type='hidden' name='people' value='" + people + "'/>");
		actionForm.append("<input type='hidden' name='price' value='" + price + "'/>");
		
		actionForm.attr('action', '/manager/item/realItemInsert');
		actionForm.submit();
		
		
		
		
	});	

</script>

<!-- 이미지 파일 업로드 -->
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

			}
		});
	});
	
</script>


<script type="text/javascript">







	//추가된 itemIdx 제거
	$("#cancelInsert").click(function(e){
		e.preventDefault();
		
		const actionForm = $("#realInsertItem");
		actionForm.empty();
		actionForm.append(actionForm.append("<input type='hidden' name='country' value='" + country + "'/>"));
		actionForm.attr('method', 'get');
		actionForm.attr('action', '/manager/item/itemList3');
		actionForm.submit();
				
	});

</script>
</body>
</html>