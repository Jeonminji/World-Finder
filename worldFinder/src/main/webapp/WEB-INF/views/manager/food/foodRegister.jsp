<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	
	#registerFood table{
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
	<h1>맛집 작성 페이지</h1>
	
	<div id="registerFood">
		<table>
			<tr>
				<th>나라를 선택해 주세요
				<td><%@ include file="../../include/itemFilter.jsp"%>
				<label id="countryInfo"></label></td>
			<tr>
		</table>
		
		
		<!--  관리자 맛집 게시글
CREATE TABLE FOODPOST_TABLE3 (
   fp_Idx   NUMBER   primary key,
   country   VARCHAR2(50)   references c_class_table3(country),
   fp_Image   VARCHAR2(100),
   fp_Name   VARCHAR2(50)   NOT NULL,
   fp_Address   VARCHAR2(100)   NOT NULL,
   fp_Tel   VARCHAR2(20),
   fp_Category   VARCHAR2(20),
   fp_Menu   VARCHAR2(50),
   reg_Date   DATE   DEFAULT SYSDATE,
   update_Date   DATE
); -->
		
		<table>
		<tbody id="foodDetail">
			<tr>
				<th>상호명을 입력해 주세요</th>
				<td><input type="text" name="fp_Name"></td>
			</tr>
			<tr>
				<th>대표이미지를 등록해 주세요</th>
				<td id="#uploadDiv"><input type="file" name="fp_Image" multiple></td>
			</tr>
			<tr>
				<th>주소를 입력해 주세요</th>
				<td><input type="text" name="fp_Address"></td>
			</tr>
			<tr>
				<th>전화번호를 입력해 주세요</th>
				<td><input type="text" name="fp_Tel"></td>
			</tr>
			<tr>
				<th>대표메뉴를 등록해 주세요</th>
				<td><input type="text" name="fp_Menu"></td>
			</tr>
			<tr>
				<th>식품 분류를 선택해 주세요</th>
				<td>
					<select name="fp_Category">
						<option value="">::유형::</option>
						<option value="한식">한식</option>
						<option value="중식">중식</option>
						<option value="양식">양식</option>
						<option value="일식">일식</option>
						<option value="기타">기타</option>
					</select>
					<label id="ect"></label>
				</td>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="2">
					<button id="insertFood">등록하기</button>
					<button id="cancelFood">취소하고 목록으로</button>
					<form method="post" id="actionForm"></form>
				</td>
			</tr>
		</tfoot>
		</table>	
	</div>



<!-- onload -->
<script type="text/javascript">
	
	$(function(){

		if('${countryInfo.country }' != ''){
			let str = '${countryInfo.continent }' + ' > ' + '${countryInfo.details_continent }' + ' > ' + '${countryInfo.country }';
			$("#countryInfo").html(str);
		}
		else{
			$("#countryInfo").html('');
		}
		
	});
	

</script>

<!-- 기타 버튼 나오기 -->
<script type="text/javascript">

	$("select[name=fp_Category]").change(function(){
		
		if($(this).val() == '기타'){
			let str ='';
			str += '<input type="text" name="ectType">';
			$("#ect").html(str);
		}
		else{
			$("#ect").html('');
		}
		
		
	});

</script>

<!-- 등록하기 버튼 눌렀을때 유효성 검사 후 등록 -->
<script type="text/javascript">
	
	var country = '${countryInfo.country }';
	var fp_Image = '';
	function ranName(e){
		console.log(e)
		country = e;
	}	
	
	function writeCountry(e){
		$("#countryInfo").html(e);
	}

	$("#insertFood").click(function(){
		console.log(country);
		if(country == ''){
			alert("나라를 선택하세요");
			return;
		}
		
		let fp_Name = $("input[name=fp_Name]").val();
		if(fp_Name == ''){
			alert("상호명을 입력하세요");
			return;
		}
		
		//밑의 스크립트 단에서 image 정보 가져옴
		if(fp_Image == ''){
			alert("대표 이미지를 등록하세요");
			return;
		}
		
		let fp_Address = $("input[name=fp_Address]").val();
		if(fp_Address == ''){
			alert("주소를 입력하세요");
			return;
		}
		
		let fp_Tel = $("input[name=fp_Tel]").val();
		if(fp_Tel == ''){
			alert("전화번호를 입력하세요");
			return;
		}
		
		let fp_Menu = $("input[name=fp_Menu]").val();
		if(fp_Menu == ''){
			alert("대표메뉴를 입력하세요");
			return;
		}
		
		let option = $("select[name=fp_Category]").val();
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
				
		
		const actionForm = $("#actionForm");

		actionForm.empty();
			
		actionForm.append("<input type='hidden' name='country' value='" + country + "'/>");
		actionForm.append("<input type='hidden' name='fp_Name' value='" + fp_Name + "'/>");
		actionForm.append("<input type='hidden' name='reg_Date' value='" + '1900-01-01' + "'/>");
		actionForm.append("<input type='hidden' name='fp_Image' value='" + fp_Image + "'/>");
		actionForm.append("<input type='hidden' name='fp_Address' value='" + fp_Address + "'/>");
		actionForm.append("<input type='hidden' name='fp_Tel' value='" + fp_Tel + "'/>");
		actionForm.append("<input type='hidden' name='fp_Category' value='" + option + "'/>");
		actionForm.append("<input type='hidden' name='fp_Menu' value='" + fp_Menu + "'/>");
		
		actionForm.append("<input type='hidden' name='update_Date' value='" + '1900-01-01' + "'/>");
		
		actionForm.attr('action', '/manager/food/foodInsert');
		actionForm.submit();
		
	});	
	
	$("#cancelFood").click(function(){
		
		location.href = "/manager/food/foodList";
		
		
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
	
	
	$("input[name=fp_Image]").on('change', function(){
		var formData = new FormData();
		var inputFile = $("input[name=fp_Image]");
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
				
				fp_Image = '' + result.uuid + '_' + result.fileName;

			}
		});
	});
	
</script>


</body>
</html>