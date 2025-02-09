<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>    
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	
	ul.paging {
      list-style-type: none;
      overflow: hidden;
      margin: auto;
      width:350px;
   }
   ul.paging li {
      float: left;
      margin:20px;
      color: #0078ff;
   
   }
   ul.paging li a{
      font-weight: bold;
      display : block;
      text-decoration: none;
      color:  #0078ff;
   }
   ul.paging a:hover {
       background: #1e90ff;
       color: white;       
   }
   ul.paging li.disable {
      color: silver;
   }
   ul.paging li.now{
      color: tomato;
      font-weight: bold;
   }
	
	#postList {
		flex-wrap: wrap;
		display: flex;
	}

	#postOne {
		margin-left: 50px;
		width: 450px;
		height: 530px;
		/* border: 1px solid black; */
		align-items: center;
		position: relative;
	}

	#postList > #imgDiv {
		width: 330px;
		height: 380px;
		/* border: 1px solid red; */
		margin-left: 50%;
	}
	
	#postList > #imgDiv > img {
		width: 90%;
		height: 100%;
	}
	
	#postListBottom {
		/* border: 1px solid blue; */
	}
	
	#postListBottom > .date {
		float: right;
	}
</style>
</head>
<body>
	<%@ include file="../include/itemFilter.jsp"%>
	<div style="margin-bottom: 20px;">
		<button id="writeBtn">게시글 등록</button>
	</div>
	<div id="postList">
			<c:if test="${not empty list }">
				<c:forEach var="userPost" items="${list }">
					<div id="postOne">
						<div id="imgDiv">
							<c:if test="${empty userPost.thumbnail }">
								<img src="../../../resources/image/smallLogo.png">
							</c:if>
							<c:if test="${not empty userPost.thumbnail }">
								<img src="${userPost.thumbnail}">
							</c:if>
						</div>
						<%-- <c:out value="${userPost.up_idx}"></c:out> --%>
						<a class="moveView" href="${userPost.up_idx }"> <c:out
								value="${userPost.title }"></c:out>
						</a>
						<span style="float: right;"><c:out value="${userPost.u_writer}"></c:out></span>
						<div id="postListBottom">
							<img src="../../../resources/image/userPost/hit.png" style="width: 5%;"> <c:out value="${userPost.hit }"></c:out>
							<img src="../../../resources/image/userPost/like.png" style="width: 5%;"> <c:out value="${userPost.up_like }"></c:out>
							<span style="float: right;"><fmt:formatDate value="${userPost.reg_date}" pattern="yyyy-MM-dd"/></span>
						</div>
						<br>
					</div>
				</c:forEach>
	
				<div class="page">
					<ul class="pagination">
						<c:if test="${pageMaker.prev }">
							<li class="paginate_button previous"><a
								href="${pageMaker.startPage-1 }">&lt;</a></li>
						</c:if>
						<c:forEach var="num" begin="${pageMaker.startPage }"
							end="${pageMaker.endPage }" step="1">
							<li
								class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : '' }">
								<a href="${num }">${num }</a>
							</li>
						</c:forEach>
						<c:if test="${pageMaker.next }">
							<li class="paginate_button"><a href="${pageMaker.endPage+1 }">&gt;</a>
							</li>
						</c:if>
					</ul>
				</div>
	
			</c:if>
			<c:if test="${empty list }">
						게시글이 존재하지 않습니다.
			</c:if>


		<!-- <table class="">
			<thead>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>조회수</th>
					<th>좋아요</th>
					<th>작성일</th>
					<th>썸네일</th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
		</table> -->

		

		<!-- 페이징 처리 -->
		<form action="/userPost/main" method="get" id="actionForm">
			<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
			<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
			<input type="hidden" name="country" value="${country }">
		</form>
		
		
	</div>
	
	<script type="text/javascript">
	
		var actionForm = $("#actionForm");
		var country = '${country}';
	
		$(function() {
			var writeBtn = document.querySelector("#writeBtn");
			writeBtn.onclick = function() {
				actionForm.attr('action', '/userPost/write');
				//actionForm.append("<input type='hidden' name='country' value='" + country + "'/>");
				actionForm.submit();
			}
		});
	
		$('.moveView').on('click', function(e) {
			e.preventDefault();
			
			actionForm.attr('action', '/userPost/view');
			actionForm.append("<input type='hidden' name='up_idx' value='" + $(this).attr('href') + "'/>");
			
			actionForm.submit();
		});
		
		/* 페이징 */
		$(".paginate_button a").on('click', function(e) {
			e.preventDefault();
			
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
	</script>
	<script type="text/javascript">
		function ranName(a) {
			 location.href='/userPost/main?country=' + a;
		}
	</script>
</body>
</html>