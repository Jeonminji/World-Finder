<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 내용 작성 스크립트 -->
<script type="text/javascript">
  $(function() {
    var editor = document.querySelector('#editor');
    
    function focusEditor() {
      editor.focus({preventScroll: true});
    }
    
    // 에디터에 내용을 보여주기 위해 ${list.up_content} 값을 삽입
    var content = '${list.up_content}';
    editor.innerHTML = content;

  });
</script>

<!-- 화면 이동 스크립트 -->
<script type="text/javascript">
 
	$(function() {

		var operForm = $("#operForm");
		var pageNumTag = $("input[name='pageNum']").clone();
		var amountTag = $("input[name='amount']").clone();
		var countryTag = $("input[name='country']").clone();

		$("button").on('click', function(e) {
			e.preventDefault();

			var operation = $(this).data("oper");

			if (operation === 'main') {
				operForm.empty(); // u_idx 값 넘어오는거 지워줌(초기화)
				operForm.attr('action', 'main').attr('method', 'get');

				operForm.append(pageNumTag);
				operForm.append(amountTag);
				operForm.append(countryTag);

				operForm.submit();

			} else if (operation === 'update') {
				operForm.attr('action', 'update').attr('method', 'get');
				operForm.submit();
			} else if (operation === 'delete') {
				operForm.attr('action', 'delete').attr('method', 'post');
				operForm.submit();
			} 
		});

	});
</script>

