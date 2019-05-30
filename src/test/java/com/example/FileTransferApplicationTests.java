package com.example;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.ResourceUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URISyntaxException;

@RunWith(SpringRunner.class)
@SpringBootTest
public class FileTransferApplicationTests {

    @Value("${task.path.upload}")
    private String uploadPath;

    @Test
    public void contextLoads() throws  FileNotFoundException {
         System.out.println(FileTransferApplication.class.getResource("/com/example/controller/FileController.class"));

    }

}
