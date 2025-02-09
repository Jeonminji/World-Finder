
<style>
    #logo img{
        display: inline-block;
        width: 300px;
        cursor: pointer;
        margin-top: 20px;
    }
</style>
<span id="logo"><img src="../../../resources/image/logo.jpg" /></span>
<script>
    function homeGoLogo (){
        location.href = "/";
    }


    document.getElementById("logo").addEventListener("click", homeGoLogo)
</script>