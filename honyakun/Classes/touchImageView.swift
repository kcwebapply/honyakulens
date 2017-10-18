//
//  touchImageView.swift
//  honyakun
//
//  Created by WKC on 2016/10/07.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit


protocol touchImageViewProtocol{
    func textImageTouched()
}


class touchImageView:UIImageView{
    var delegates:touchImageViewProtocol? = nil
    
    override init(frame:CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("okokok呼ばれてる")
    }
    
    override func touchesEnded(_ touches: Set< UITouch>, with event: UIEvent?) {
        print("okdesu")
         delegates?.textImageTouched()
        
    }

}
