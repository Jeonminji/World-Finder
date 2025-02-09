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
	<h1>맛집 수정 페이지</h1>
	<div id="wholePage">
		<table>
			<tr>
				<th>대표이미지 변경</th>
				<td><input type="file" name="fp_Image" value="${foodInfo.fp_Image }" multiple></td>
			</tr>
			<tr>
				<th>현재 이미지</th>
				<td id="nowImage"></td>
			</tr>
			<tr>
				<th>상호 명</th>
				<td><input type="text" name="fp_Name" value="${foodInfo.fp_Name }"></td>
			</tr>
			<tr>
				<th>나라</th>
				<td>
					<%@ include file="../../include/itemFilter.jsp"%>
					<label id=country>${countryInfo.country }</label>
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td><input type="text" name="fp_Address" value="${foodInfo.fp_Address }"></td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="fp_Tel" value="${foodInfo.fp_Tel }"></td>
			</tr>
			<tr>
				<th>대표메뉴</th>
				<td><input type="text" name="fp_Menu" value="${foodInfo.fp_Menu }"></td>
			</tr>
		</table>
		
		<br><hr><br>
		
		<div>
			<button onclick="location.href = '/manager/food/foodList'">목록으로</button>
			<button id="saveFood">저장하기</button>
			<button id="deleteFood">삭제하기</button>
			<form method="post" id="actionForm"></form>
		</div>
	</div>

<!-- onload -->	
<script type="text/javascript">
	
	var country = '${itemInfo.country }';
	var image = '${itemInfo.image }';

	$(function(){
		const actionForm = $("#actionForm");
		
		$("#nowImage").html('<img src="../../resources/img/' + image + '" width="200px" height="160px"/>');	
		if(cate == 'spot'){addSpotInfo(); }
		else if(cate == 'hotel'){addHotelInfo(); }
		
		

	});
	
</script>


<!-- 변경사항 저장 -->
<script type="text/javascript">

	
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





</body>
</html>