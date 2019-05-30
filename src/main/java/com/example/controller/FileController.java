package com.example.controller;


import me.desair.tus.server.TusFileUploadService;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Map;

@Controller
public class FileController {

    @Value("${task.path.upload}")
    private String uploadPath;





    @PostMapping("/upload")
    @ResponseBody
    public  String uoload(HttpServletRequest request , @RequestParam("file") MultipartFile file) throws FileNotFoundException {
        System.out.println( ResourceUtils.getFile(uploadPath));


        System.out.println("UPLOAD PATH : " +uploadPath);
        try {
            File saveFile = new File( uploadPath +"/" +file.getOriginalFilename());
            OutputStream out = new FileOutputStream(saveFile);

            IOUtils.copy(file.getInputStream() ,out);
            return "UPLOAD SUCESS";
        } catch (IOException e) {
            e.printStackTrace();
            return "FAIL :" +e.getMessage();
        }

    }


    @PostMapping("/webupload")
    @ResponseBody
    public String uploadPart( @RequestParam(name = "chunk" ,defaultValue = "0") int  chunk ,@RequestParam("task_id") String taskId , @RequestParam("file") MultipartFile file) throws IOException {

        System.out.println(chunk +"==================");

        String filename = taskId +chunk;
        try( OutputStream outputStream = new FileOutputStream(uploadPath +"/" + filename)){

            IOUtils.copy(file.getInputStream() ,outputStream);
            return "ok";

        }catch (Exception e){
            return "not ok";
        }


    }




    @GetMapping("/webupload/merge")
    @ResponseBody
    public String webUploadSucess(HttpServletRequest request) throws IOException {

            String filename = request.getParameter("filename");
            String taskId = request.getParameter("task_id");
            int chunk = 0;
            try(OutputStream outputStream = new FileOutputStream(uploadPath +"/" +filename)){
                while(true){
                    File _file = new File(uploadPath +"/" +taskId +chunk);
                    if( ! _file.exists()){
                        break;
                    }
                    byte[] buf = new byte[1024];

                    try(InputStream inputStream = new FileInputStream(_file )){
                        int  len;
                        while((len = inputStream.read(buf)) >0) {
                            outputStream.write(buf,0,len);
                        }
                        chunk += 1;


                    }
                    _file.delete() ;


                }

            }
            return  "OK";

    }




    @GetMapping("/{page}")
    public String showUploadPage(@PathVariable("page") String page){

        return page;

    }


}
