//
//  Search.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 02.11.2021.
//

import Foundation

struct Search {
    
    var fetchFrom = JSONParser()
    var array = [String]()
    
    init() {
        for searchText in searchDict().keys {
            array.append(searchText)
        }
    }
    
    
    func searchDict() -> [String: String] {
        
        let dict = [
            "командир звена":         fetchFrom.json.service[0],
            "газодымозащитник":     fetchFrom.json.service[1],
            "постовой на посту безопасности":         fetchFrom.json.service[2],
            
            "помощник НК":             fetchFrom.json.functional[0],
            "пнк":             fetchFrom.json.functional[0],
            "командир отделения":     fetchFrom.json.functional[1],
            "пожарный":             fetchFrom.json.functional[2],
            "водитель ПА":             fetchFrom.json.functional[3],
            
            "дежурный по подразделению":     fetchFrom.json.inner[0],
            "дневальный по гаражу":         fetchFrom.json.inner[1],
            "дневальный по помещениям":     fetchFrom.json.inner[2],
            "постовой у фасада":             fetchFrom.json.inner[3],
            
            "обслуживание сизод":         fetchFrom.json.maintenance[0],
            "правила работы в СИЗОД":     fetchFrom.json.maintenance[1],
            "звено ГДЗС":                 fetchFrom.json.maintenance[2],
            "пост безопасности":         fetchFrom.json.maintenance[2],
            
            "минимум оснащения":     fetchFrom.json.maintenance[3],
            "оснащение звена":         fetchFrom.json.maintenance[3],
            
            "5 решающих направлений":                  fetchFrom.json.leader[0],
            "ртп":                  fetchFrom.json.leader[1],
            "кто является ртп":                  fetchFrom.json.leader[1],
            "полномочия РТП":                  fetchFrom.json.leader[3],
            "оперативный штаб":                  fetchFrom.json.leader[4],
            "разведка":                  fetchFrom.json.leader[6],
            
        ]
        
//        let keys = fetchFrom.json.filter{$0.lowercased().contains("dfg")
        
        return dict
    }
    
    func getContent(by: String) -> String {
        
        if let text = searchDict()[by] {
            return text
        }
        
        return "fail"
    }
    
}
