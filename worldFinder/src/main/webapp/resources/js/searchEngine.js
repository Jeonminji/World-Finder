let countrys = "";
$.ajax({
    url: "/logoSeach",
    dataType: "json",
    type: "get",
    async: false,
    success: function (datas) {
        countrys = datas;
    },
})



let searchV = "";



function clickSpanCountry(s) {
    location.href = `/country/\${s.innerText}`;
}


const searchBar = $("#searchBar");
const res = $("#res");

$("#searchMagnifier").on('click', function () {
    if (searchBar.val() != ""){
        location.href = "/country/" + searchBar.val();
    }

})

res.on('click','.clickSpan',function () {
    location.href = "/country/" + $(this).text();
})

// 대화창 좀더 깔끔하게 만들기
document.querySelector("body").addEventListener("click" ,(e) => {
    if (searchBar.val() !== ""){

        if (e.target == document.getElementById("searchBar") &&  res.css('display') == 'block'){
            res.css('display', 'none');
            return;
        }

        if(e.target == document.getElementById("searchBar")
            || e.target == document.getElementById("res") ) {
            res.css('display', 'block');
        } else {
            res.css('display', 'none');
        }
    }

})


// searchBar.on("focusin", () => {
//     if (searchBar.val() !== "") {
//         res.css('display', 'inline-block');
//     }
// })


function searchEvent(e) {

    // 포커스가 없을때
    if (res.children("#focusSpan").length <= 0) {
        if (e == 38) {
            res.css('display', 'none');
        } else if (e == 40) {
            res.css('display', 'inline-block');
            res.children("span.clickSpan").first().attr("id", "focusSpan");
            searchBar.val(res.children("#focusSpan").text())
        }
        // 포커스가 있을때
    } else {
        let dis = res.children("#focusSpan");

        if (e == 38) {
            if (dis.prevAll(".clickSpan").length == 0) {
                dis.removeAttr("id");
                searchBar.val(searchV);
            } else {
                dis.removeAttr("id");
                dis.prevAll(".clickSpan").first().attr("id", "focusSpan");
                searchBar.val(dis.prevAll(".clickSpan").first().text())
            }
        } else if (e == 40) {
            if (dis.nextAll(".clickSpan").length == 0) {
                dis.removeAttr("id");
                res.children("span.clickSpan").first().attr("id", "focusSpan");
                searchBar.val(res.children("#focusSpan").text());
            } else {
                dis.removeAttr("id");
                dis.nextAll(".clickSpan").first().attr("id", "focusSpan");
                searchBar.val(dis.nextAll(".clickSpan").first().text());
            }
        }

    }


}

// 검색엔진 활성화시
searchBar.on("keyup", function (e) {

    if (e.keyCode == 37 || e.keyCode == 39) {
        return;
    }
    
    // 검색엔진 화살표 이벤트 추가
    if (((e.keyCode == 38 || e.keyCode == 40)
        && res.find("span").text() != " 검색결과가 없습니다 ") && $(this).val() != "") {
        searchEvent(e.keyCode);

        return;
    }
    
    // 엔터키 활성화
    if (e.keyCode === 13) {
        if (searchBar.val() != ""){
            location.href = "/country/" + searchBar.val();
        }
    }
    res.css('display', 'inline-block');
    res.html("");


    let count = 0;
    let countryList = [];
    let semiCountryList = [];
    searchV = $(this).val().replaceAll(" ", "");

    if (searchV.length > 0) {
        for (let i = 0; i < countrys.length; i++) {
            let compare = (countrys[i]["country"].replaceAll(" ", "")).indexOf(searchV);

            if (compare === 0) {
                countryList.push(i);
            } else if (compare >= 1) {
                semiCountryList.push(i);
            } else if (compare === -1) {
                count++;
            }
        }
    } else if (searchV.length < 1) {
        res.css('display', 'none');
        return;
    }

    if (count == countrys.length) {
        res.html("<span> 검색결과가 없습니다 <span>");
    } else {
        let result = "";
        for (let i = 0; i < countryList.length; i++) {
            result += `<span class="clickSpan" >${countrys[countryList[i]]["country"]}</span> </br>`;
            if (i == 5) {
                break;
            }
        }
        if (countryList.length < 5) {
            for (let i = 0; i < semiCountryList.length; i++) {
                result += `<span class="clickSpan">${countrys[semiCountryList[i]]["country"]}</span> </br>`;
                if (i + countryList.length == 5) {
                    break;
                }
            }
        }
        res.html(result);
    }


})