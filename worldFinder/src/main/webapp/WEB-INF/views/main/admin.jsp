<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
    <link rel="stylesheet" href="../../../resources/css/base.css">
    <style>
        #viewDetails , #viewComment{
            display: none;
            width: 1000px;
            height: 600px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            z-index: 10;
        }
        #menu {
            width: 80%;
            margin: 10px auto auto;
            text-align: center;
            padding-top: 5px;
            padding-bottom: 5px;
        }
        #menu span button{
            margin-right: 15px;
            cursor: pointer;
        }
        table{
            margin:auto;
            margin-top: 20px;
        }
        #commentReport th , #userReport th{
            width: 160px;
        }
        #request th{
            width: 160px;
        }
        #request,#commentReport,#userReport{
            display: none;
        }
        #body{
            text-align: center;
        }
        a{
            color: black;
            text-decoration: none;
        }
        a:visited{
            color: black;
        }
        .pageClick{
            display: inline-block;
            width: 50px;
            cursor: pointer;
        }
        #editor img {
            max-width: 70%;
        }
        #editor , #repCommentList {
            overflow: auto;
        }
        #repMenu, #viewComment{
            padding: 10px;
            border: 1px solid gray;
        }
    </style>
    <style>
        table {
            border: 1px #99ccff solid;
            font-size: .9em;
            box-shadow: 0 2px 5px rgba(0,0,0,.25);
            width: 100%;
            border-collapse: collapse;
            border-radius: 5px;
            overflow: hidden;
        }

        th {
            text-align: center;
        }

        thead {
            font-weight: bold;
            color: #fff;
            background: #99ccff;
        }

        td, th {
            padding: 1em .5em;
            vertical-align: middle;
        }

        td {
            border-bottom: 1px solid rgba(0,0,0,.1);
            background: #fff;
        }

        a {
            color: #73685d;
        }


        @media all and (max-width: 768px) {

            table, thead, tbody, th, td, tr {
                display: block;
            }

            th {
                text-align: right;
            }

            table {
                position: relative;
                padding-bottom: 0;
                border: none;
                box-shadow: 0 0 10px rgba(0,0,0,.2);
            }

            thead {
                float: left;
                white-space: nowrap;
            }

            tbody {
                overflow-x: auto;
                overflow-y: hidden;
                position: relative;
                white-space: nowrap;
            }

            tr {
                display: inline-block;
                vertical-align: top;
            }

            th {
                border-bottom: 1px solid #99ccff;
            }

            td {
                border-bottom: 1px solid #e5e5e5;
            }
        }
    </style>
