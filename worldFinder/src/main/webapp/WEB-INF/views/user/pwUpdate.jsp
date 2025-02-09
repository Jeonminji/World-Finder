<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
	<style>
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
	<div>
		<h2>비밀번호 변경</h2>
		<form method="get">
			<table>
				<tr>
					<td><input type="password" name="u_pw" placeholder="비밀번호 입력"></td>
				</tr>
				<tr>
					<td><input type="password" name="u_pwck" placeholder="비밀번호 확인"><br> 
				</tr> 
			</table>
		</form>
		<button type="button" class="button button--ujarak button--border-thin button--text-thick" id="fBtn">비밀번호 찾기</button>
	</div>
</body>
</html>