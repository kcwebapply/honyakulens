//
//  CuLabel.swift
//  swlas
//
//  Created by WKC on 2015/08/13.
//  Copyright (c) 2015年 WKC. All rights reserved.
//

import Foundation

import UIKit

protocol CDLabel: class {
    func touchTrans(_ label:CuLabel)
    func getLabel(_ customLabel: CuLabel)
    func moveTrans(_ label:CuLabel,lpoint:CGPoint,ppoint:CGPoint)
}

class CuLabel: UILabel {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    weak var delegate: CDLabel?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.isUserInteractionEnabled = true
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        self.isUserInteractionEnabled = true
        //self.frame=frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textColor = UIColor.lightGray
       /* UIView.animateWithDuration(0.06,
            // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.transform = CGAffineTransformMakeScale(0.9, 0.9)
            })
            { (Bool) -> Void in
        }*/
        self.touchTrans(self)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textColor = UIColor.black
        
       let touch = touches.first as UITouch!
        //let point = touch.locationInView(self)
        self.touchUpInside()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch!
        let lpoint = touch?.location(in: self)
        let ppoint = touch?.previousLocation(in: self)
        self.moveTrans(lpoint!,ppoint: ppoint!)
        
           }
    
    /*override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.textColor = UIColor.blackColor()
    }*/
    
    // MARK: - delegate
    //weak var delegate: CustomLabelDelegate?
    
    func touchTrans(_ label:CuLabel){
        delegate?.touchTrans(self)
    }
    func moveTrans(_ lpoint:CGPoint,ppoint:CGPoint){
        delegate?.moveTrans(self,lpoint:lpoint,ppoint:ppoint)
    }
    func touchUpInside() {
        delegate?.getLabel(self)
    }
    

}
