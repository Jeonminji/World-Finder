<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="../../../resources/css/base.css">
	<style>
		#body{
			text-align: center;
		}
		table {
			text-align: center;
			margin: auto;
		}
		tr span {
			position: absolute;
		}
		td input {
			padding: 0 1em;
			border: 0;
			height: 38px;
			width: 100%;
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
</head>
<body>
<div id="body">
	<div>
		<%@include file="../include/logo.jsp"%>
	</div>
	<h2>비밀번호 변경 페이지</h2>
	<form  id='inform'>
		<table>
			<tr>
				<td><input type="password" name="u_pw" placeholder="비밀번호 입력"> <span id="checkPw"></span>
				 <br> <input type="password" name="u_pw_check" placeholder="비밀번호 확인"> </td>

				<td>
					<input type="hidden" name="u_writer" value="${vo.u_writer}">
					<input type="hidden" name="phone" value="${vo.phone}">
					<input type="hidden" name="mail" value="${vo.mail}">
				</td>
			</tr>


		</table>
	</form>
	<input type="button" id="fBtn" value="비밀번호 변경">
</div>

<script type="text/javascript">
	const inform = document.getElementById("inform");
	const getPwCheck = RegExp(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
	const checkPw = document.getElementById("checkPw");
	let chk1 = false;
	inform.u_pw.addEventListener('keyup',(e) =>{
		if (!getPwCheck.test(e.target.value) || e.target.value.length < 8){
			checkPw.innerHTML = '<b style="font-size: 14px; color:red">[비밀번호는 특수문자 포함 8자 이상입니다.]</b>';
			chk1 = false;
			// 입력했다가 다시 잘못입력할 수 있으므로 모든 조건식에 넣어야함
		} else {
			checkPw.innerHTML = '<b style="font-size: 14px; color:blue">[비밀번호 사용가능.]</b>';
			chk1 = true;
		}
	})


	document.getElementById("fBtn").onclick = function() {
		if (inform.u_pw.value == "") {
			alert("비밀번호를 입력하세요.");
			inform.u_pw.focus();
			return;
		}
		if (!chk1){
			alert("비밀번호를 정확히 입력하세요.");
			inform.u_pw.focus();
			return;
		}
		if (inform.u_pw_check.value == "") {
			alert("비밀번호를 확인란을 입력해주세요.");
			inform.u_pw_check.focus();
			return;
		}
		if (inform.u_pw.value != inform.u_pw_check.value) {
			alert("비밀번호가 일치하지 않습니다")
			inform.u_pw_check.focus();
			return;
		}

		inform.u_pw_check.disabled = true;

		let formData = new FormData(inform);
		// 장동완 : 너무 ajax만 남발하는거 같아서
		// fetch 사용에 익숙해지려고 사용
		// 프로미스는 어느정도 숙지한 상태 23/08/10
		fetch("/user/pwFind", {
			method: "put",
			headers: {},
			body: formData,
		}).then((response) => response.json())
				.then(data => {
					console.log(data)
					if (data.result){
						alert("변경이 완료되었습니다.")
						location.replace("/user/loginPage");
					} else{
						alert("데이터 변경에 실패하였습니다")
						inform.reset();
						inform.u_pw.focus();
						inform.u_pw_check.disabled = false;
						checkPw.innerHTML = "";
					}
				})
				.catch((error)=> console.log(error));
	};
</script>
</body>
</html>