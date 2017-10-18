//
//  jsonClass.swift
//  honyakun
//
//  Created by WKC on 2016/09/17.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit

class jsonClass:NSObject{
    var data:Data!
    var text:String = ""
    var mean:String = ""
    var exText:String = ""
    var transText:String = ""
    
    init(data:Data){
        self.data = data
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let statusesArray = jsonObject as? NSDictionary{
               // if let meantext =  statusesArray["mean"]{self.mean = meantext as! String; print("\(meantext)")}
                 guard let meantext = statusesArray["mean"] as? String else{
                    print("意味アウト")
                    self.mean = ""
                    self.exText = ""
                    self.transText = ""
                    return
                }
                self.mean = meantext
                
                guard let extext = statusesArray["text"] as? String else{
                    self.exText = ""
                    self.transText = ""
                    return
                }
                self.exText = extext
                
                guard let transText = statusesArray["trans"] as? String else{
                    self.transText = ""
                   return
                }
                self.transText = transText
              /*
                if let extext =  statusesArray["text"]{self.exText = extext as! String; print("\(extext)")}
                if let transtext =  statusesArray["trans"]{self.transText = transtext as! String; print("\(transtext)")}*/
            }
        }catch{
        }

    }
}
