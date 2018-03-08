<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  Date: 2018/3/8
  Time: 08:43
  To change this template use MyFile | Settings | MyFile Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>FileLoader</title>
        <script src="/js/jquery-1.10.2.js"></script>
        <script src="/js/bootstrap.js"></script>
        <link rel="stylesheet" href="/css/bootstrap.css">
        <style>
            .list-group-item:hover{
                background-color: #F5FFFA;
            }
            #comfirm:hover{
                background-color: lightgray;
            }
        </style>
    </head>
    <body>
    <table class="table">
        <h1 style="color: gray;">文件夹及文件</h1><br />
        <ul class="list-group" style="max-height: 500px;overflow: scroll">
            <li class="list-group-item" onclick="toRoot()">顶级目录</li>
            <li class="list-group-item" onclick="toUpper()">上级目录</li>
            <c:forEach var="dir" items="${dirList}">
                <li class="list-group-item" type="dir">${dir}/..</li>
            </c:forEach>
            <c:forEach var="file" items="${fileList}">
                <li class="list-group-item" type="file">${file.name}</li>
            </c:forEach>
        </ul>
        <div class="input-group">
            <span class="input-group-addon">文件目录：</span>
            <input id="path" type="text" class="form-control" value="${path}">
            <span class="input-group-addon">显示文件后缀:</span>
            <span class="input-group-addon">
                <ul class="nav navbar-nav">
                    <li class="dropdown">
                        <a id="suffix" href="#" class="dropdown-toggle" data-toggle="dropdown"
                           style="padding-top: 0px;padding-bottom: 0px;">${suffix}<b class="caret"></b></a>
                        <ul class="dropdown-menu" style="max-height: 200px;overflow: scroll">
                            <li  data-toggle="modal" data-target="#addSuffixModal"><center>添加类型</center></li>
                            <c:forEach var="theSuffix" items="${suffixList}">
                                <li><a href="#">${theSuffix}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </ul>
            </span>
            <span id="comfirm" class="input-group-addon">确认</span>
        </div>
    </table>

    <!-- 模态框（Modal） -->
    <div class="modal fade" id="addSuffixModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        添加文件后缀类型
                    </h4>
                </div>
                <div class="modal-body">
                    <h5>后缀：</h5><input id="newSuffix" type="text" class="form-control"  placeholder=".txt" />
                    <h5>类型：</h5><input id="newType" type="text" class="form-control"  placeholder="文档" />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button id="addSubmit" type="button" class="btn btn-primary">
                        提交
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

    <!-- 模态框（Modal） -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-hidden="true">×
                    </button>
                </div>
                <div id="modal-body" class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                            data-dismiss="modal">关闭
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <script type="text/javascript">
        function toRoot() {
            window.location.href = "/FileLoader/index?path=/Users/geminit&suffix=" + $("#suffix").text().replace(" ","");
        }

        function toUpper() {
            var path = "${path}";
            if (path == "/Users/geminit")
                return;
            var presentPath = path.split("/")[path.split("/").length-1];
            var newPath = path.split("/" + presentPath)[0];
            window.location.href = "/FileLoader/index?path=" + newPath + "&suffix=" + $("#suffix").text().replace(" ","");
        }
    </script>
    <script type="text/javascript">
        $("a").click(function(){
            $("#suffix").html($(this).text() + "<b class=\"caret\"></b>");
        });
    </script>
    <script type="text/javascript">
        $(".list-group-item").click(function(){
            if ($(this).attr("type") == "dir"){
                var path = "${path}" + "/" + $(this).text().split("/")[0];
                window.location.href = "/FileLoader/index?path=" + path + "&suffix=" + $("#suffix").text().replace(" ","");
            }else if($(this).attr("type") == "file"){
                var str = {};
                str["pwd"] = "${path}" + "/" + $(this).text();

                $.ajax({                    //获得各个区域的值
                    type:"post",
                    async: false, //同步执行
                    url:"/FileLoader/index/getFile",
                    data:str,
                    success:function(result){
                        $("#modal-body").html(result.content);
                        $('#myModal').modal('show');
                    }
                });
            }
        });
    </script>
    <script type="text/javascript">
        $("#comfirm").click(function(){
            window.location.href = "/FileLoader/index?path=" + $("#path").val().replace(" ","")
                                                + "&suffix=" + $("#suffix").text().replace(" ","");
        });
    </script>
    <script type="text/javascript">
        $("#addSubmit").click(function(){
            var str = {};
            str["suffix"] = $("#newSuffix").val().replace(" ","");
            str["type"] = $("#newType").val().replace(" ","");

            $.ajax({                    //获得各个区域的值
                type:"post",
                async: false, //同步执行
                url:"/FileLoader/index/addSuffix",
                data:str,
                success:function(result){
                    $("#modal-body").html(result.result);
                    $('#myModal').modal('show');
                }
            });
        });
    </script>
    </body>
</html>
