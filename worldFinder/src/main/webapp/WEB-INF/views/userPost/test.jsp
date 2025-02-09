<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script type="text/javascript">
		$(function() {
			
			$("#payBtn").on("click", function(e) {
				e.preventDefault();
				
				alert(2);
				
				IMP.init('imp65675182');
				IMP.request_pay({
					pg: 'kakaopay',
					pay_method : 'card',
					merchant_uid: "order_monthly_0004", // 상점에서 관리하는 주문 번호, 결제할 때마다 바꿔야함
					name : 'oo호텔', 	// 상품명
					amount :3000, // 결제 금액
					customer_uid : 'min_0002', // 필수 입력
					buyer_email : 'iamport@siot.do',
					buyer_name : '아임포트',
					buyer_tel : '02-1234-1234'
				}, function(rsp) {
					if ( rsp.success ) {
						alert('결제 성공');
					} else {
						alert('결제 실패');
					}
				});
			
				
			});
			
		});
</script>
</head>
<body>
	<button id="payBtn">결제</button>
	
</body>
</html>