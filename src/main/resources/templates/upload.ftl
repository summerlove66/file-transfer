<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>

    <link rel="stylesheet" href="/static/css/bootstrap.min.css"/>
    <script src="/static/js/jquery-3.4.1.min.js"></script>
    <script src="/static/js/bootstrap.min.js"></script>
</head>
<body>

<h1>UPLOAD</h1>


</body>

<form action="http://localhost:8080/upload" method="POST" enctype="multipart/form-data" >
    <input type="file" name="file" id="upload">

</form>
<button  onclick="upload()">提交 </button>
<progress id="uploadprogress" min="0" max="100" value="0">0</progress>
</body>

<script>

    function upload() {
        console.log("+=======");
        if(window.FormData) {

            let formData = new FormData();

            formData.append("file",$("#upload")[0].files[0]);
            // 建立一个upload表单项，值为上传的文件
            formData.append('upload', document.getElementById('upload').files[0]);

            let xhr = new XMLHttpRequest();

            xhr.open('POST', $("form").attr('action'));



            xhr.upload.onprogress = function (event) {

                if (event.lengthComputable) {

                    let complete = (event.loaded / event.total * 100 | 0);

                    let progress = document.getElementById('uploadprogress');

                    progress.value = progress.innerHTML = complete;

                }

            };



            // 定义上传完成后的回调函数
            xhr.onload = function () {

                if (xhr.status === 200) {

                    console.log('上传成功');

                } else {

                    console.log('出错了');

                }

            };


            xhr.send(formData);

        }


    }








</script>
</html>