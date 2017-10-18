//
//  textListClass.swift
//  honyakun
//
//  Created by WKC on 2016/09/18.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

class textSet:NSObject{
    var titleImage:UIImage!
    var titleText:String!
    var lang:String!
    var contentText:String!
    
    init(title:String,image:UIImage,lang:String,contentText:String){
        self.titleImage = image
        self.titleText = title
        self.lang = lang
        self.contentText = contentText
    }
    
    
}
