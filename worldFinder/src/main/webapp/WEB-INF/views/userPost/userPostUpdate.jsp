<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	$(function() {
		var editor = document.querySelector('#editor');
		var btnImg = document.querySelector('#btn-img');
		var imgSelector = document.querySelector('#img-selector');

		function focusEditor() {
			editor.focus({preventScroll : true});
		}

		// 에디터에 내용을 보여주기 위해 ${list.up_content} 값을 삽입
		var content = '${list.up_content}';
		editor.innerHTML = content;

		btnImg.addEventListener('click', function() {
			imgSelector.click();
		});

		imgSelector.addEventListener('change', function(e) {
			var files = e.target.files;
			if (files && files.length > 0) {
				var file = files[0];
				if (file.type.startsWith('image/')) {	// 이미지인지 판별
					insertImg(file);
					imgSelector.value = '';
				} else {
					alert('이미지 파일을 선택해주세요.');
				}
			}
		});

		function insertImg(file) {	// 이미지 삽입 함수
			var reader = new FileReader();
			reader.addEventListener('load', function(e) {
				focusEditor();
				document.execCommand('insertImage', false, reader.result);
			});
			reader.readAsDataURL(file);
		}
		
		$('#update-btn').click(function() {	
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
		var countryTag = $("input[name='country']").clone();
		
		$("#mainBtn").on('click', function() {
			operForm.empty();
			operForm.attr('action', 'main').attr('method', 'get');
			
			operForm.append(pageNumTag);
			operForm.append(amountTag);
			operForm.append(countryTag);
			
			operForm.submit();
		});
	});
</script>
<style type="text/css">
	div#editor {
		border: 1px solid #D6D6D6;
		border-radius: 4px;
		min-height: 200px; /* 에디터의 최소 높이 설정 */
	}
	
	#editor img {
		max-width: 40%;
	}
</style>
</head>
<body>
	${country }
	<button id="mainBtn">목록으로 이동</button>
	
	<form action="/userPost/update" method="post" id="operForm">
		제목 <input type="text" name="title" value="${list.title }">
		<br>
		작성자 <input name="u_writer" value="${list.u_writer }" readonly="readonly" />
		<hr>
		<button type="button" id="btn-img">IMG<!-- <img src="/resources/image/img-icon.png"/> --></button>
		<br><br>
		<div id="editor" contenteditable="true"></div>
		<input id="img-selector" type="file" style="display: none;">
		<br>
		<button id="update-btn">게시글 수정</button>
		<textarea name="up_content" id="append" style="display: none;"></textarea>
		<textarea name="thumbnail" id="append2" style="display: none;"></textarea>
		<input type="hidden" name="up_idx" value="${list.up_idx }">
		<input type="hidden" name="pageNum" value="${cri.pageNum }">
		<input type="hidden" name="amount" value="${cri.amount }">
		<input type="hidden" name="country" value="${country }">
	</form>
	
</body>
</html>
