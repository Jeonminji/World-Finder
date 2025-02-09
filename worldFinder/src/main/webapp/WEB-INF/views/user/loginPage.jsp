<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	#body div{
		text-align: center;
	}
	table {
		text-align: center;
		margin: auto;
	}
	a{
		text-decoration: none;
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
<%--중간부터 장동완 진행--%>
<div id="body">
	<div>
		<%@include file="../include/logo.jsp"%>
	</div>
	<div>
		<h2>Login</h2>
		<form role="form" method="post" action="/login"  id="loginForm">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csfr.token }">
			<table>
				<tr>
					<td><input type="text" name="username" placeholder="아이디" id="signInId" >
						<span id="idCheck"></span></td>
				</tr>
				<tr>
					<td><input type="password" name="password" placeholder="비밀번호" id="signInPw">
						<span id="pwCheck"></span></td>
				</tr>
				<tr>
					<td>
						<!-- <input type="checkbox" id="remember_check">아이디 저장하기 -->
					</td>
				</tr>
				<tr>
					<td colspan="2" >
						<button class="button button--ujarak button--border-thin button--text-thick"
								type="button" id="signIn-btn" value="로그인">로그인</button>
						<c:if test="${user == 'faile' }">
							<div style="color: red">
								아이디 또는 비밀번호가 일치하지 않습니다.
							</div>
						</c:if>
						<c:if test="${user == 'logout'}">
							<div style="color: red">
								로그아웃되었습니다.
							</div>
						</c:if>
						<button class="button button--ujarak button--border-thin button--text-thick"
								type="button" id="goJoin" value="회원가입" onClick="location.href='/user/joinPage'">회원가입</button>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<a style="border: none;" class="button button--ujarak button--border-medium button--round-s button--text-thick" href="/user/idFindPage" class="btnIdP">아이디  찾기</a>
						<a style="border: none;" class="button button--ujarak button--border-medium button--round-s button--text-thick" href="/user/pwFindPage" class="btnPwP">비밀번호  찾기</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>

</body>
<script type="text/javascript">
	// 로그인
	$(document).ready(function() {
		$("#signIn-btn").click(function() {
			var id = $("#signInId").val();
			var pw = $("#signInPw").val();
			if (id == "") {
				alert("아이디를 입력하세요.");
				$("#signInId").focus();
				return;
			}
			if (pw == "") {
				alert("비밀번호를 입력하세요.");
				$("#signInPw").focus
				return;
			}
			$("#loginForm").submit();
		});
	});

	
</script>
</html>