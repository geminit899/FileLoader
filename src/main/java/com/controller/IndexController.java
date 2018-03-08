package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.entity.*;
import com.service.IndexService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/FileLoader")
public class IndexController {

    @Autowired
    IndexService indexService;

    //映射一个action
    @RequestMapping("/index")
    public String index(Model model, HttpServletRequest request) throws Exception {

        //设置默认的路径和后缀
        String path = "/Users/geminit";
        String suffix = ".*";

        //若用户设置了路径和后缀,则获取
        if( request.getParameter("path") != null )
            path = request.getParameter("path");
        if( request.getParameter("suffix") != null )
            suffix = request.getParameter("suffix");

        if (path.contains(".")){              //path包含文件名
            MyFile myFile = new MyFile(path);
            path = myFile.getPath();
        }

        File fdir = new File(path);
        File[] allFile = fdir.listFiles();          //path路径下所有的文件及文件夹

        if (allFile == null)          //path路径错误
            return "/util/404";

        List<String> dir = new ArrayList<>();       //文件夹
        List<MyFile> files = new ArrayList<>();     //文件
        MyFile file;

        for (int i=0; i<allFile.length; i++){
            String name = allFile[i].getName();
            if(name.charAt(0) == '.' || name.charAt(0) == '~')    //过滤类似 .DS_Store 的文件
                continue;
            if (allFile[i].isFile()){   //判断是否为文件
                file = new MyFile(path + "/" + name);
                if(suffix.equals(".*"))      //根据需要显示的后缀判断是否显示
                    files.add(file);
                else
                    if (suffix.equalsIgnoreCase(file.getSuffix()))
                        files.add(file);
            }else {
                dir.add(name);
            }
        }

        List<String> suffixList = indexService.getAllSuffix();      //获取所有的后缀

        model.addAttribute("path", path);
        model.addAttribute("suffix", suffix);
        model.addAttribute("suffixList", suffixList);
        model.addAttribute("dirList", dir);
        model.addAttribute("fileList", files);

        return "index";
    }

    //映射一个action
    @RequestMapping(value = "/index/getFile", produces = "application/json;charset=utf-8")
    @ResponseBody
    public JSONObject getFile(HttpServletRequest request, HttpServletResponse response) {

        String pwd = request.getParameter("pwd");

        MyFile myFile = new MyFile(pwd);

        String type = indexService.getTypeBySuffix(myFile.getSuffix());

        String content = "已成功打开" + type;

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("content", content);

        return jsonObject;
    }

    //映射一个action
    @RequestMapping(value = "/index/addSuffix", produces = "application/json;charset=utf-8")
    @ResponseBody
    public JSONObject addSuffix(HttpServletRequest request, HttpServletResponse response) {

        String suffix = request.getParameter("suffix");
        String type = request.getParameter("type");

        JSONObject jsonObject = new JSONObject();

        try {
            indexService.insertNewSuffix(suffix, type);
        } catch (Exception e){
            jsonObject.put("result", "添加失败！");
            return jsonObject;
        }

        jsonObject.put("result", "添加成功！");
        return jsonObject;
    }

}
