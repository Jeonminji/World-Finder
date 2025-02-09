<%--
  Created by IntelliJ IDEA.
  User: goott1
  Date: 2023-07-27
  Time: 오후 12:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <link rel="stylesheet" href="../../../resources/css/base.css">
</head>
<body>
  <div id="body">
    <%@include file="../include/logo.jsp" %>
      <div id="main">
        <c:choose>
          <c:when test="${result gt  0}">
              <h1>의견 감사드립니다!</h1>
          </c:when>
          <c:otherwise>
              <h1>작성에 실패했습니다!</h1>
          </c:otherwise>
        </c:choose>
        <button id="btn">메인으로 돌아가기</button>
      </div>
  </div>
  <script !src="">
      document.getElementById("btn").onclick = function () {
          location.href = "/";
      }
  </script>
</body>
</html>
