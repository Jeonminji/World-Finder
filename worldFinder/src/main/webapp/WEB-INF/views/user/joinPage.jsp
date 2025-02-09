<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">

</style>
</head>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="../../../resources/css/base.css">
<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
	#body div{
		text-align: center;
	}
	table {
		text-align: center;
		margin: auto;
	}
	#idCk, #pwChk, #pwChk2{
		position: absolute;
	}
	td input {
		padding: 0 1em;
		border: 0;
		height: 38px;
		border-radius: 30px;
		background-color:  #f1f3f5;
	}
	td input:focus {
		outline: none;
	}
	td input::placeholder {
		font-weight: 300;
		color: #aaa;
	}
</style>
<body>
	<div id="body">
		<div>
			<%@include file="../include/logo.jsp"%>
		</div>
		<div>
			<h2>회원가입</h2>
			<form id="join_form" method="post" >
				<table>
					<tr>
						<th>아이디</th>
						<td><input type="text" name="u_writer" id="user_id"
							class="form-control tooltipstered" maxlength="14"
							required="required" aria-required="true"
							placeholder="문자, 숫자포함(필수 입력)">
							<span id="idCk"></span> </td>
					</tr>
					<tr>
						<th>비밀번호 입력</th>
						<td><input type="password" name="u_pw" id="password" placeholder="비밀번호 입력(필수입력)" maxlength="24">
							<span id="pwChk"></span> </td>
					</tr>
					<tr >
						<th>비밀번호 확인</th>
						<td><input type="password" name="u_pw" placeholder="비밀번호를 한번 더 입력해 주세요." id="password_check" maxlength="24">
							<span id="pwChk2"></span> </td>
					</tr>
					<tr  >
						<th>성명</th>
						<td><input type="text" name="u_name" id="name" placeholder="이름입력 (필수입력)"> </td>
					</tr>
					<tr  >
						<th>생년월일</th>
						<td>
							<input type="text" name="birth" id="datepicker" >
						</td>
					</tr>
					<tr  >
						<th>휴대전화</th>
						<td>
							<input type="text"   class="phone" maxlength="3" style="width: 50px"> -
							<input type="text"   class="phone" maxlength="4" style="width: 50px"> -
							<input type="text"   class="phone" maxlength="4" style="width: 50px">
							<input type="hidden" name="phone" id="phone">
						</td>
					</tr>
					<tr >
						<th>이메일</th>
						<td>
							<input type="text" class="mail" style="width: 100px" required> @
							<input type="text"  class="mail" style="width: 100px" required>
							<input type="hidden" name="mail" id="mail">
							<span id="emailChk"></span> </td>
					</tr>
					<tr >
						<th>성별</th>
						<td>
							<input type="radio" name="gender" value="남" id="male" checked="checked">남
							<input type="radio" name="gender" value="여" id="female">여
						</td>
					</tr>
					<tr>
						<th>국적</th>
						<td><input type="text" name="nationality" id="naion" placeholder="대한민국(필수입력)"> </td>
					</tr>
				</table>
				<button class="button button--ujarak button--border-thin button--text-thick" type="button"  id="signup-btn">회원가입</button>
				<button class="button button--ujarak button--border-thin button--text-thick" type="reset" >취소</button>
			</form>
		</div>
	</div>
</body>
<script>
	$(function() {
		// 날짜 api 사용
		//input을 datepicker로 선언
		$("#datepicker").datepicker({
			dateFormat: 'yy-mm-dd' //달력 날짜 형태
			,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
			,changeYear: true //option값 년 선택 가능
			,changeMonth: true //option값  월 선택 가능
			,yearSuffix: "년" //달력의 년도 부분 뒤 텍스트
			,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
			,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
			,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 텍스트
			,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip
			,minDate: "-100Y" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
			,maxDate: "-1D" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)
		});

		//초기값을 오늘 날짜로 설정해줘야 합니다.
		$('#datepicker').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
	});
