//
//  textCell.swift
//  honyakun
//
//  Created by WKC on 2016/09/18.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation


class textCell:UITableViewCell{
    
    @IBOutlet weak var textContentView: UITextView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setCell(_ textset:textSet){
        self.titleView.text = textset.titleText
        self.titleView.textAlignment = .left
        
        //リサイズ
        
        self.titleImage.frame = CGRect(x: 0,y: 0,width: 60,height: 60)
        let size = CGSize(width: 60, height: 60)
        self.titleImage.image = resizeImage(textset.titleImage,size: size)
        
        let blueView = UIButton(frame:CGRect(x: self.frame.size.width-20,y: 10,width: 10,height: 10))
        let size2 = CGSize(width: 10, height: 10)
        blueView.setImage(resizeImage(UIImage(named:"parrow.png")!, size: size2), for: UIControlState())
        self.addSubview(blueView)
        
        //テキスト判断
        let devName = UIDevice.current.modelName
        switch devName{
        case "iPhone6":
            self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(12))
            break
        case "iPhone 6 Plus":
            self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(12))
            break
        case "iPhone 5":
            self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(10))
            break
        case "iPhone 5S":
            self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(10))
            break
        case "iPhone 5C":
            self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(10))
            break
        default:
            self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(12))
        }
        self.textContentView.text = textset.contentText
        self.textContentView.isUserInteractionEnabled = false
        self.textContentView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)


        
    }
    
    func resizeImage(_ image:UIImage,size:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size,false,0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
        
    }

    
}
