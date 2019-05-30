<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>web-uploader</title>

    <link rel="stylesheet" href="/static/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="/static/css/webuploader.css">
    <script src="/static/js/jquery-3.4.1.min.js"></script>
    <script src="/static/js/bootstrap.min.js"></script>
    <script src="/static/js/webuploader.min.js"></script>
</head>
<body>
<h1>break point upload</h1>
<div style="margin:50px 0 0 50px;">
    <div id="picker" style="float:left;">请选择</div>
    <div id="progress" class="progress" style="width:500px;float:left;margin:10px 0 0 20px;">
        <div class="progress-bar progress-bar-striped active" role="progressbar" style="width:0%;"></div>



    <div style="clear:both;"></div>
</div>

<button id="stop" class="btn btn-secondary">暂停</button>


<script >
let  uploader;

   $(function() {

      $("#stop").hide();
       var task_id = WebUploader.Base.guid(); // 产生文件唯一标识符task_id
       uploader = WebUploader.create({

           server: '/webupload', // 上传分片地址
           pick: '#picker',
           auto: true,
           chunked: true,
           chunkSize: 20 * 1024 * 1024,
           chunkRetry: 3,
           threads: 2,
           duplicate: true,
           formData: { // 上传分片的http请求中一同携带的数据
               task_id: task_id,
           },
       });

       uploader.on('startUpload', function() { // 开始上传时，调用该方法
           $('#progress').show();
           $('.progress-bar').css('width', '0%');
           $('.progress-bar').text('0%');
           $('.progress-bar').removeClass('progress-bar-danger progress-bar-success');
           $('.progress-bar').addClass('active progress-bar-striped');
           $("#stop").show();
       });

       uploader.on('uploadProgress', function(file, percentage) { // 一个分片上传成功后，调用该方法


           $('.progress-bar').css('width', percentage * 100 - 1 + '%');
           $('.progress-bar').text(Math.floor(percentage * 100 - 1) + '%');

       });

       uploader.on('uploadSuccess', function(file) { // 整个文件的所有分片都上传成功后，调用该方法
           var data = { 'task_id': task_id, 'filename': file.source['name'] };
           $.get('/webupload/merge', data);
           $('.progress-bar').css('width', '100%');
           $('.progress-bar').text('100%');
           $('.progress-bar').addClass('progress-bar-success');
           $('.progress-bar').text('上传完成');
       });

       uploader.on('uploadError', function(file) { // 上传过程中发生异常，调用该方法
           $('.progress-bar').css('width', '100%');
           $('.progress-bar').text('100%');
           $('.progress-bar').addClass('progress-bar-danger');
           $('.progress-bar').text('上传失败');
       });

       uploader.on('uploadComplete', function(file) { // 上传结束，无论文件最终是否上传成功，该方法都会被调用
           $('.progress-bar').removeClass('active progress-bar-striped');
           $("#stop").hide()
       });

       $("#stop").click(  function () {

           setTimeout(

               function () {
                   if($("#stop").text() === "暂停"){

                       uploader.stop(true);
                       $("#stop").text("继续");
                       $("#stop").removeClass("btn-secondary").addClass("btn-primary");

                   }else{
                       uploader.upload();
                       $("#stop").text("暂停");
                       $("#stop").removeClass("btn-primary").addClass("btn-secondary");

                   }
               } ,1000
           );


       });


       $('#progress').hide();
   });
</script>

</body>
</html>