<!-- 댓글 -->
<script type="text/javascript">
	
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
	<button data-oper="main" id="mainBtn">목록으로 이동</button>
	<div>
		제목 <input name="title" value="${list.title }" readonly="readonly" />
		<br> 
		작성자 <input name="u_writer" value="${list.u_writer }" readonly="readonly" /> 
		<br> 
		내용
		<hr>
		<div id="editor" contenteditable="false"></div> <!-- false: 입력 불가 -->
		<br>
		<form action="/userPost/delete" method="post" id="operForm">
			<input type="hidden" name="u_writer" value="${list.u_writer }">
			<input type="hidden" id="up_idx" name="up_idx" value="${list.up_idx }">
			<input type="hidden" id="pageNum" name="pageNum" value="${cri.pageNum }">
			<input type="hidden" id="amount" name="amount" value="${cri.amount }">
			<input type="hidden" id="country" name="country" value="${country }">
			
			<sec:authentication property="principal" var="pinfo"/>
			<sec:authorize access="isAuthenticated()">
				<c:if test="${pinfo.username eq list.u_writer }">
					<button data-oper="update" id="update-btn">게시글 수정</button>
					<button data-oper="delete" id="delete-btn">게시글 삭제</button>
				</c:if>
			</sec:authorize>
			
			<!-- 좋아요 버튼 -->
			<button id="likePost-btn" data-liked='${likeStatus }'>
			    <img id="likeImg" src="../../../resources/image/userPost/dislike.png" style="border: none; width:20px; height: 20px; cursor: pointer;">
			</button>
			<span id="likeCount">${likeCount }</span>
			<%-- <p id="likeCount">${likeCount }</p> --%>
			<%-- <button data-oper="likePost" id="likePost-btn" data-liked="${list.up_like == 1 ? 'true' : 'false' }">
			    <img id="likeImg" src="${likeStatus ? '../../../resources/image/userPost/like.png' : '../../../resources/image/userPost/dislike.png' }" style="border: none; width:20px; height: 20px; cursor: pointer;">
			</button>
			<span id="likeCount">${likeCount }</span> --%>

			
			
			<button id="scrap-btn" data-scraped="${scrapStatus }">
				<img id="scrapImg" src="../../../resources/image/userPost/cancleScrap.png" style="border: none; width:20px; height: 20px; cursor: pointer;">
			</button>
			
			<button id="reportPost-btn">
				<img id="scrapImg" src="../../../resources/image/userPost/siren.png" style="border: none; width:20px; height: 20px; cursor: pointer;">
			</button>
			
		</form>
	</div>
	<br><br>
	
	<!-- <div id="modal">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" ari-hidden="true">&times;</button>
				<h4>신고하기</h4>
			</div>
			<div class="modal-body">
				<input type="text" name="r_content" placeholder="신고 내용을 작성해주세요.">
			</div>
		</div>
	</div> -->
	
	<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
	<script type="text/javascript">
		$(function() {
			
			var up_idx = '${list.up_idx}';
			var likeBtn = $("#likePost-btn");
			var scrapBtn = $("#scrap-btn");
			var reportBtn = $("#reportPost-btn");
			var likeCount = $("#likeCount");
			var currentUser = '${currentUser}';
			
			
			// 버튼 상태 초기화
			/* function initLikeBtn() {
			    var liked = localStorage.getItem("liked_" + up_idx);	// "liked_" 의 값 가져오기 - likePost-btn의 
			    if (liked === "true") {
			      likeBtn.data("liked", true);
			      likeBtn.find("img").attr("src", "../../../resources/image/userPost/like.png");
			    } else {
			      likeBtn.data("liked", false);
			      likeBtn.find("img").attr("src", "../../../resources/image/userPost/dislike.png");
			    }			
			} */
			
			
			// 로그인한 사용자마다 버튼 상태 및 이미지 설정
		    function setButtonState() {
		      if (currentUser === "" || currentUser == null) {	// 로그인한 사용자가 없다면
		        likeBtn.prop("disabled", true); // disabled 속성 설정, true 하면 버튼 비활성화 함
		        likeBtn.find("img").attr("src", "../../../resources/image/userPost/dislike.png"); // 버튼 이미지 초기화
		        
		        scrapBtn.prop("disabled", true);
		        scrapBtn.find("img").attr("src", "../../../resources/image/userPost/cancleScrap.png");
		      
		      } else {	// 로그인을 했으니 이미 좋아요를 눌렀는지 안 눌렀는지 확인
		        likeBtn.prop("disabled", false); // 버튼 활성화
		        
		        $.ajax({
		            type: "GET",
		            url: "/userPost/checkLike",
		            data: { up_idx: up_idx },
		            success: function(response) {
		              if (response === "liked") {
		                likeBtn.data("liked", true);
		                likeBtn.find("img").attr("src", "../../../resources/image/userPost/like.png");
		              } else {
		                likeBtn.data("liked", false);
		                likeBtn.find("img").attr("src", "../../../resources/image/userPost/dislike.png");
		              }
		            },
		            error: function(xhr, status, error) {
		              console.error("Error checking like status:", error);
		            }
		          });
		        
		        
		        
		        scrapBtn.prop("disabled", false);
		        
		        $.ajax({
		        	type: "GET",
		        	url: "/userPost/checkScrap",
		        	data: {up_idx: up_idx},
		        	success: function(response) {
		        		if (response === "scraped") {
		        			scrapBtn.data("scraped", true);
		        			scrapBtn.find("img").attr("src", "../../../resources/image/userPost/scrap.png");
		        		} else {
		        			scrapBtn.data("scraped", false);
		        			scrapBtn.find("img").attr("src", "../../../resources/image/userPost/cancleScrap.png");
		        		}
		        	},
		        	error: function(xhr, status, error) {
		        		console.error("Error checking scrap status: ", error);
		        	}
		        });
		        
		     
		      }
		      
		    }
			
		 // 페이지 로드 시 버튼 상태 및 이미지 설정
		    setButtonState();
			
			likeBtn.on("click", function(e) {
				e.preventDefault();
				
				if (currentUser === '' || currentUser == null) {
					alert("로그인이 필요합니다.");
					window.location.href = '/user/loginPage';
					return;
				}
				
				if (!likeBtn.prop("disabled")) {
        			var liked = likeBtn.data("liked");

        			$.ajax({
						type: liked ? "DELETE" : "POST",
			            url: liked ? "/userPost/dislike" : "/userPost/like",
			            contentType: "application/json; charset=utf-8",
			            data: JSON.stringify({ up_idx: up_idx }),
			            success: function(response) {
			            	if (response === "ok") {
			            		liked = !liked;
			            		likeBtn.data("liked", liked);
			            		//likeBtn.find("img").attr("src", liked ? "../../../resources/image/userPost/like.png" : "../../../resources/image/userPost/dislike.png");
	
			            		var currentLikeCount = parseInt(likeCount.text());
			            		likeCount.text(liked ? currentLikeCount + 1 : currentLikeCount - 1);
			            		
			            		// 로컬 스토리지에 좋아요 상태 저장
			            		localStorage.setItem("liked_" + up_idx, liked);
			            		
			            		// 좋아요 버튼 이미지 변경
			            		likeBtn.find("img").attr("src", liked ? "../../../resources/image/userPost/like.png" : "../../../resources/image/userPost/dislike.png");
			                }
			           },
			           error: function(xhr, status, error) {
			        	   console.error("Error liking/disliking post:", error);
			           }
			         });
				}
			});
			
			
			//setButtonState();
			
			scrapBtn.on("click", function(e) {
				e.preventDefault();
				
				if (currentUser === '' || currentUser == null) {
					alert("로그인이 필요합니다.");
					window.location.href = '/user/loginPage';
					return;
				}
				
				
				if (!scrapBtn.prop("disabled")) {
					var scraped = scrapBtn.data("scraped");

					$.ajax({
						type: scraped ? "DELETE" : "POST",
						url: scraped ? "/userPost/scrapCancle" : "/userPost/scrap",
						contentType: "application/json",
						data: JSON.stringify({up_idx : up_idx}),
						success: function(response) {
							
							if (response === "ok") {
								scraped = !scraped;
								scrapBtn.data("scraped", scraped);
								
								localStorage.setItem("scraped_" + up_idx, scraped);
								
								//var imgSrc = scraped ? "../../../resources/image/userPost/scrap.png" : "../../../resources/image/userPost/cancleScrap.png";
								
								scrapBtn.find("img").attr("src", scraped ? "../../../resources/image/userPost/scrap.png" : "../../../resources/image/userPost/cancleScrap.png");
								
								//console.log(scrapBtn.find("img").attr("src"))
							}
						},
						error: function(xhr, status, error) {
							console.error("Error scrapping/cancleScrapping post:", error);
						}
					});
				}
				
			});
			
			
			reportBtn.on("click", function(e) {
				e.preventDefault();
				
				if (currentUser === '' || currentUser == null) {
					alert("로그인이 필요합니다.");
					window.location.href = '/user/loginPage';
					return;
				}
				
				var reportContent = prompt("신고 사유를 입력해주세요.");
				
				if (reportContent == null || reportContent === '') {
					alert("신고 사유를 입력해주세요.");
					return;
				}
				
				var report = {
					r_content : reportContent,
					r_category : "post",
					idx : up_idx,
					u_writer : currentUser
				}
				
				$.ajax({
					type: 'POST',
					url: '/userPost/report',
					data: JSON.stringify(report),
					contentType: "application/json",
					success: function(result) {
						alert("신고가 접수되었습니다.");
						console.log("신고 접수 결과:", result);
					}, 
					error: function(xhr, status, er) {
						alert("신고가 접수되지 않았습니다.");
						console.log("신고 접수 중 오류 발생: ", er)
					}
				});
			});
			
		});
	</script>
	
	<%@ include file="../userPost/userPostComment.jsp" %>
	
</body>
</html>