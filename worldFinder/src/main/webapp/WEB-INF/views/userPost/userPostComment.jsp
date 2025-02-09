<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style type="text/css">
	.replyList {
		margin-left: 50px;
	}
</style>
</head>
<body>	
    <div>
        댓글 <span id="totalComment">0</span>
        <hr>
        <form id="commentForm" name="commentForm" method="post">
            <div>
            	<sec:authorize access="isAuthenticated()">
	                <input type="text" name="c_content" placeholder="댓글 입력">
	                <input type="hidden" name="up_idx" value="${list.up_idx}">
	                <input type="hidden" id="pageNum" name="pageNum" value="${cri.pageNum }">
					<input type="hidden" id="amount" name="amount" value="${cri.amount }">
	                <input type="hidden" name="u_writer" value='<sec:authentication property="principal.username"/>'>
	                <button type='button' id="comWrite">등록</button>	
            	</sec:authorize>
            	<sec:authorize access="isAnonymous()">
            		<input type="text" name="c_content" placeholder="로그인 필수" readonly="readonly">
            		<button type="button" onclick="location.href='/user/loginPage'">등록</button>
            	</sec:authorize>
            </div>
        </form>
        <br>
        <div id="commentList">
        </div>
    </div>

	<!-- 댓글 & 대댓글 비동기(AJAX) -->
    <script type="text/javascript">
		// 리턴 데이터에 대한 시간 처리 함수(24시간 이내 작성 댓글은 시간으로 표기 / 24시간이 지난 댓글은 날짜만 표기)
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
    
    
        var up_idx = '${list.up_idx}';
        
        // 현재 로그인 한 계정
        var principal;
        '<sec:authorize access="isAuthenticated()">';
			principal = '<sec:authentication property="principal.username"/>';
		'</sec:authorize>';
        
        $(function() {
            var commentList = $("#commentList");

            showCommentList();
            updateTotalComment(up_idx);
            
            var likeStatus = '${likeStatus}';
            var likeCount = '${likeCount}'

            // 총 댓글 수
            function updateTotalComment(up_idx) {
            	$.ajax({
            		type: "GET",
            		url: "/comment/total/" + up_idx,
            		dataType: "json",
            		success: function(result) {
            			$("#totalComment").text(result);
            		},
            		error: function(xhr, status, er) {
            			console.err("댓글 수 없데이트 중 오류 발생:", er);
            		}
            	});
            }
            
            
            // 댓글 목록()
            function showCommentList() {
                $.ajax({
                    type: "GET",
                    url: "/comment/" + up_idx,
                    dataType: "json",
                    success: function(result) {
                        var str = '';
                        for (var i = 0; i < result.length; i++) {
                            str += '<div class="comment">';
                            str += '<p>' + result[i].u_writer + '</p>';
                            str += '<p>' + result[i].c_content + '</p>';
                            str += '<p>' + displayTime(result[i].reg_date) + '</p>';
                            if (principal === result[i].u_writer) {                            	
	                            str += '<button class="modifyBtn" data-c_idx="' + result[i].c_idx + '">수정</button>';
	                            str += '<button class="deleteBtn" data-c_idx="' + result[i].c_idx + '">삭제</button>';
                            }
                            str += '<button class="replyBtn" data-c_idx="' + result[i].c_idx + '">답글</button>';		// 대댓글(답글)
                            
                            // button에 data-c_idx 담아서 보내고, controller에서 c_idx 어떻게 받지..? {c_idx}, @Pathvariable("c_idx") 이거 해야하나?
                            //str += '<button id="likeComment-btn" data-cliked="' + likeStatus + '" data-c_idx="' + result[i].c_idx + '">'
                            //str += '<img id="likeImg" src="../../../resources/image/userPost/dislike.png" style="border: none; width: 20px; height: 20px; cursor: pointer;">'
                            //str += '</button>'
                            //str += '<span id="likeCommentCount">' + likeCommentCount + '</span>';
                            //str += '<button class="reportComBtn" data-c_idx="' + result[i].c_idx + '">신고</button>';
                            str += '<button class="reportBtn" data-target_idx="' + result[i].c_idx + '" data-report_category="comment"><img id="scrapImg" src="../../../resources/image/userPost/siren.png" style="border: none; width:20px; height: 20px; cursor: pointer;"></button>';
                            str += '</div>';
                            //setCommentButtonState(result[i].c_idx);
                        }
                        commentList.html(str);
                    },
                    error: function(xhr, status, er) {
                        console.error("댓글 목록 가져오기 중 오류 발생:", er);
                    }
                });
            }
            
           	/* var likeCommentBtn = $("#likeComment-btn");
            function setCommentButtonState(c_idx) {
            	
            	var currentUser = '${currentUser}';
            	var likeCommentBtn = $(".likeComment-btn[data-c_idx='" + c_idx + "']");

            	if (currentUser === '' || currentUser == null) {
            		likeCommentBtn.prop("disabled", true);
            		likeCommentBtn.find("img").attr("src", "../../../resources/image/userPost/dislike.png");
            	} else {
            		likeCommentBtn.prop("disabled", false) // 버튼 활성화
            		//console.log("--------------------- else 탐");
            		//console.log(c_idx);
            		
            		//var likeCommentBtn = $(this);
            		
            		$.ajax({
            			type: "GET",
            			url: "/comment/checkLike",
            			data: {c_idx : c_idx},
            			success: function(response) {
            				console.log("버튼 상태 : ", response);
            				if (response === "cliked") {
            					console.log("좋아요 눌렀음");
            					likeCommentBtn.data("cliked", true);
            					likeCommentBtn.find("img").attr("src", "../../../resources/image/userPost/like.png");
            				} else {
            					console.log("좋아요 안 눌렀음");
            					likeCommentBtn.data("cliked", false);
            					likeCommentBtn.find("img").attr("src", "../../../resources/image/userPost/dislike.png");
            				}
            			},
            			error: function(xhr, status, error) {
            				console.log("Error checking comment like status:", error);
            			}
            		});
            	}
            	
            } */

            //setCommentButtonState();
            
            /* likeCommentBtn.on("click", function(e) {
            	e.preventDefault();
            	alert(1);
            }); */
            
           /*  commentList.on("click", "#likeComment-btn", function(e) {
            	e.preventDefault();
            	
            	var c_idx = $(this).data("c_idx");
            	var currentUser = '${currentUser}';
            	
            	//alert(currentUser);
            	//alert(c_idx);
            	//alert(up_idx);
            	
            	if (currentUser === '' || currentUser == null) {
            		alert("로그인이 필요합니다.");
            		window.location.href = '/user/loginPage';
            		return;
            	}
            	
            	var likeCommentBtn = $(this);
            	
            	if (!likeCommentBtn.prop("disabled")) {
            		var cliked = likeCommentBtn.data("cliked");
            		
            		$.ajax({
            			type: cliked ? "DELETE" : "POST",
            			url: cliked ? "/comment/dislike" : "/comment/like",
            			contentType: "application/json; charset=utf-8",
            			data: JSON.stringify({up_idx : up_idx, c_idx : c_idx}),
            			success: function(response) {
            				cliked = !cliked;
            				likeCommentBtn.data("cliked", cliked);
            				
            				//localStorage.setItem("cliked_" + c_idx, cliked);
            				
            	            likeCommentBtn.find("img").attr("src", cliked ? "../../../resources/image/userPost/like.png" : "../../../resources/image/userPost/dislike.png");
            	             
            	            console.log("cliked test : ", cliked);
            				
            			},
            			error: function(xhr, status, error) {
            				console.error("Error liking/disliking comment: ", error);
            			}
            		});
            	}
            	
            }); */
            
            // 대댓글 목록
            function showReplyList(c_idx, commentDiv) {
            	
            	$.ajax({
            		type: "GET",
            		url: "/comment/reply/" + c_idx,
            		dataType: "json",
            		success: function(result) {
            			var replyList = '';
            			for (var i = 0; i < result.length; i++) {
            				replyList += '<div class="replyList">';
            				replyList += '<h5>답글 작성자 : ' + result[i].u_writer + '</h5>';
            				replyList += '<h5>답글 내용 : ' + result[i].nc_content + '</h5>';
            				replyList += '<h5>답글 작성 날짜 : ' + displayTime(result[i].reg_date) + '</h5>';
            				if (principal === result[i].u_writer) {            					
	            				replyList += '<button class="modifyReplyBtn" data-nc_idx="' + result[i].nc_idx + '">수정</button>';
	            				replyList += '<button class="deleteReplyBtn" data-nc_idx="' + result[i].nc_idx + '">삭제</button>';
            				}
            				/* replyList += '<button class="likeReplyBtn">좋아요</button>'; */
            				//replyList += '<button class="reportReplyBtn" data-nc_idx="' + result[i].nc_idx + '">신고</button>';
            				replyList += '<button class="reportBtn" data-target_idx="' + result[i].nc_idx + '" data-report_category="reply"><img id="scrapImg" src="../../../resources/image/userPost/siren.png" style="border: none; width:20px; height: 20px; cursor: pointer;"></button>';
            				replyList += '</div>';
            			}
						
            			// 이전에 표시된 대댓글 목록 지우기
						//commentDiv.find(".replyList").remove();
            			// 새로운 대댓글 목록 commentDiv에 추가
						commentDiv.append(replyList);
            			
            			//console.log("리스트: ", replyList);
            		},
            		error: function(xhr, status, er) {
            			console.error("대댓글 목록 가져오기 중 오류 발생:", er);
            		}
            	});
            }

            // 댓글 등록
			$("#comWrite").on("click", function(e) {
	            e.preventDefault();
	            
	            //alert(principal);
	            
	            var c_content = $("input[name='c_content']").val();
	            var u_writer = principal;
	            
	            var comment = {
	                up_idx : up_idx,
	                c_content : c_content,
	                u_writer : u_writer
	            };
	            
	            $.ajax({
	                type: "POST",
	                url: "/comment/write",
	                data: JSON.stringify(comment),
	                contentType: "application/json; charset=utf-8",
	                success: function(result) {
	                	alert("댓글이 등록되었습니다.");
	                    console.log("댓글 등록 결과:", result);
	                    showCommentList();
	                    updateTotalComment(up_idx);
	                },
	                error: function(xhr, status, er) {
	                	alert("댓글이 등록되지 않았습니다.");
	                	console.error("댓글 등록 중 오류 발생:", er);
	                }
	            });
	        });
            
            // 대댓글 입력창 관련
            // 대댓글 입력 폼을 현재 대댓글 버튼이 속한 div에 추가
	        // $(this).closest('div') : 클릭된 대댓글 버튼의 상위로 가장 가까운 div 요소를 선택
	        // .append(replyForm) : 대댓글 작성폼 추가
	        // $(this) : replyBtn
	        // .closest('div') : comment div 전체
	        //$(this).closest('div').append(replyForm);
            commentList.on("click", ".replyBtn", function(e) {
            	e.preventDefault();
            	
            	var c_idx = $(this).data("c_idx");
            	var commentDiv = $(this).closest(".comment");	// 그냥 $(".comment") 하면 답글 버튼 누를 때마다 대댓글 입력 폼 보임

            	// 대댓글 작성 폼이 열려있으면 닫고, 아니면 열기
            	if (commentDiv.find('.replyForm').length > 0) {		// 입력 폼 이미 존재하면 닫기
            		commentDiv.find('.replyForm, .replyList').remove();
            	} else {
            		
            		'<sec:authorize access="isAuthenticated()">';
		            	// 대댓글 작성 폼
		            	var replyForm = '<div class="replyForm"><input type="text" name="nc_content" placeholder="답글 입력">';
						//replyForm += '<input type="hidden" name="u_writer" value=' + principal + '/>'          	
		            	replyForm += '<button class="replyWriteBtn" data-c_idx="' + c_idx + '">등록</button></div>';
            		'</sec:authorize>';
            		
            		'<sec:authorize access="isAnonymous()">';
            			var tmp = '/user/loginPage';
            			var replyForm = '<div class="replyForm"><input type="text" name="nc_content" placeholder="로그인 필수" readonly="readonly">';
            			replyForm += '<button type="button" onclick="">등록</button>';
            			replyForm += '</div>';
            		'</sec:authorize>';
            		
	            	commentDiv.append(replyForm);
	            	
	            	showReplyList(c_idx, commentDiv);
            	}
            	
            });
            
            // 대댓글 등록
            commentList.on("click", ".replyWriteBtn", function(e) {
            	e.preventDefault();
            	
            	var c_idx = $(this).data("c_idx");
            	var nc_content = $(this).closest(".replyForm").find("input[name='nc_content']").val();
	            //var u_writer = $(this).closest(".replyForm").find("input[name='u_writer']").val();
	            var u_writer = principal;
	                        
	            var reply = {
	            	up_idx: up_idx,
	            	c_idx: c_idx,
	            	nc_content: nc_content,
	            	u_writer: u_writer
	            }
	            	    
        		var commentDiv = $(this).closest('.comment');
	            
	            $.ajax({
	            	type: "POST",
	            	url: "/comment/reply/write",
	            	data: JSON.stringify(reply),
	            	contentType: "application/json; charset=utf-8",
	            	success: function(result) {
	            		alert("답글이 등록되었습니다.");
	            		console.log("답글 등록 결과:", result);
	            		
	            		showReplyList(c_idx, commentDiv);
	            		
	            	},
	            	error: function(xhr, status, er) {
	            		alert("답글이 등록되지 않았습니다.");
	            		console.log("답글 실패 결과:", er);
	            	}
	            });
            	
            });
            
            // 댓글 수정
            // prompt 빈 칸으로 입력했을 때 어떻게 처리할건지도 해야함
            commentList.on("click", ".modifyBtn", function(e) {
            	e.preventDefault();
            	
            	var c_idx = $(this).data("c_idx");
            	//alert(c_idx);
            	
            	var newContent = prompt("수정할 내용을 입력하세요.");
            	
            	if (newContent == null || newContent === '') {
            		alert("수정할 내용을 입력하지 않았습니다.");
            		return;
            	}
            	            	            	
            	if (newContent != null) {
            		var modifiedComment = {
            			c_idx: c_idx,
            			c_content: newContent
            		};
            		
            		$.ajax({
            			type: 'PUT',
            			url: '/comment/' + c_idx,
            			data: JSON.stringify(modifiedComment),
            			contentType: "application/json; charset=utf-8",
            			success: function(result) {
            				alert("댓글이 수정되었습니다.");
            				console.log("댓글 수정 결과:", result);
            				showCommentList();
            			},
            			error: function(xhr, status, er) {
            				alert("댓글이 수정되지 않았습니다.");
            				console.log("댓글 수정 중 오류 발생:", er);
            			}
            		});
            	}
            	
            });
            
            // 대댓글 수정
            commentList.on("click", ".modifyReplyBtn", function(e) {
            	e.preventDefault();
            	
            	var nc_idx = $(this).data("nc_idx");
            	
            	var newContent = prompt("수정할 내용을 입력하세요.");
            	
            	if (newContent == null || newContent === '') {
            		alert("수정할 내용을 입력하지 않았습니다.")
            		return;
            	}
            	
            	if (newContent != null) {
            		var modifiedReply = {
            			nc_idx: nc_idx,
            			nc_content: newContent
            		}
            		
            		var commentDiv = $(this).closest('.comment');
    	            var c_idx = commentDiv.find(".replyWriteBtn").data("c_idx");
            		
            		$.ajax({
            			type: 'PUT',
            			url: '/comment/reply/' + nc_idx,
            			data: JSON.stringify(modifiedReply),
            			contentType: "application/json; charset=utf-8",
            			success: function(result) {
            				alert("답글이 수정되었습니다.");
            				console.log("답글 수정 결과:", result);
            				
    	            		showReplyList(c_idx, commentDiv);
            			},
            			error: function(xhr, status, er) {
            				console.log("답글이 수정되지 않았습니다.");
            				console.log("답글 실패 결과:", er);
            			}
            		});
            	}
            });

            // 댓글 삭제
            commentList.on("click", ".deleteBtn", function(e) {
            	e.preventDefault();
            	
            	var c_idx = $(this).data("c_idx");	// data-c_idx 에 담긴 값
            	//alert(c_idx);
            	
            	if(confirm("댓글을 삭제하겠습니까?")) {	// 확인 후 댓글 삭제
	            	$.ajax({
	            		type: 'DELETE',
	            		url: '/comment/' + c_idx,
	            		success: function(result) {
	            			alert("댓글이 삭제되었습니다.");
	            			console.log("댓글 삭제 결과:", result);
	            			showCommentList();
	            		},
	            		error: function(xhr, status, er) {
	            			alert("댓글이 삭제되지 않았습니다.");
	            			console.error("댓글 삭제 중 오류 발생:", er);
	            		}
	            	});
            	}
            	
            });
            
            
            // 대댓글 삭제
            commentList.on("click", ".deleteReplyBtn", function(e) {
            	e.preventDefault();
            	
            	var nc_idx = $(this).data("nc_idx");
            	
            	var commentDiv = $(this).closest('.comment');
        		var c_idx = commentDiv.find(".replyWriteBtn").data("c_idx");
            	
            	if(confirm("답글을 삭제하겠습니까?")); {
            		$.ajax({
            			type: 'DELETE',
            			url: '/comment/reply/' + nc_idx,
            			success: function(result) {
            				alert("답글이 삭제되었습니다.");
            				console.log("답글 삭제 결과:", result);
            				
    	            		showReplyList(c_idx, commentDiv);
            			},
            			error: function(xhr, status, er) {
            				alert("답글이 삭제되지 않았습니다.");
            				console.error("답글 삭제 중 오류 발생:", er);
            			}
            		});
            	}
            	showReplyList(c_idx, commentDiv);
            });
            
            
            // 신고
            commentList.on("click", ".reportBtn", function(e) {
            	e.preventDefault();
            	
            	if (principal === '' || principal == null) {
					alert("로그인이 필요합니다.");
					window.location.href = '/user/loginPage';
					return;
				}
				
				var reportContent = prompt("신고 사유를 입력해주세요.");
				
				if (reportContent == null || reportContent === '') {
					alert("신고 사유를 입력해주세요.");
					return;
				}
				
				var idx = $(this).data("target_idx");
				var category = $(this).data("report_category");
				
				var report = {
					r_content : reportContent,
					r_category : category,
					idx : idx,
					u_writer : principal
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
</body>
</html>
