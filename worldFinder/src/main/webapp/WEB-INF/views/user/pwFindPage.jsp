<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
	<link rel="stylesheet" href="../../../resources/css/base.css">
	<style>
		#body{
			text-align: center;
		}
		table {
			text-align: center;
			margin: auto;
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
		<h2>비밀번호 찾기</h2>
		<form method="post" id='inform' action="/user/pwFind">
			<table>
				<tr>
					<th>아이디</th>
					<td><input type="text" name="u_writer" placeholder="아이디 입력"></td>
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
					<td>
						<input type="text" class="mail" style="width: 100px" required> @
						<input type="text"  class="mail" style="width: 100px" required>
						<input type="hidden" name="mail" id="mail">
					</td>
				</tr>
				

			</table>
		</form>
		<button type="button" class="button button--ujarak button--border-thin button--text-thick" id="fBtn">비밀번호 찾기</button>
	</div>

	<script type="text/javascript">
		const inform = document.getElementById("inform");
		const phones = document.querySelectorAll(".phone");
		const phoneRule =  /^(01[016789]{1})-[0-9]{4}-[0-9]{4}$/;
		const getMailCheck = /^[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
		document.getElementById("fBtn").onclick = function() {

			if (inform.u_writer.value == "") {
				alert("아이디를 입력하세요.");
				inform.u_writer.focus();
				return;
			}
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

			let formData = new FormData(inform);
			// 장동완 : 너무 ajax만 남발하는거 같아서
			// fetch 사용에 익숙해지려고 사용
			// 프로미스는 어느정도 숙지한 상태 23/08/10
			fetch("/user/pwFindPage", {
				method: "post",
				headers: {},
				body: formData,
			}).then((response) => response.json())
					.then(data => {
						if (data.result){
							inform.submit();
						} else {
							alert("일치하는 데이터를 찾지 못했습니다.")
							inform.reset();
							inform.u_writer.focus();
						}


					}) .catch((error)=> console.log(error));
		};
	</script>
</body>
</html>