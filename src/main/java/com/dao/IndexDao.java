package com.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IndexDao {

    public List<String> getAllSuffix();

    public String getTypeBySuffix(String suffix);

    public void insertNewSuffix(@Param("suffix")String suffix, @Param("type")String type);

}
