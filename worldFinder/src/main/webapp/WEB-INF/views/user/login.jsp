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
<body>
	<c:choose>
		<c:when test="${login gt 0 }">
			<script type="text/javascript">
				alert("로그인 되었습니다.");
				location.href= '/';		 
				
			</script>
		</c:when>
		<c:otherwise>
			<script type="text/javascript">
				alert("아이디 또는 비밀번호가 맞지 않습니다.");
				history.go(-1);		
			</script>
		</c:otherwise>
	</c:choose>
</body>
</html>