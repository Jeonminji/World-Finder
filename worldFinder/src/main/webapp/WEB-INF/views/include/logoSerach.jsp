<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<link rel="stylesheet" href="../../../resources/css/logoSearch.css">
<span id="sch">
    <img src="../../../resources/image/smallLogo.png" id="smallLogo">
    <input type="text" name="search" placeholder="알고싶은 나라"
           autocomplete="off" id="searchBar"> <br>
    <div id="res">
    </div>
    <input type="button" style="display: none" id="btn">
    <label for="btn">
        <img src="../../../resources/image/search.png" id="searchMagnifier">
    </label>
</span>
<script>
    document.getElementById("smallLogo").onclick = function () {
        location.href = "/";
    }
</script>
<script src="../../../resources/js/searchEngine.js"></script>