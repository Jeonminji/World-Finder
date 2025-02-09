<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="../../../resources/css/base.css">
    <style>

        .btn {
            border: none;
            display: inline-block;
            text-align: center;
            cursor: pointer;
            text-transform: uppercase;
            outline: none;
            overflow: hidden;
            position: relative;
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            background-color: lightcoral;
            padding: 10px 10px;
            margin: 0 auto;
            box-shadow: 0 5px 15px rgba(0,0,0,0.20);
        }

        .btn span {
            display: inline-block;
            width: 80px;
            position: relative;
            z-index: 1;
        }

        .btn:after {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            height: 250%;
            width: 140%;
            background: #78c7d2;
            -webkit-transition: all .5s ease-in-out;
            transition: all .5s ease-in-out;
            -webkit-transform: translateX(-98%) translateY(-25%) rotate(45deg);
            transform: translateX(-98%) translateY(-25%) rotate(45deg);
        }

        .btn:hover:after {
            -webkit-transform: translateX(-9%) translateY(-25%) rotate(45deg);
            transform: translateX(-9%) translateY(-25%) rotate(45deg);
        }

    </style>
    <style>
        .userBox {
            cursor: pointer;
            background-color: #78c7d2;
            display: inline-block;
            width: 31%;
            max-width: 31%;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.42, 0.0, 0.58, 1.0);
        }

        .userBox:hover {
            box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
            transform: translateY(-10px);
        }
        .userBox * {
            color: white;
            padding: 10px;
        }

        .userBox .postImg {
            display: block;
            width: 100%;
            height: 100px;
            padding: 0;
            object-fit: contain;
        }
        .userBox .heading {
            font-size: 28px;
        }

        .userBox .postData {
            display: flex;
            flex-direction: column;
            font-size: 12px;
            color: #666;
        }

        .userBox .postData span {
            padding: 0;
        }

        .userBox .postData .postData {
            margin-bottom: 2px;
        }

        .userBox .postData .postUserId {
            font-size: 16px;
            color: #000;
            font-weight: 600;
        }

        .userBox .postTexts {
            font-size: 14px;
            line-height: 18px;
        }
    </style>
    <link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
</head>
<body>
    <%@include file="../include/logoSerach.jsp"%>
    <br>
    <div id="body">
        <c:choose>
            <c:when test="${empty countryPage}">
                <h1>죄송합니다 ${reCountry} 에 대한 내용은 준비되지 않았습니다.</h1>
            </c:when>
            <c:otherwise>
                <h1>${countryPage.country} 둘러보기</h1>
                <span>
                    <button id ="itemAll" class="btn"> <span>상품</span></button>
                   <button id ="itemFood" class="btn"> <span>맛집</span></button>
                    <form id="itemForm" method="post" style="display: none">
                        <input type="text" name="country" value="${reCountry}">
                    </form>
                 </span>
                <sec:authorize access="hasAuthority('admin')">
                    <button id="modify" class="button button--ujarak button--border-thin button--text-thick" >수정</button>
                    <script>
                        $("#modify").on('click',()=>{
                            location.href = "/country/modify/${countryPage.country}";
                        })
                    </script>
                </sec:authorize>
                <hr>
                <div id="titleImg"></div>
                <br>
                <div id="content">
                        ${countryPage.content}
                </div>
                <div id="userPost">
                    <br>
                    <hr>
                    <br>
                    <h1>유저 게시글</h1>
                    <div id="postBody">
                        <c:choose>
                            <c:when test="${empty userPostSample}">
                                <h3>작성된 유저게시글이 없습니다</h3>
                            </c:when>
                            <c:otherwise>
                                <%--이미지--%>
                                <c:forEach items="${userPostSample}" var="user">
                                    <span class="userBox" onclick="postGo(${user.up_idx})">
                                        <div style="background-color: white">
                                             <c:choose>
                                                <c:when test="${empty user.thumbnail }">
                                                   <img class="postImg" src="../../../resources/image/logo.jpg">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="postImg" src="${user.thumbnail}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <h1 class="heading">${user.title}</h1>
                                        <div class="postData">
                                            <span class="postData">${user.reg_date}</span>
                                            <span class="postUserId">${user.u_writer}</span>
                                        </div>
                                        <div class="postTexts">${user.hit} ${user.up_like}</div>
                                    </span>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>

                    </div>
                    <div><button id="userPostOther" class="button button--ujarak button--border-medium button--round-s button--text-thick" >더보기</button></div>
                </div>
            </c:otherwise>
        </c:choose>
        <br>
        <br>
        <br>
        <br>
    </div>
    <script !src="">
        const imgEncodeUrl = '${countryPage.c_img}';

        document.getElementById("titleImg").innerHTML =
            `<img src="/country/viewImg?filename=\${encodeURIComponent(imgEncodeUrl)}" width="300px">`;
            // let itemLink;
            // const items = document.querySelectorAll(".btn");
            // items.forEach((e) =>{
            //     e.onclick = function (s){
            //         if (s.target.nodeName.toLowerCase() == 'span'){
            //             alert(1)
            //         }
            //         switch (s.target.getAttribute("data-item")){
            //             case "hotel" :itemLink = "/manager/item/itemList";
            //                 break
            //             case "food" : itemLink = "/manager/food/foodList";
            //                 break
            //             case "view" : itemLink = "/manager/item/itemList";
            //                 break
            //         }
            //         // location.href = itemLink;
            //     }
            // })
             let formData = document.getElementById("itemForm");
            document.getElementById("itemAll").onclick = function () {

                formData.action = '/manager/item/itemList3';
                formData.submit();

            }
            document.getElementById("itemFood").onclick = function (e) {

            	e.preventDefault();
            	alert("준비중입니다!")
                formData.action = '/manager/food/foodList';
                //formData.submit();
            }
            const reCountry = "${reCountry}";
            document.getElementById("userPostOther").onclick = function () {
                location.href = "/userPost/main?country=" + reCountry;
            }
           function postGo(idx){
                location.href = "/userPost/view?up_idx=" + idx +"&country="+reCountry;
           }
    </script>

</body>
</html>