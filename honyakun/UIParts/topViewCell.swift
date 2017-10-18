//
//  topViewCell.swift
//  honyakun
//
//  Created by WKC on 2016/09/03.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit


class topViewCell:UITableViewCell{
    
    
    @IBOutlet weak var IconImageView: UIImageView!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var explainTextView: UITextView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setCell(_ topSet:topSetClass){
        self.titleLabelView.text = topSet.labelText
        self.explainTextView.text = topSet.explainText
        self.explainTextView.isUserInteractionEnabled = false
        self.titleLabelView.textAlignment = .center
        
        //リサイズ
       
        self.IconImageView.frame = CGRect(x: 0,y: 0,width: 60,height: 60)
        let size = CGSize(width: 60, height: 60)
        self.IconImageView.image = resizeImage(topSet.topImage!,size: size)
        
    }
    
    func resizeImage(_ image:UIImage,size:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size,false,0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
        
    }

}


