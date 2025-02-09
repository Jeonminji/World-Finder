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
      height: 100%;
    }
    #preview_image
  </style>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <link rel="stylesheet" href="../../../resources/css/base.css">
</head>
<body>
<%@include file="../include/logoSerach.jsp"%>
<div id="body">
  <h1>${countryPage.country}게시글 수정</h1>
  <div id="imgBody">
    <label for="input_image" id="realImage">대표 이미지 선택</label> <br>
    <span style="height: 70px;" id="oldImg"></span>
    <img style="height: 70px; margin-top: 10px" id="preview_image">
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
    <div style="overflow: auto" id="content" contenteditable="true">${countryPage.content} </div>
  </div>
  <button class="button button--ujarak button--border-thin button--text-thick" id="update">수정하기</button>
  <button class="button button--ujarak button--border-thin button--text-thick" id="delete">삭제하기</button>
</div>
<form  id="realForm">

</form>
<script>

  // 이미지 보여주기 처리
  function readImage(input) {
    if(input.files && input.files[0]) {
      const reader = new FileReader()
      reader.onload = e => {
        const previewImage = document.getElementById("preview_image")
        previewImage.src = e.target.result
      }
      reader.readAsDataURL(input.files[0])
    }
  }

  const inputImage = document.getElementById("input_image");
  inputImage.addEventListener("change", e => {

    // 파일 취소시 value 사라지는거 방지
    if (inputImage.value == "" && document.getElementById("oldImg").innerHTML == ""){
      $("#input_image").prop("files",$("#backUpImg").prop("files"));
      return;
    } else if (inputImage.value == "" && document.getElementById("oldImg").innerHTML != ""){
      return;
    }

    // 백업 파일 생성
    $("#backUpImg").prop("files",$("#input_image").prop("files"));

    document.getElementById("oldImg").innerHTML = "";
    readImage(e.target)
  })

  const update = document.getElementById("update");

  update.addEventListener("click", () =>{
    imageForm();
  })

  function imageForm() {
     if (content.innerHTML == ""){
      alert("내용을 작성해주세요")
      content.focus()

      return;
    }
    if (inputImage.value == ""){
        writePage("");
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
      }
    });

    // 게시글 수정 ajax
    function writePage(img) {
      let realForm = document.getElementById("realForm");

      realForm.innerHTML += `<input type="hidden" name="c_img" value="\${img}" >`;
      realForm.innerHTML += `<input type="hidden" name="content" value="\${content.innerHTML}" >`;
      realForm.innerHTML += `<input type="hidden" name="country" value="${countryPage.country}" >`;

      $.ajax({
        type : 'post',
        url : '/country/modify',
        data : $(realForm).serialize() ,
        dataType: "text",
        success : function (r) {
          if (r == '0'){
              alert("수정에 실패 했습니다")
              return;
          } else {
            alert("수정 되었습니다")
            location.replace(`/country/${countryPage.country}`);
         }
        }
      })
    }
  }

  // 게시글 삭제
  $("#delete").on('click',() =>{
    const data = { country : '${countryPage.country}' , c_img : '${countryPage.c_img}'};

    if (confirm("정말 삭제하시겠습니까?")){
      $.ajax({
        type : 'DELETE',
        url : `/country/modify`,
        data : JSON.stringify(data),
        contentType: "application/json",
        dataType: "text",
        success : function (r) {
          if (r == '0'){
            alert("삭제에 실패 했습니다")
            return;
          } else {
            alert("삭제 되었습니다")
            location.replace("/");
          }
        }
      })
    }

  })
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


<script !src="">
  // 이미지 첨부
  const imgEncodeUrl = '${countryPage.c_img}';

  document.getElementById("oldImg").innerHTML =
          `<img src="/country/viewImg?filename=\${encodeURIComponent(imgEncodeUrl)}" width="100px" style="margin-top: 10px">`;

</script>
</body>
</html>
