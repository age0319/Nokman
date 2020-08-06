//
//  SaveData.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/08/04.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class SaveData {
    
    let stages = ["stage1","stage2","stage3"]
    
    // key:stage1,2,3
    // value:true=クリア済み
    func save(key:String,value:Bool){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(key:String) -> Bool{
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func isAllClear()->Bool{
        if get(key: "stage1") && get(key: "stage2") && get(key: "stage3"){
            return true
        }else{
            return false
        }
    }
}
