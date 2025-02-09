<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<style>
    #filter{
        position: absolute;
        width: 400px;
        height: 250px;
        border: 1px solid black;
        border-radius: 5px;
        padding: 30px 10px;
        z-index: 100;
        margin: 0px;
        background-color: white;
    }
    #filter_continent div{
        text-align: center;
        padding-top: 15px;
        padding-bottom: 10px;
        padding-right: 26px;
        border-bottom: 1px solid antiquewhite;
        font-size: 10px;
        width: 80px;
        display: inline-block;
        cursor: pointer;
    }
    .filter_click {
        background-color: #D6D6D6;
    }
    .filter_title{
        margin-top: 5px;
        margin-bottom: 5px;
    }
    #filter_continent{
        position: absolute;
        display: inline-block;
        border: 1px solid antiquewhite;
        width: 25%;
        height: 200px;
    }
    #filter_country_main{
        position: relative;
        /*필터 크기 바꾸면 여기 설정해줘야됨*/
        left: 100px;
        display: inline-block;
        width: 75%;
        border: 1px solid antiquewhite;
        border-left: none;
        height: 200px;
    }
    #filter_detail_continent{
        display: flex;
        display: inline-block;
        height: 100%;
        margin-top: 0;
        overflow: auto;
        margin-left: 6px;
        font-size: 12px;
        padding-left: 0px;

    }
    #filter_detail_continent li{
        width: 80px;
        cursor: pointer;
        list-style: none;
        flex-direction: column;
        padding: 10px 20px 5px 10px;
    }
    #filter_country{
        width: 55%;
        display: flex;
        display: inline-block;
        margin-top: 0;
        overflow: auto;
        margin-left: 6px;
        margin-right: 0px;
        font-size: 12px;
        padding-left: 5px;
        height: 100%;
    }
    #filter_country li{
        cursor: pointer;
        text-decoration: none;
        flex-direction: column;
        padding-left: 10px;
        padding-top: 10px;
        padding-bottom: 5px;
    }
</style>
<button id="filterBtn">
    필터
</button>

<div id="filter" style="display: none">
    <div class="filter_title">지역</div>
    <div id="filter_continent">
        <div>아시아</div>
        <div>유럽</div>
        <div>아프리카</div>
        <div>아메리카</div>
        <div>오세아니아</div>
    </div>
    <div id="filter_country_main">
        <ul id="filter_detail_continent">

        </ul>
        <ul id="filter_country">

        </ul>
    </div>
    <div style="text-align: right"><button id="filter_out">X</button></div>
</div>

<script>
    const filter = document.getElementById("filter");
    const  filter_detail_continent =  $("#filter_detail_continent");
    const  filter_country = $("#filter_country");
    
  	//======================추가된 코드===========================
    var contiInform = "";		//대륙 이름 전역변수
    var detailContiInform = "";		//세부 대륙 이름 전역변수
    //=========================================================

    document.getElementById("filter_out").addEventListener('click',()=>{
        filter.style.display = "none";
        // filter_country.html("");
        // filter_detail_continent.html("");
        //
        // $("#filter_continent").find(".filter_click").removeAttr('class');
    })
    
    //======================추가된 코드===========================
    	
    //필터 바깥쪽 클릭하면 필터창 닫기
 	$(document).mouseup($("#filter"), function (e){
		if($("#filter").has(e.target).length === 0){
			$("#filter").hide();
		}
	});
            
    //=========================================================

    // 필터 버튼 클릭
    document.getElementById("filterBtn").addEventListener('click',() =>{
        if (filter.style.display == "none"){
            filter.style.display = "inline-block";
        } else if (filter.style.display == "inline-block"){
            filter.style.display = "none";
        }
    })

    // 대륙 클릭
    $("#filter_continent").on('click','div',(e) => {
        let filter_click = $("#filter_continent").find(".filter_click");
        if (e.target.getAttribute('class') == 'filter_click'){
            e.target.removeAttribute('class');
            filter_country.html("");
            filter_detail_continent.html("");
            return;
        } else {
            if (filter_click != null){
                filter_click.removeAttr('class');
            }
            filter_country.html("");
            filter_detail_continent.html("");
            e.target.setAttribute('class','filter_click');
            filterAjax(e.target.innerHTML,"detail_c")
            
            //======================추가된 코드===========================
            contiInform = e.target.innerHTML;
            //=========================================================
        }

    })
    // 세부 대륙 클릭
    filter_detail_continent.on('click','li',(e) =>{
        let filter_click = filter_detail_continent.find(".filter_click");
        if (e.target.getAttribute('class') == 'filter_click'){
            e.target.removeAttribute('class');
            filter_country.html("");
            return;
        } else {
            if (filter_click != null){
                filter_click.removeAttr('class');
            }
            filter_country.html("");
            e.target.setAttribute('class','filter_click');
            filterAjax(e.target.innerHTML,"country")
	
            //======================추가된 코드===========================
            detailContiInform = e.target.innerHTML;
            //=========================================================

        }

    })
    // 나라 클릭
    filter_country.on('click','li',(e) =>{
        let filter_click = filter_country.find(".filter_click");
        if (e.target.getAttribute('class') == 'filter_click'){
            e.target.removeAttribute('class');
            return;
        } else {
            if (filter_click != null){
                filter_click.removeAttr('class');
            }
            e.target.setAttribute('class','filter_click');
            
         // 여기에 태우고싶은 함수 태우면 됨
         
         //=====================추가된 코드==============================
        	 
         //나라이름 검색 필터에 넣기
         ranName(e.target.innerHTML);
         
         //나라정보 출력 (대륙 > 소대륙 > 나라)
         var inform = "" + contiInform 
         				+ " > " + detailContiInform 
         				+ " > " + e.target.innerHTML;
         writeCountry(inform);
        }
        
        //나라이름까지 클릭시 필터 닫기
        $("#filter").hide();
        
        //=============================================================
    })

    function filterAjax(filterValue,category) {
        $.ajax({
            url: "/filter/"+filterValue +"/"+category ,
            dataType : "json",
            type : "post",
            success : function (datas) {
                if (datas.length < 1){
                    return;
                }
                insertFilter(datas)
            },
        })
    }

    function insertFilter(data){
        let content = "";

        if (Object.keys(data[0])[0] == 'DETAILS_CONTINENT'){
            data.forEach((a) => {
                content += `<li>\${a.DETAILS_CONTINENT}</li> `;
            })

            filter_detail_continent.html(content);
        } else {
            data.forEach((a) => {
                content += `<li>\${a.COUNTRY}</li> `;
            })

            filter_country.html(content);
        }
    }
    
</script>
