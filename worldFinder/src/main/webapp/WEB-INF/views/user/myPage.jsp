<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    #menu {
        margin-bottom: 20px;
    }
    .myPageMenu {
        padding: 10px;
        background-color: #f2f2f2;
        border: none;
        cursor: pointer;
    }
    #main > div {
        display: none;
    }
    th, td {
        padding: 8px;
        border-bottom: 1px solid #ddd;
    }
    .post-title {
    	color: blue;
    	cursor: pointer;
    }
</style>
<script>
	$(function() {
	
	    $(".myPageMenu").click(function() {
	        var menu = $(this).parent().data("menu");
	        $("#main > div").hide();  // 모든 div를 숨김
	        $("#myInfo").hide();  // 모든 div를 숨김
	        $("#" + menu).show();     // 선택한 메뉴에 해당하는 div를 보여줌
	    });

	});
</script>
</head>
<body>
	<%@include file="../include/logo.jsp"%>
	<div id="menu">
        <span data-menu="myInfo"><button id="myInfoBtn" class="myPageMenu">내 정보 확인</button></span>
        <span data-menu="post"><button id="postBtn" class="myPageMenu">게시글</button></span>
        <span data-menu="comments"><button id="commentsBtn" class="myPageMenu">댓글</button></span>
        <span data-menu="scrap"><button id="scrapBtn" class="myPageMenu">스크랩</button></span>
        <span data-menu="pay"><button id="payBtn" class="myPageMenu">결제</button></span>
    </div>
	<div id="main">
		<form action="/user/pwFind" method="POST" id="formPwFind">
			<div id="myInfo">
				
				
			</div>
		</form>
		<div id="post">
			<table>
				<thead>
					<tr>
						<th>카테고리</th>
						<th>제목</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody id="postBody">
				</tbody>
			</table>
		</div>
		<div id="comments">
			<h3>Comments</h3>
			<div id="comment">
				<table>
					<thead>
						<tr>
							<th>게시글 제목</th>
							<th>댓글 내용</th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody id="commentBody">
					</tbody>
				</table>
			</div>
			<br><br>
			<h3>Replies</h3>
			<div id="reply">
				<table>
					<thead>
						<tr>
							<th>게시글 제목</th>
							<th>댓글 내용</th>
							<th>작성일</th>
						</tr>
					</thead>
				<tbody id="replyBody">
				</tbody>
			</table>
			</div>
		</div>
		<div id="scrap">
			<table>
				<thead>
					<tr>
						<th>카테고리</th>
						<th>제목</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody id="scrapBody">
				</tbody>
			</table>
		</div>
		<div id="pay">
			<table>
				<thead>
					<tr>
						<th>카테고리</th>
						<th>상품명</th>
						<th>가격</th>
						<th>날짜</th>
					</tr>
				</thead>
				<tbody id="payBody">
					<tr>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	
	<script type="text/javascript">
		var currentUser = '${currentUser}';
		var myInfoList = $("#myInfo");
		var postBody = $("#postBody");
		var commentBody = $("#commentBody");
		var replyBody = $("#replyBody");
		var scrapBody = $("#scrapBody");
		var payBody = $("#payBody");
	
		function sidd() {
			
			console.log("현재 로그인한 사용자 : ", currentUser);
			
			$.ajax({
				type: "GET",
				url: "/myPage/userInfo/" + currentUser,
				dataType: "json",
				success: function(result) {
					var str = '';
					var userModifyUrl = '/user/userModify';
					for (var i = 0; i < result.length; i++) {
						str += '아이디 <input type="text" name="u_writer" value="' + result[i].u_writer + '" readonly="readonly"> <br>'
						str += '성명 <input type="text" name="u_pw" value="' + result[i].u_name +'" readonly="readonly"> <br>';
						str += '생년월일 <input type="text" name="u_name" value="' + result[i].birth + '" readonly="readonly"> <br>';
						str += '연락처 <input type="text" name="phone" value="' + result[i].phone + '" readonly="readonly"> <br>';
						str += '이메일 <input type="text" name="mail" value="' + result[i].mail + '" readonly="readonly"> <br>';
						str += '성별 <input type="radio" name="gender" readonly="readonly" checked>' + result[i].gender + ' <br>';
						str += '<input type="button" onclick="location.href=\'' + userModifyUrl + '\'" value="회원정보 변경"> <br>';
						str += '<input type="button" onclick="pwFind()" value="비밀번호 변경"	>';
					}
					myInfoList.html(str);
				},
				error: function(xhr, status, er) {
					console.error("내 정보 가져오던 중 오류 발생: ", er);
				}
			});
			
		};
		
		function pwFind() {
			$("#formPwFind").submit();
		}
		
		
		$(function() {
			
			function displayTime(timeValue){
		    	var today = new Date();
		       	var gap = today.getTime() - timeValue;
		       	var dateObj = new Date(timeValue);
		       	var str = "";
		       
		       	if (gap < (1000 * 60 * 60 * 24)){
		        	var hh = dateObj.getHours();
		          	var mi = dateObj.getMinutes();
		          	var ss = dateObj.getSeconds();
		          	return [(hh>9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss].join('');
		       	} else {
		          	var yy = dateObj.getFullYear();
		          	var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
		          	var dd = dateObj.getDate();
		          	return [yy, '/', (mm > 9 ? '' : '0')+mm, '/', (dd > 9 ? '' : '0') + dd].join('');
		       	}
		    }
			
			
			$("#myInfoBtn").on("click", function (e) {
				e.preventDefault();
				sidd();
			});
			
			$("#postBtn").on("click", function(e) {
				e.preventDefault();
				
				console.log("현재 로그인한 사용자 : ", currentUser);
				
				$.ajax({
					type: "GET",
					url: "/myPage/postInfo/" + currentUser,
					dataType: "json",
					success: function(result) {
						var str = '';
						for (var i = 0; i < result.length; i++) {
							str += '<tr>';
							str += '<th>' + result[i].country + '</th>'
							str += '<th class="post-title">' + result[i].title + '</th>'
							str += '<th>' + displayTime(result[i].reg_date) + '</th>'
							str += '<th><input type="hidden" name="up_idx" value="' + result[i].up_idx + '">';
							str += '<th><input type="hidden" name="country" value="' + result[i].country + '">';
							str += '</tr>';
						}
						postBody.html(str);
					},
					error: function(xhr, status, er) {
						console.error("게시글 정보 가져오던 중 오류 발생: ", er);
					}
				});
			});
			
			
			// 게시글 제목 클릭 이벤트 처리
			$(document).on("click", "#postBody .post-title, #commentBody .post-title, #replyBody .post-title, #scrapBody .post-title", function() {
			    var up_idx = $(this).parent().find("input[name='up_idx']").val();
			    var country = $(this).parent().find("input[name='country']").val();
			    if (up_idx) {
			        window.location.href = "/userPost/view?up_idx=" + up_idx + "&country=" + country;
			    }
			});
			
			
			$("#commentsBtn").on("click", function(e) {
				e.preventDefault();
				
				console.log("현재 로그인한 사용자 : ", currentUser);
				
				$.ajax({
					type: "GET",
					url: "/myPage/commentInfo/" + currentUser,
					dataType: "json",
					success: function(result) {
						var str = '';
						for (var i = 0; i < result.length; i++) {
							str += '<tr>';
							str += '<th class="post-title">' + result[i].title + '</th>'
							str += '<th>' + result[i].c_content + '</th>'
							str += '<th>' + displayTime(result[i].reg_date) + '</th>'
							str += '<th><input type="hidden" name="up_idx" value="' + result[i].up_idx + '">';
							str += '<th><input type="hidden" name="country" value="' + result[i].country + '">';
							str += '</tr>';
						}
						commentBody.html(str);
					},
					error: function(xhr, status, er) {
						console.error("댓글 정보 가져오던 중 오류 발생: ", er);
					}
				});
				
				
				$.ajax({
					type: "GET",
					url: "/myPage/replyInfo/" + currentUser,
					dataType: "json",
					success: function(result) {
						var str = '';
						for (var i = 0; i < result.length; i++) {
							str += '<tr>';
							str += '<th class="post-title">' + result[i].title + '</th>'
							str += '<th>' + result[i].nc_content + '</th>'
							str += '<th>' + displayTime(result[i].reg_date) + '</th>'
							str += '<th><input type="hidden" name="up_idx" value="' + result[i].up_idx + '">';
							str += '<th><input type="hidden" name="country" value="' + result[i].country + '">';
							str += '</tr>';
						}
						replyBody.html(str);
					},
					error: function(xhr, status, er) {
						console.error("댓글 정보 가져오던 중 오류 발생: ", er);
					}
				});
				
			});

			$("#scrapBtn").on("click", function(e) {
				e.preventDefault();
				
				console.log("현재 로그인한 사용자 : ", currentUser);
				
				$.ajax({
					type: "GET",
					url: "/myPage/scrapInfo/" + currentUser,
					dataType: "json",
					success: function(result) {
						var str = '';
						for (var i = 0; i < result.length; i++) {
							str += '<tr>';
							str += '<th>' + result[i].country + '</th>'
							str += '<th class="post-title">' + result[i].title + '</th>'
							str += '<th>' + displayTime(result[i].reg_date) + '</th>'
							str += '<th><input type="hidden" name="up_idx" value="' + result[i].up_idx + '">';
							str += '<th><input type="hidden" name="country" value="' + result[i].country + '">';
							str += '</tr>';
						}
						scrapBody.html(str);
					},
					error: function(xhr, status, er) {
						console.error("게시글 정보 가져오던 중 오류 발생: ", er);
					}
				});
			});
			
			$("#payBtn").on("click", function(e) {
				
				e.preventDefault();
				
				console.log("현재 로그인한 사용자 : ", currentUser);
				
				$.ajax({
					type: "GET",
					url: "/myPage/payInfo/" + currentUser,
					dataType: "json",
					success: function(result) {
						var str = '';
						var category = '';
						for (var i = 0; i < result.length; i++) {
							
							if (result[i].hotel_idx === 0) {
								category = '관광지';
							} else {
								category = '숙소';
							}
							
							str += '<tr>';
							str += '<th>' + category + '</th>'
							str += '<th class="item-title">' + result[i].item_name + '</th>'
							str += '<th>' + result[i].final_price + '</th>'
							str += '<th>' + displayTime(result[i].buy_date) + '</th>'	// country 랑 item_idx 값 xml에서 다시 가져와야함
							str += '<th><input type="hidden" name="item_idx" value="' + result[i].item_idx + '">';
							str += '<th><input type="hidden" name="country" value="' + result[i].country + '">';
							str += '</tr>';
						}
						payBody.html(str);
					},
					error: function(xhr, status, er) {
						console.error("게시글 정보 가져오던 중 오류 발생: ", er);
					}
				});
				
			});
			
		});
	</script>
	<script type="text/javascript">
		$(function () {
			$("#myInfo").show(); 
			sidd();
		});
	</script>
</body>
</html>