</head>
<body>
    <div id="body">
        <%@include file="../include/logo.jsp"%>
        <div id="menu">
            <span   data-menu="report" data-report="userPost"><button class="button button--ujarak button--border-thin button--text-thick"> 게시글 신고 내용 </button></span>
            <span  data-menu="report" data-report="comment"><button class="button button--ujarak button--border-thin button--text-thick">댓글 신고 내용 </button></span>
            <span data-menu="request"><button class="button button--ujarak button--border-thin button--text-thick">건의 사항 </button></span>
        </div>
        <hr>
        <div id="main">
            <div id="userPost">
                <div id="userReport">
                    <table>
                        <thead>
                            <tr>
                                <th>신고된 게시글 본문</th>
                                <th>신고 사유</th>
                                <th>신고 날짜</th>
                                <th>신고 당한 횟수</th>
                                <th>신고 삭제</th>
                            </tr>
                        </thead>
                        <tbody id="userReportTbody">
                            <tr>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="commentReport">
                    <table>
                        <thead>
                        <tr>
                            <th>신고된 댓글 본문</th>
                            <th>신고 사유</th>
                            <th>신고 날짜</th>
                            <th>신고 당한 횟수</th>
                            <th>신고 삭제</th>
                        </tr>
                        </thead>
                        <tbody id="commentTbody">
                            <tr>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="request">
                    <table>
                        <thead >
                        <tr>
                            <th>유형</th>
                            <th>장소명</th>
                            <th>주소</th>
                            <th>전화 번호</th>
                            <th>URL</th>
                        </tr>
                        </thead>
                        <tbody id="requestMain">
                        </tbody>
                    </table>
                    <!-- page -->
                </div>
            </div>
            <div id="paging">
            </div>
        </div>
    </div>
    <div id="viewDetails">
        <div id="repMenu" style="height: 100%">
            <h2 id="req_title"></h2>
            <br>
            작성자 <div id="req_writer"></div>
            <br>
            내용
            <hr>
            <div id="editor" contenteditable="false" style="overflow: auto"></div>
            <br>
        </div>
        <button type="button"onclick="closeRep()">닫기</button>
    </div>
    <div id="viewComment">
        <div id="repCommentList" style="height: 100%">

        </div>
        <div style="margin-top: 30px">
            <button type="button"onclick="closeRep()">닫기</button>
        </div>
    </div>

    <script !src="">
        const paging = $("#paging");
        const menu = document.querySelector("#menu").getElementsByTagName("span");
        const userReport = document.getElementById("userReport");
        const commentReport = document.getElementById("commentReport");
        const request = document.getElementById("request");

        // 제이쿼리 말고도 자바스크립트로 구현

        [].forEach.call(menu, function(e){
            e.onclick = function () {
                paging.html("");
                if (userReport.style.display === "block" &&
                    this.dataset.report === "userPost") {
                    userReport.style.display = "none";

                } else if (request.style.display === "block" &&
                    this.dataset.menu === "request") {
                    request.style.display = "none";

                } else if (commentReport.style.display === "block" &&
                    this.dataset.report === "comment") {

                    commentReport.style.display = "none";
                } else {

                    if ( userReport.style.display == "block"){
                        userReport.style.display = "none";

                    } else if (request.style.display == "block") {
                        request.style.display = "none";
                    } else if (commentReport.style.display == "block"){
                        commentReport.style.display = "none";
                    }


                    if (this.dataset.report == "userPost"){
                        // $(this).find("button").css("color","#fff")
                        // $(this).find("button").css("backgroundColor","#37474f")
                        reportAjax("post","1");
                        userReport.style.display = "block";
                    } else if (this.dataset.menu === "request") {
                        requestAjax('1');
                        request.style.display = "block";
                    } else if (this.dataset.report == "comment"){
                        reportAjax("comment","1");
                        commentReport.style.display = "block";
                    }

                }

            }
        })

    /*    if ((report.style.display === "block" &&
                this.dataset.report === "userPost" &&
                reportTitle.innerHTML === "게시글 제목") ||
            (report.style.display === "block" &&
                this.dataset.report === "comment" &&
                reportTitle.innerHTML === "댓글 제목")) {

            report.style.display = "none";

        }*/


        function reportAjax(a,pageNum) {
            $.ajax({
                url: "/adminPage/getReport/"+a+"/"+pageNum ,
                dataType : "json",
                type : "post",
                success : function (datas) {
                    if (datas.reportVO.length == 0){
                        reportTbody.html(emptyValue);
                        commentTbody.html(emptyValue);
                    } else {
                        userReportTable(datas, a)
                    }
                },
            })
        }

        const reportTbody = $("#userReportTbody");
        const commentTbody = $("#commentTbody");
        const emptyValue = "<tr> <td colspan='5'> 신고된 항목이 없습니다 </td> </tr>";

        function userReportTable(datas, a) {

            let texts = "";

            datas.reportVO.forEach((d) => {
                let date = new Date(d.reg_date);
                let dates = date.getFullYear() + "년 " + (date.getMonth()+1) + "월 " + date.getDate() + "일"
                    texts += `<tr>`;
                    texts += `<td> <b style="cursor: pointer" onclick="repPostGo(\${d.idx},'\${d.r_category}')">본문 보기</b> </td>
                    <td> <b style="cursor: pointer" onclick="repReason(\${d.idx},'\${d.r_category}')">신고 사유</b> </td>
                    <td>\${dates} </td>
                    <td> \${d.r_count} </td>
                    <td> <button type="button" onclick="blind(\${d.idx},'\${d.r_category}')">블라인드 처리</button> </td>
                    </tr>`;
            })

            if (a == "post"){
                reportTbody.html(texts)

            } else if (a == "comment") {
                commentTbody.html(texts)

            }

            allPaging(datas.reqPageMaker , a);
        }
    </script>

    <%--건의사항 페이지 처리--%>
    <script>
        const requestMain = $("#requestMain");
        function requestAjax(d) {
            $.ajax({
                url: "/adminPage/getRequest/" + d ,
                dataType : "json",
                type : "post",
                success : function (datas) {
                    InsertRequest(datas)
                },
            })
        }

        function InsertRequest(data) {
            let texts = "";
            (data.requestVO).forEach((d) => {
                texts += `<tr>`;
                texts +=
                        `<td>\${d.rq_category} </td>
                        <td> \${d.rq_name} </td>
                        <td> \${d.rq_address} </td>`;

                texts += d.rq_tel == null ? `<td>없음</td>` : `<td>\${d.rq_tel} </td>`;
                texts += d.rq_url == null ? `<td>없음</td>` : `<td>\${d.rq_url} </td>`;

            })



            if (texts == ""){
                requestMain.html('<td colspan="5">건의 사항이 없습니다.</td>');
            } else {
                requestMain.html(texts);
            }

            allPaging(data.reqPageMaker , '건의사항')

        }

        // 같은 페이지 클릭 금지
        paging.on('click','.pageClick',(e) =>{
            if ($("#nowPageNum").val() == e.target.innerText){
                return;
            }

            if (document.getElementById("nowPageNum").value == "유저"){
                reportAjax("post",e.target.innerText);
            } else if (document.getElementById("nowPageNum").value == "comment")  {
                reportAjax("comment", e.target.innerText);
            } else {
                requestAjax(e.target.innerText);
            }
        })

        // 페이지 버튼 생성
        function allPaging(data , a) {
            console.log(data)
            console.log(a)
            let pageText = "";
            // 페이지 처리
            pageText += "<div>";

            if (data.prev){
                pageText +=  `<span >` + '<a href="' + ${data.endPage+1 } + '">&lt;</a> +</span>'
            }

            for (let i = data.startPage ; i <= data.endPage; i++){
                pageText += "<span class='pageClick'> " + i + "</span>";
            }

            if (data.next){
                pageText +=  `<span >` + '<a href="' + ${data.endPage+1 } + '">&lt;</a> +</span>'
            }
            pageText += `<input type="hidden" id="nowPageType" data-page ="\${a}" value="\${a}" />`;
            pageText += `<input type="hidden" id="nowPageNum" data-pageType ="nowPageNum" value="\${data.cri.pageNum}" />`;
            pageText += "</div>"

            paging.html(pageText)
        }
    </script>
    <script>
        userReport.style.display = "block";
        reportAjax("post","1");

        const viewDetails = document.getElementById("viewDetails");
        const viewComment = document.getElementById("viewComment");
        function repReason(a,b){
            let json = {
                'r_category' : b,
                'idx' : a
            }

            fetch("/admin/repReason", {
                method: "post",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(json)
            }).then((response) => response.json())
                .then(data => {
                    let text = "";
                    document.body.style.background = "rgba(0, 0, 0, 0.5)";
                    document.getElementById("logo").style.opacity = "0.1";
                    viewComment.style.display = "inline-block";
                    data.forEach((d) =>{
                        text +=`<div>\${d.R_CONTENT}</div> <hr>`;
                    })
                    document.getElementById("repCommentList").innerHTML = text;
                    document.getElementById("logo").style.cursor = "default";
                    document.getElementById("logo").removeEventListener("click", homeGoLogo);

                }) .catch((error)=> console.log(error));
        }
        function repPostGo(a,b){
           let json = {
                'r_category' : b,
                'idx' : a
            }
            console.log(json)
            fetch("/admin/repPost", {
                method: "post",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(json)

            }).then((response) => response.json())
                .then(data => {
                    let keys = Object.keys(data)
                    document.getElementById("req_writer").innerHTML = data.u_writer;
                    if (keys.includes('up_content')){
                        document.getElementById("editor").innerHTML = data.up_content;
                        document.getElementById("req_title").innerHTML = (data["title"]);
                    } else if (keys.includes('c_content')) {
                        document.getElementById("req_title").innerHTML = "";
                        document.getElementById("editor").innerHTML = data.c_content;
                    } else if (keys.includes('nc_content')){
                        document.getElementById("req_title").innerHTML = "";
                        document.getElementById("editor").innerHTML = data.nc_content;
                    }
                    document.body.style.background = "rgba(0, 0, 0, 0.5)";
                    viewDetails.style.display = "inline-block";
                    document.getElementById("logo").style.opacity = "0.1";
                    document.getElementById("logo").style.cursor = "default";
                    document.getElementById("logo").removeEventListener("click", homeGoLogo);

                }) .catch((error)=> console.log(error));
        }
        function blind(a,b){
            let json = {
                'r_category' : b,
                'idx' : a
            }
            fetch("/admin/blind", {
                method: "post",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(json)
            }).then((response) => response.json())
                .then(data => {
                    if (data.result){
                        alert("블라인드 되었습니다.")
                        let page = document.getElementById("nowPageNum");
                        if (b == "post"){
                            reportAjax("post", page.value);
                        } else if (b == "comment" || b == "reply"){
                            reportAjax("comment", page.value)
                        } else {
                            requestAjax(page.value)
                        }
                    } else {
                        alert("블라인드 실패")
                        return;
                    }
                }).catch((error)=> console.log(error));
        }
        function closeRep(){
            if (viewDetails.style.display != "none"){
                viewDetails.style.display = "none";
            }
            if (viewComment.style.display != "none"){
                viewComment.style.display = "none";
            }
            document.body.style.background = "none";
            document.getElementById("logo").style.opacity = "1.0";
            document.getElementById("logo").style.cursor = "pointer";
            document.getElementById("logo").addEventListener("click", homeGoLogo)
        }

    </script>
</body>
</html>