<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

	$(function() {
		
		var editor = document.querySelector('#editor');				// content
		var btnImg = document.querySelector('#btn-img');			// 이미지 버튼
		var imgSelector = document.querySelector('#img-selector');	// 파일 삽입
		
		// div editor에 포커스 주기
		function focusEditor() {
			editor.focus({preventScroll: true});
		}
	
		// IMG 추가 버튼 클릭 시
		btnImg.addEventListener('click', function() {
			imgSelector.click();
		});

		imgSelector.addEventListener('change', function(e) {
			var files = e.target.files;					// 선택한 파일 가져옴
			if (files && files.length > 0) {			// 파일 존재 시
				var file = files[0];					// 다중 선택 시 첫 번째 파일만
				
				// 이미지인지 판별(이미지 삽입 여부 결정), 파일의 MIME 타입이 image/ 로 시작하면 이미지
				// MIME : 멀티미디어 데이터를 전송하는 데 사용되는 인터넷 표준
				// 이미지 : image/png, 텍스트 : text/plain, html 문서 : text/html, 오디오 : audio/mpeg ....
				if (file.type.startsWith('image/')) {	
					insertImg(file);		// 이미지 삽입 함수(editor에 삽입)
					imgSelector.value = '';	// 이미지 삽입 후 선택창 닫고 초기화(중복 이미지 선택 가능)
				} else {
					alert('이미지 파일을 선택해주세요.');
				}
			}
		});

		function insertImg(file) {	// 이미지 삽입 함수
			var reader = new FileReader();
			reader.addEventListener('load', function(e) {	// 파일을 읽은 후
				focusEditor();		// div 에디커에 포커스
				
				// 이미지 삽입 실행 커맨드, reader.result에 전달
				document.execCommand('insertImage', false, reader.result);	
			});
			reader.readAsDataURL(file); // 선택한 이미지를 data url 로 변경
		}
		
		// 게시글 등록 버튼 클릭 시 div 값 textarea에 값 옮겨주고
		// textarea에 있는 값을 DB에 넣어줌
		// div > textarea > DB
		$('#post-btn').click(function() {	
			$('#append').val($('#editor').html());
			
			var firstImage = $('#append').val().match(/<img [^>]*src=['"]([^'"]+)[^>]*>/i);
			
			if (firstImage && firstImage.length >= 2) {
				var firstImageUrl = firstImage[1];
				$('#append2').val(firstImageUrl);
				
				console.log(firstImageUrl);
			} 
			
		});
		
	});
</script>
<!-- 페이지 이동 -->
<script type="text/javascript">
	$(function() {
				
		var operForm = $("#operForm");
		var pageNumTag = $("input[name='pageNum']").clone();
		var amountTag = $("input[name='amount']").clone();
		var country = $("input[name='country']").clone();
		
		$("#mainBtn").on('click', function() {
			operForm.empty();
			operForm.attr('action', 'main').attr('method', 'get');
			
			operForm.append(pageNumTag);
			operForm.append(amountTag);
			operForm.append(country);
			
			operForm.submit();
		});
		
		/* $("#resetBtn").on('click', function() {
			$('form').each(function() {
				this.reset();
			});
		}); */
	});
</script>
<style type="text/css">
	div#editor {
		border: 1px solid #D6D6D6;
		border-radius: 4px;
	}

	#editor img {
		max-width: 40%;
	}
</style>
</head>
<body>
	<button id="mainBtn">목록으로 이동</button>
	<form action="/userPost/write" method="post" id="operForm">
		<input type="text" placeholder="제목을 입력하세요." name="title">
		<input name="u_writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
		<hr>
		<button type="button" id="btn-img">IMG<!-- <img src="/resources/image/img-icon.png"/> --></button>
		<br><br>
		<div id="editor" contenteditable="true"></div>
		<input id="img-selector" type="file" style="display: none;">	<!-- 파일 입력 요소 생성 -->
		<br>
		<input type="submit" id="post-btn" value="게시글 등록">

		<input type="hidden" name="${_csrf.parameterName }" value="${_csfr.token }">
		<%-- <input type="hidden" name="country" value="${param.country }"> --%>
		<input type="hidden" name="pageNum" value="${cri.pageNum }">
		<input type="hidden" name="amount" value="${cri.amount }">
		<input type="hidden" name="country" value="${country }">
		<textarea name="up_content" id="append" style="display: none;"></textarea>
		<textarea name="thumbnail" id="append2" style="display: none;"></textarea>
	</form>
	<!-- <button id="resetBtn">지우기</button> -->
</body>
</html>