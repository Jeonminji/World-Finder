<%--
  Created by IntelliJ IDEA.
  User: goott1
  Date: 2023-07-31
  Time: 오후 12:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="../../../resources/css/buttonStyle.css">
    <style>
        #details_continent, #county{
            display: none;
        }
        #realImage{
            border: 1px solid black;
            border-radius : 5px;
            padding: 3px 5px;
            background-color: #f0f0f0;
        }
        #imgBody{
            margin-top: 20px;
            height: 100px;
        }
        #content{
            padding: 10px;
            outline: none;
            border: 2px solid gray;
            border-radius: 5px;
            width: 100%;
            height: 80%;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="../../../resources/css/base.css">
</head>
<body>
<%@include file="../include/logoSerach.jsp"%>
<div id="body">
    <h1>나라 작성</h1>
    <div> 나라 이름
        <select id="continent">
            <option value="">대륙 선택</option>
        </select>
        <select id="details_continent"></select>
        <select id="county"></select>
    </div>
    <div id="imgBody">
        <label for="input_image" id="realImage" >대표 이미지 선택</label> <br>
        <img style="height: 70px; margin-top: 10px" id="preview-image">
        <input type="file" name="emage" accept="image/*" id="input_image" style="display: none" >
        <input type="file"  accept="image/*" id="backUpImg" style="display: none">
    </div>
    <hr>
    <div>
        <div><div class="editor-menu">
            <button id="btn-bold">
                <b>글씨 굵게</b>
            </button>
        </div></div>
        <hr>
        <div style="overflow: auto" id="content" contenteditable="true"></div>
    </div>
    <button type="button" class="button button--ujarak button--border-thin button--text-thick" id="sub">작성 완료</button>
    <button type="button" class="button button--ujarak button--border-thin button--text-thick" onclick="location.href = '/'">로비로</button>

</div>
<form id="realForm" style="display: none">

</form>
<script>
    let set = new Set();

    const conts = ${cont};

    for (const cont of conts) {
        set.add(cont.continent);
    }

    const continent = document.getElementById("continent");
    const  details_continent = document.getElementById("details_continent");
    const country = document.getElementById("county");

    for (const c of set) {
        continent.innerHTML += `<option value="\${c}">\${c}</option>`
    }

    continent.onchange = function () {
        details_continent.innerHTML = '<option value="">세부 대륙 선택</option>';
        if (this.value == ""){
            details_continent.style.display = "none";
            country.style.display = "none";
        } else {
            details_continent.style.display = "inline-block";
            country.style.display = "none";
            details_select(this.value);
        }
    }

    function details_select(num) {
        for (const cont of conts) {
            if (cont.continent == num){
                details_continent.innerHTML += `<option value="\${cont.details_continent}">\${cont.details_continent}</option>;`
            }
        }
    }

    details_continent.addEventListener("change", () =>{
        country.innerHTML = '<option value="">나라 선택</option>';
        if (details_continent.value == ""){
            country.style.display = "none";
        } else {
            country.style.display = "inline-block";
            $.ajax({
                url : `/countryWrite/countryList/\${details_continent.value}`  ,
                dataType : "json",
                type : "post",
                success : function (countrys) {
                    for (const result of countrys) {

                        country.innerHTML += `<option value="\${result.COUNTRY}">\${result.COUNTRY}</option>`;
                    }

                }
            })
        }
    })

    country.addEventListener('change',(e) =>{
        for(const c of ${clearCountry}) {
            if (e.target.value == c.COUNTRY){
                alert("이미 작성된 나라입니다")
                e.target.value = "";
                return;
            }
        }
    })

    // 이미지 보여주기 처리
    function readImage(input) {
        if(input.files && input.files[0]) {
            const reader = new FileReader()
            reader.onload = e => {
                const previewImage = document.getElementById("preview-image")
                previewImage.src = e.target.result
            }
            reader.readAsDataURL(input.files[0])
        }
    }

    const inputImage = document.getElementById("input_image");
    inputImage.addEventListener("change", e => {
        if (inputImage.value == ""){
            $("#input_image").prop("files",$("#backUpImg").prop("files"));
            return;
        }
        $("#backUpImg").prop("files",$("#input_image").prop("files"));
        readImage(e.target)
    })

    const sub = document.getElementById("sub");

    sub.addEventListener("click", () =>{
        imageForm();
    })

    function imageForm() {
        if (country.value == ""){
            alert("카테고리를 설정해주세요")
            if (continent.value == ""){
                continent.focus();
            } else if (details_continent.value == ""){
                details_continent.focus();
            } else {
                country.focus();
            }
            return;
        } else if (inputImage.value == ""){
            alert("대표 이미지를 넣어주세요")
            inputImage.focus()

            return;
        } else if (content.innerHTML == ""){
            alert("내용을 작성해주세요")
            content.focus()

            return;
        }


        let formdata = new FormData();
        let inputFile = inputImage;

        let files = inputFile.files;

        for (let i = 0; i < files.length; i++) {
            formdata.append('uploadFile' , files[i])
        }

        $.ajax({
            type : 'post',
            url : '/country/imgAjax',
            data : formdata ,
            dataType: "JSON",
            contentType : false ,
            processData : false ,
            success : function (r) {
                writePage(r.c_img)
            },
            error : function() {

            }
        });

        function writePage(img) {
            let realForm = document.getElementById("realForm");

            realForm.innerHTML += `<input type="text" name="c_img" value="\${img}" >`;
            realForm.innerHTML += `<input type="text" name="content" value="\${content.innerHTML}" >`;
            realForm.innerHTML += `<input type="text" name="country" value="\${country.value}" >`;

            $.ajax({
                type : 'post',
                url : '/countryWrite',
                data : $(realForm).serialize() ,
                dataType: "text",
                success : function (r) {
                    if (r == '0'){
                        alert("작성에 실패 했습니다")
                        return;
                    } else {
                        alert("작성에 성공 했습니다")
                        location.href = `/country/\${country.value}`;
                    }
                }
            })
        }
    }
</script>
<script>

    // 특정 영역 글씨 굵게만드는 이벤트 만들기
    const content = document.getElementById('content');
    const bold = document.getElementById('btn-bold');

    bold.addEventListener('click', function () {
        setStyle('bold');
    });

    // 포커스 해주기
    function focusContent() {
        content.focus({preventScroll: true});
    }

    function setStyle(style) {
        document.execCommand(style);
        focusContent();
    }
</script>
</body>
</html>