</script>
<script type="text/javascript">
	window.onpageshow = function(event) {
		if ( event.persisted || (window.performance && window.performance.navigation.type == 2)) {
			document.getElementById("join_form").reset();
			$("#join_form span").html("");
		}
	}


	// 회원가입 버튼 이벤트
	/*
	$(document).ready(function() {
		//회원가입 버튼(회원가입 기능 작동)
		$(".join_button").click(function() {
			$("#join_form").attr("action", "/user/join");
			$("#join_form").submit();
		});
	});
	*/
	// 아이디 중복 체크-----------------------------------------------------------------------------
	$(function (string) {
    //각 입력값들의 유효성 검증을 위한 정규표현식을 변수로 선언.
       var getIdCheck = /^[0-9a-z]{8,16}$/;
	   const speidCheck = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/g;
       var getPwCheck = RegExp(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
       var getMailCheck = /^[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
		var phoneRule =  /^(01[016789]{1})-[0-9]{4}-[0-9]{4}$/;
       
    // 입력값 중 하나라도 만족하지 못한다면 회원가입 처리를 막기위한 논리형 변수 선언.
   	 var chk1 = false, chk2 = false, chk3 = false, // 아이디, 비번, 비번확인
   	 	chk4 = false, chk5 = false, chk6 = false, // 이름, 생년월일, 연락처
   	 	chk7 = false, chk8 = true, chk9 = false;	// 이메일, 성별, 국적
   	    
    //회원가입시 사용자의 입력값 검증!
    //1. ID입력값 검증 ------------------------------------------------------------
    $('#user_id').keyup(function() {
       if($(this).val() === '' ) { // 아이디 공백일 경우
          $(this).css(' border-color', 'red');
          $('#idCk').html('<b style="font-size: 14px; color: red">아이디는 필수로 입력하세요.</b>');//텍스트를 집어넣을거야 
          chk1 = false;
       }
     //정규표현식변수.test('검증하고 싶은 값')  => return boolean type
     //정규표현식이 맞으면true 아니면 false
	   else if (this.value.search(speidCheck) > -1){
		   $(this).css(' border-color', 'red');
		   $('#idCk').html('<b style="font-size: 14px; color: red">특수문자는 사용할수 없습니다.</b>');
		   chk1 = false;
	   } else if(!getIdCheck.test($(this).val())) {//정규표현식이 틀렸다면
    	  $(this).css(' border-color', 'red');
          $('#idCk').html('<b style="font-size: 14px; color: red">8자이상 16자이내로 입력하세요.</b>');
          chk1 = false;
       } else{
       	//ID중복 확인 통신을 위해 입력값을 가져오기
       	var id = $(this).val();
       
       	//ajax 호출.
       	$.ajax({
       		 type :'post', // 서버에 전송하는 http방식
       		 url :'/user/checkId', // 서버 요청 url
       		 contentType : 'application/json; chatset=utf-8',
       		 dataType : 'text', //서버로 부터 응답받을 데이터의 형태 
      		 data : id, // 서버로 전송할 데이터 // 위에서 지정한 const id 
      		 success : function(result) { // 매개변수에 통신성공시 데이터가 저장된다.
					//서버와 통신성공시 실행할 내용 작성.
					console.log('통신 성공!' + result);
      		 	if(result === 'available'){
      		 		 $('#idCk').html('<b style="font-size: 14px; color: blue">현재 아이디 사용가능.</b>');
      		 		 chk1 = true;
      		 	}else{
      		 		 $(this).css(' border-color', 'red');
      		 		 $('#idCk').html('<b style="font-size: 14px; color: red">아이디가 이미 존재합니다.</b>');
      		 		 chk1 = false;
      		 	}
				},
				error : function (status, error) { //통신에 실패했을때
					console.log('통신실패');
					console.log(status, error)
				}
        	}); // end ajax(아이디 중복 확인)
       }
    })
    
 	// 2. PW 입력값 검증 -------------------------------------------------------------------------
  	$('#password').keyup(function() {



  		
  		// 비밀번호 공백 확인 
  		if ($(event.target).val() === ''){
			$('#pwChk').html('<b style="font-size: 14px; color:red">[비밀번호를 입력해주세요]</b>');
			chk2 = false;
			// 입력했다가 다시 잘못입력할 수 있으므로 모든 조건식에 넣어야함
  		}
  		// 비밀번호 유효성 검사 
  		else if (!getPwCheck.test($(event.target).val()) || $(event.target).val().length < 8){
			$('#pwChk').html('<b style="font-size: 14px; color:red">[비밀번호는 특수문자 포함 8자 이상입니다.]</b>');
			chk2 = false;
			// 입력했다가 다시 잘못입력할 수 있으므로 모든 조건식에 넣어야함
  		}
  		// 통과 
  		else{
			$('#pwChk').html('<b style="font-size: 14px; color:blue">[비밀번호 사용가능.]</b>');
			chk2 = true;
			// 입력값 검증 성공 표시 
  		}
  	});
  	// PW 검증 끝
  	
  	// 3. PW 확인란 검증 -----------------------------------------------------------
  	$('#password_check').keyup(function() {
  		
  		// 비밀번호 확인 공백 검증
  		if ($(event.target).val() === ''){
			$('#pwChk2').html('<b style="font-size: 14px; color:red">[비밀번호 확인은 필수 정보 입니다.]</b>');
			
			chk3 = false;
			// 입력했다가 다시 잘못입력할 수 있으므로 모든 조건식에 넣어야함
			
		// 비밀번호 확인란 유효성 검증 (일치하는지)
  		} else if($(event.target).val() !== $('#password').val()){
  			// 값들이 같지 않다면
			$('#pwChk2').html('<b style="font-size: 14px; color:red">[입력한 비밀번호가 일치하지 않습니다.]</b>');
			
			chk3 = false;
			// 입력했다가 다시 잘못입력할 수 있으므로 모든 조건식에 넣어야함
  		}else{
			$('#pwChk2').html('<b style="font-size: 14px; color:skyblue">[비밀번호 확인 완료.]</b>');
			
			chk3 = true;
  		}
  	});
  	// PW 확인 검증 끝

   
	//회원가입
	    // 사용자가 회원 가입 버튼을 눌렀을 때의 이벤트 처리 
      	$('#signup-btn').click(function (elementId) {
		// input 공백 체크 -----------------------------------------  
      		if($('#user_id').val() == ""){
				alert("아이디를 입력해주세요.");
				return;
			}
      		if($('#password').val() == ""){
				alert("비밀번호를 입력해주세요.");
				return;
			}
      		if($('#password_check').val() == ""){
				alert("비밀번호를 재입력 하세요.");
				return;
			}

			if($('#name').val() == ""){
				alert("이름을 입력해주세요.");
				return;
			}else {
				chk4 = true;
			}
			if($('#datepicker').val() == "") {
				alert("생년월일을 입력해주세요.");
				return;
			} else {
				chk5 = true;
			}

			const phones = document.querySelectorAll(".phone");

			if(phones[0].value == "" || phones[1].value == "" || phones[2].value == ""){
				alert("연락처를 입력해주세요.");
				return;
			} else {
				document.getElementById("phone").value = phones[0].value +"-"+  phones[1].value +"-"+ phones[2].value;
			}
			let result = document.getElementById("phone").value;
			if (!phoneRule.test(result)){
				alert("연락처를 올바르게 입력해주세요.");
				return;
			}else {
				chk6 = true;
			}

			const mails = document.querySelectorAll(".mail");
			const chkMail = document.getElementById("mail");

			if(mails[0].value == "" || mails[1].value == ""){
				alert("메일주소를 입력해주세요.");
				return;
			} else {
				chkMail.value = mails[0].value + "@" + mails[1].value;
			}

			if (!getMailCheck.test(chkMail.value)){
				alert("메일주소를 올바르게 입력해주세요.")
				mails[0].focus();
				return;
			} else {
				chk7 = true;
			}
			
			
			if($('#naion').val() == ""){
				alert("국적을 입력해주세요.");
				return;
			}else {
				chk9 = true;
			}
			
		
      		if(chk1 && chk2 && chk3 && chk4 && chk5 && chk6 && chk7 && chk8 && chk9){
      			// 모두 true라면
      			// 입력값이 모두 제약조건을 통과했다는 뜻 

      			var id = $('#user_id').val();// 아이디 정보
      			var pw = $('#password').val();// 비밀번호 정보
      			var name = $('#name').val();// 이름 정보
      			var birth = $("#datepicker").val();
      			var phone = $('#phone').val();
      			var mail = $('#mail').val();
      			var gender = document.getElementById("join_form").gender.value;
      			var nationality = $('#naion').val();

      			/*alert(id);
      			alert(pw);
      			alert(name);
      			alert(birth);
      			alert(phone);
      			alert(mail);
      			alert(gender);
      			alert(nationality);*/

   				// 여러개의 값을 보낼 때는 객체로 포장해서 전송해야함
   				// 객체의 property이름은 VO 객체의 변수명과 동일하게 (커맨드 객체 사용하기 위해)
      			var user = {
      					'u_writer' : id,
      					'u_pw' : pw,
      					'u_name' : name,
      					'birth' : birth,
      					'phone' : phone,
      					'mail' : mail,
      					'gender' : gender,
      					'nationality' : nationality
      			};
      			// 아직은 js객체이므로 JSON으로 변환해서 ajax의 data에 넣어야함


				// 장동완 : json 으로 넣는것도 가능하지만 form데이터 자체를 보낼수도 있음 $(f).serialize()
				// 하지만 원본을 거의 건들지 않은 상황에서 수정할 예정
      			$.ajax({
      				type:'POST',
      				url:'/user/join',
      				data: JSON.stringify(user),
      				contentType : 'application/json; chatset=utf-8',
       				// 여러개의 값을 보낼 때는 객체로 포장해서 전송해야함
       				// user는 js의 객체이므로 해당 객체를 JSON의 문자열로 변환해야함 ================================ 
					success: function(result){
						// ajax를 통해 서버에 값을 보내고 
						// 서버에서 다시 값을 보내면 result에 들어감
						console.log('통신 성공 : ' + result);
						alert("회원가입 되었습니다.");
						location.href = '/user/loginPage';
					}, 
					error : function(){
						alert("회원가입 실패");
					}
      				
      			}); 
      			
      			// end ajax(회원가입 처리)
      			
      		} else{
      			// 4가지 중 하나라도 false라면 
      			alert('입력 정보를 다시 확인하세요.');
      	}
      		
      	}); // 회원 가입 처리 끝
});      	
</script>
</html>