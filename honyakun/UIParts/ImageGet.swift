//
//  ImageGet.swift
//  swnabivar
//
//  Created by WKC on 2015/09/21.
//  Copyright (c) 2015年 wkc0520. All rights reserved.
//

import Foundation

import UIKit


class ImageGet: UIViewController{
    
    var im:UIImage!
    
    var checker:Int!
    var vw:UIView!
    var vwc:UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame:CGRect(x: 0,y: 0,width: 270,height: self.view.frame.size.height))
        imageView.image = im
        self.view.addSubview(imageView)
        if self.checker==1{
            vwc=UIView()
            vwc.frame = vw.bounds
            vwc.layer.position=vw.layer.position
            //vwc.frame.size.height+=60
            vwc.frame.origin.y -= 25

            vwc.backgroundColor=UIColorFromRGB(0xFFFFFF)
            vwc.layer.borderWidth=2.0
            vwc.layer.borderColor=UIColor.red.cgColor
           // self.vwc.layer.position = CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2-45)
            for subview in self.vwc.subviews {
                subview.removeFromSuperview()
            }
            self.view.addSubview(vwc)
            
        }

        
    }
    
    deinit{
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }

    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    

    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
        return orientation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.2)
        )
    }

    
    
    
}


