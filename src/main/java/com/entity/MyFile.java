package com.entity;

public class MyFile {
    private String name;
    private String path;
    private String suffix;

    public MyFile(String pwd){
        int pathLength = pwd.split("/").length;
        name = pwd.split("/")[pathLength-1];
        path = pwd.split(name)[0];
        int suffixLength = pwd.split("\\.").length;
        suffix = "." + pwd.split("\\.")[suffixLength-1];
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }
}
