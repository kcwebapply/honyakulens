//
//  wordCard.swift
//  honyakun
//
//  Created by WKC on 2016/09/19.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation


class wordCard:NSObject{
    var id:Int!
    var word:String!
    var lang:String!
    
    init(id:Int,word:String,lang:String){
        self.id = id
        self.word = word
        self.lang = lang
    }
    
}