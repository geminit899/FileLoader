package com.service.impl;

import com.dao.IndexDao;
import com.service.IndexService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(rollbackFor = Exception.class)
public class IndexServiceImpl implements IndexService {

    @Autowired
    IndexDao indexDao;

    public List<String> getAllSuffix(){ return indexDao.getAllSuffix(); }

    public String getTypeBySuffix(String suffix){ return indexDao.getTypeBySuffix(suffix); }

    public void insertNewSuffix(String suffix, String type){ indexDao.insertNewSuffix(suffix, type); }
}
