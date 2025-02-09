<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
    <link rel="stylesheet" href="../../../resources/css/base.css">
    <style>
        a{
            text-decoration: none;
            color: gray;
        }
        a:visited{
            color: gray;
        }
    </style>
</head>
<body>
    <%@include file="../include/logoSerach.jsp"%>

    <div id="body">
        <h2>${details_continent} 나라 리스트</h2>
        <br>
        <hr>
        <br>
        <c:choose>
            <c:when test="${empty countryList}">
                <h3>${details_continent} 나라 리스트가 존재하지 않습니다</h3>
            </c:when>
            <c:otherwise>
                <c:forEach var="country" items="${countryList}">
                    <a href="/country/${country}">${country}</a> <br>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
<script>
        // 주소값에 담긴 값을 h2에 넣어줄려했지만 그냥 컨트롤러에서 속성 보내주는걸로 처리
        // console.log(window.location.href)
</script>
</body>
</html>