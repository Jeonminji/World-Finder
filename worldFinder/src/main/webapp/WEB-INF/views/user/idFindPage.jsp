<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<link rel="stylesheet" href="../../../resources/css/base.css">
<link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
<style>
	#body div, h2{
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
<body>
	<div id="body">
		<div>
			<%@include file="../include/logo.jsp"%>
		</div>
		<h2>아이디 찾기</h2>
		<form method="post" class="idFind" id='inform'>
			<table>
				<tr class="form_group">
					<th>성명</th>				
					<td><input type="text" name="u_name" id="name" placeholder="이름입력 (필수입력)"> </td>
				</tr>
				<tr class="form_group">
					<th>연락처</th>				
					<td><input type="text"   class="phone" maxlength="3" style="width: 50px"> -
						<input type="text"   class="phone" maxlength="4" style="width: 50px"> -
						<input type="text"   class="phone" maxlength="4" style="width: 50px">
						<input type="hidden" name="phone" id="phone">
					</td>
				</tr>
				<tr class="form_group">
					<th>이메일</th>				
					<td><input type="text" class="mail" style="width: 100px" required> @
						<input type="text"  class="mail" style="width: 100px" required>
						<input type="hidden" name="mail" id="mail"> </td>
				</tr>


				
				
				<!-- 이름과 전화번호가 일치하지 않을 때-->
<%--		<c:if test="${check == 1}">--%>
<%--			<script>--%>
<%--				opener.document.findform.name.value = "";--%>
<%--				opener.document.findform.phone.value = "";--%>
<%--			</script>--%>
<%--			<label>일치하는 정보가 존재하지 않습니다.</label>--%>
<%--		</c:if>--%>

<%--		<!-- 이름과 비밀번호가 일치하지 않을 때 -->--%>
<%--		<c:if test="${check == 0 }">--%>
<%--		<label>찾으시는 아이디는' ${id}' 입니다.</label>--%>
<%--		<div class="form_group">--%>
<%--				<input class="btn btn-lg btn-secondary btn-block text-uppercase"--%>
<%--					type="submit" value="OK" onclick="closethewindow()">--%>
<%--			</div>--%>
<%--		</c:if>--%>
				
			</table>
			<div style="margin: auto"><button  type="button" class="button button--ujarak button--border-thin button--text-thick" id="fBtn">아이디 찾기</button> </div>
		</form>

		<br>
		<hr>
		<br>
		<div id="resultId">
			<h3></h3>
			<div></div>
		</div>
	</div>
	<script type="text/javascript">
		const inform = document.getElementById("inform");
		const phones = document.querySelectorAll(".phone");
		const phoneRule =  /^(01[016789]{1})-[0-9]{4}-[0-9]{4}$/;
		const getMailCheck = /^[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
		document.getElementById("fBtn").onclick = function() {

			if (inform.u_name.value == "") {
				alert("아이디를 입력하세요.");
				inform.u_name.focus();
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
			}

			let formData = new FormData(inform);
			// 장동완 : 너무 ajax만 남발하는거 같아서
			// fetch 사용에 익숙해지려고 사용
			// 프로미스는 어느정도 숙지한 상태 23/08/10
			fetch("/user/idFind", {
				method: "post",
				headers: {},
				body: formData,
			}).then((response) => response.text())
					.then(data => {
						if (data == ""){
							$('#resultId h3').html(inform.u_name.value + "님의 아이디가 존재하지 않습니다");
						} else {
							$('#resultId h3').html(inform.u_name.value + "님의 아이디");
							$('#resultId div').html(data);
						}
					})
					.catch((error)=> console.log(error));
		};
	</script>
</body>



</html>