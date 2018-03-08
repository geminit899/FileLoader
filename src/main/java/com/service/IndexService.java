package com.service;

import java.util.List;

public interface IndexService {
    public List<String> getAllSuffix();

    public String getTypeBySuffix(String suffix);

    public void insertNewSuffix(String suffix, String type);
}
