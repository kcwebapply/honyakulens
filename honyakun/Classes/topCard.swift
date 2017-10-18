//
//  topCard.swift
//  honyakun
//
//  Created by WKC on 2016/09/30.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

class topCard:NSObject{
    
    var title:String!
    var content:String!
    var lang:String!
    init(title:String,content:String,lang:String){
        self.title = title
        self.content = content
        self.lang = lang
    }
    
}
