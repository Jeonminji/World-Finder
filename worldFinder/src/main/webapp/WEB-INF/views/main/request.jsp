<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet" href="../../../resources/css/base.css">
    <style>
        #main {
            text-align: left;
        }

        #body{
            text-align: center;
        }

        .cateBtn {
            width: 100px;
            border-radius: 15px;
            background-color: white;
            border: gray 1px solid;
            cursor: pointer;
        }

        .cateBtn:hover {
            border: 3px solid black;
        }

        #select {
            border: 3px solid black;
        }
        #formDiv{
            display: none;
            padding-bottom: 100px;
        }
        .check{
            border: 1px solid red;
        }
        .check:focus{
            border: 1px solid red;
        }
        .alertDiv{
            font-size: 11px;
            color: gray;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="body">
    <%@include file="../include/logo.jsp" %>
    <div id="main">
        <h1>추가 하고싶은 장소</h1>
        <div style="font-size: 15px">리스팅할 새 장소를 알려주세요! 여행자 커뮤니티를 개선하는 데 도움이 됩니다. 시작하기 위해 이 장소에 대해 좀 더 알려주세요</div>
        <br> <br>
        <h2>어떤 장소를 추가하고 싶으신가요?</h2>
        <br>

        <button type="button" class="cateBtn">호텔</button>
        <button type="button" class="cateBtn">식당</button>
        <button type="button" class="cateBtn">관광지</button>
        <br>

        <div id="formDiv">

            <h2>장소 추가하기</h2>
            <br>
            <h2>이곳을 어떻게 찾을 수 있나요?</h2>
            <form method="post">
                <input type="hidden" name="rq_category" value="" id="cate">

                <h3>장소 이름</h3>
                <input type="text" name="rq_name" placeholder="장소명 입력">
                <div class="alertDiv"></div>
                <br>
                <h3>주소</h3>
                <input type="text" name="rq_address" placeholder="주소 입력">
                <div class="alertDiv"></div>
                <br>
                <h3>홈페이지 URL</h3>
                <br>
                <input type="text" name="rq_url" placeholder="url 입력 필수 아님">
                <br>
                <h3>장소 전화번호</h3>
                <br>
                <input type="text" name="rq_tel" placeholder="번호 입력 필수 아님">
                <br>
                <br>
                <input type="submit" value="전송">
            </form>
        </div>

    </div>
</div>
<script>
    const main = $("#main");

    main.on("click", ".cateBtn", function () {
        if (main.find("#select") == $(this)) {
            return;
        } else if (main.find("#select") != $(this) && main.find("#select").length != 0) {
            main.find("#select").removeAttr("id");
        }

        $("#cate").val($(this).text())

        if ($(this).attr("id") != "select") {
            $(this).attr("id", "select");
        }

        $("#formDiv").css("display","block");
    })

    let formD = $("#formDiv form");

    formD.find("[type=submit]").on("click", (e)=>{
        e.preventDefault();
        let rq_name = formD.find("[name=rq_name]")
        let rq_address = formD.find("[name=rq_address]");

        if (rq_name.val() == ""){
            rq_name.next("div").text("값을 입력해 주세요.")
            rq_name.addClass("check");
            rq_name.focus();
            return;
        } else {
            rq_name.removeClass("check");
            rq_name.next("div").text("")
        }

        if (rq_address.val() == ""){
            rq_address.next("div").text("값을 입력해 주세요.")
            rq_address.addClass("check");
            rq_address.focus();
            return;
        } else {
            rq_address.removeClass("check");
            rq_address.next("div").text("")
        }

        formD.action = "/request";
        formD.submit();
    })

</script>
</body>
</html>