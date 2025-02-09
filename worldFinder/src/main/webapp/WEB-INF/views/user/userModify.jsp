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
<link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
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
		<h2> ${vo.u_name}님의 회원정보 수정</h2>
		<form id="join_form" method="post" >
			<table>
				<tr>
					<th>아이디</th>
					<td> ${vo.u_writer} <input type="hidden" name="u_writer" id="user_id" value="${vo.u_writer}" disabled> </td>
				</tr>
				<tr>
					<td><input type="hidden" name="u_name"  id="name" value="${vo.u_name}" disabled> </td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td>
						${vo.birth} <input type="hidden"  id="datepicker" value="${vo.birth}" disabled>
					</td>
				</tr>
				<tr>
					<th>휴대전화</th>
					<td>
						<input type="text"   class="phone" maxlength="3" style="width: 50px"> -
						<input type="text"   class="phone" maxlength="4" style="width: 50px"> -
						<input type="text"   class="phone" maxlength="4" style="width: 50px">
						<input type="hidden" name="phone" id="phone">
					</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td><input type="email" name="mail" id="mail" pattern=".+@gmail\.com" placeholder="example@gmail.com" value="${vo.mail}" required>
						<span id="emailChk"></span> </td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<input type="radio" name="gender" value="남" id="male" disabled>남
						<input type="radio" name="gender" value="여" id="female" disabled>여
					</td>
				</tr>
				<tr>
					<th>국적</th>
					<td><input type="text" name="nationality" id="naion" value="${vo.nationality}" placeholder="대한민국(필수입력)"> </td>
				</tr>
			</table>
			<button type="button" id="signup-btn" class="button button--ujarak button--border-thin button--text-thick">회원 정보 수정</button>
			<button type="reset"  class="button button--ujarak button--border-thin button--text-thick" >취소</button>
		</form>
	</div>
</div>
</body>
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
		var getMailCheck = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var phoneRule =  /^(01[016789]{1})-[0-9]{4}-[0-9]{4}$/;

		// 입력값 중 하나라도 만족하지 못한다면 회원가입 처리를 막기위한 논리형 변수 선언.
		var  chk6 = false, //  연락처
				chk7 = false,  chk9 = false;	// 이메일,  국적



		//회원가입
		// 사용자가 회원 가입 버튼을 눌렀을 때의 이벤트 처리
		$('#signup-btn').click(function (elementId) {
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

			if($('#mail').val() == ""){
				alert("메일주소를 입력해주세요.");
				return;
			}else {
				chk7 = true;
			}


			if($('#naion').val() == ""){
				alert("국적을 입력해주세요.");
				return;
			}else {
				chk9 = true;
			}


			if( chk6 && chk7 && chk9){
				// 모두 true라면
				// 입력값이 모두 제약조건을 통과했다는 뜻

				var id = $('#user_id').val();// 아이디 정보
				var phone = $('#phone').val();
				var mail = $('#mail').val();
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
					'phone' : phone,
					'mail' : mail,
					'nationality' : nationality
				};

				$.ajax({
					type:'put',
					url:"/user/userModify",
					data: JSON.stringify(user),
					contentType : 'application/json; chatset=utf-8',
					// 여러개의 값을 보낼 때는 객체로 포장해서 전송해야함
					// user는 js의 객체이므로 해당 객체를 JSON의 문자열로 변환해야함 ================================
					success: function(result){
						// ajax를 통해 서버에 값을 보내고
						// 서버에서 다시 값을 보내면 result에 들어감
						if (result){
							alert("수정 되었습니다.");
							location.href = '/mypage/main';
						} else {
							alert("수정 실패");
						}
					},
					error : function(){
						alert("수정 실패");
					}

				});

				// end ajax(회원가입 처리)

			} else{
				// 4가지 중 하나라도 false라면
				alert('입력 정보를 다시 확인하세요.');
			}

		}); // 회원 가입 처리 끝
	});
	let femails = document.getElementById("female");
	let male = document.getElementById("male");
	let phone = document.querySelectorAll(".phone");
	onload = function (){
		const oldPhone = "${vo.phone}";
		const oldGender = "${vo.gender}";

		if (oldGender.trim() === "여"){
			femails.checked = true;
		} else {
			male.checked = true;
		}

		let phones = oldPhone.split("-");
		phone[0].value = phones[0];
		phone[1].value = phones[1];
		phone[2].value = phones[2];
	}
</script>
</html>