//
//  topSet.swift
//  honyakun
//
//  Created by WKC on 2016/09/03.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit

class topSetClass:NSObject{
    let topImage:UIImage!
    let labelText:String!
    let explainText:String!
    
    init(image:UIImage,labelText:String,explainText:String){
        self.topImage = image
        self.labelText = labelText
        self.explainText = explainText
    }
    
}

