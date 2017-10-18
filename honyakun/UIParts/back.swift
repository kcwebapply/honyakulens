
//
//  back.swift
//  swnabivar
//
//  Created by WKC on 2015/08/07.
//  Copyright (c) 2015年 wkc0520. All rights reserved.
//

import Foundation

import UIKit
/*
class back: SlideMenuController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "解析結果"
        self.view.backgroundColor=UIColor.white
        var color2 = UIColorFromRGB(0xFFFF66)
        /*self.navigationItem
        
        var tmpButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "onClickMyBarButton:")
        self.navigationItem.setRightBarButtonItem(tmpButton, animated: true)*/
        

        //self.navigationController?.popViewControllerAnimated = true
        //self.navigationController?.navigationBar.barTintColor = color2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.navigationController?.setNavigationBarHidden(false,animated:true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toThird") {
            // SecondViewControllerクラスをインスタンス化してsegue（画面遷移）で値を渡せるようにバンドルする
            //var secondView : ThirdSwift = segue.destinationViewController as! ThirdSwift
            // secondView（バンドルされた変数）に受け取り用の変数を引数とし_paramを渡す（_paramには渡したい値）
            // この時SecondViewControllerにて受け取る同型の変数を用意しておかないとエラーになる
            // secondView.text = "I love him love love"
            // secondView.cate = self.nowCategory
            
        }
    }



    
    

    
    
}*/


