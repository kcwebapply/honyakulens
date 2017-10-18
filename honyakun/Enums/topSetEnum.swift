//
//  topSetEnum.swift
//  honyakun
//
//  Created by WKC on 2016/09/03.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit

enum topSetEnum{
    case camera
    case textRireki
    case wordDic
    case dicSearch
    case configure
    
    var image:UIImage{
        switch self{
            case .camera:return UIImage(named:"camera.png")!
            case .wordDic:return UIImage(named:"wordDic.png")!
            case .dicSearch:return UIImage(named:"search.png")!
            case .textRireki:return UIImage(named:"Text.png")!
            case .configure:return UIImage(named:"Configure.png")!
        }
        
    }
    
    var labelText:String{
        switch self{
            case .camera:return "文書撮影"
            case .wordDic:return "単語りれき"
            case .dicSearch:return "履歴機能"
            case .textRireki:return "辞書検索"
            case .configure:return "設定"
        }
    }
    
    var explainText:String{
        switch self{
            case .camera:return "文章を撮影し、様々な機能を提供します。"
            case .wordDic:return "今までにチェックした単語一覧です。"
            case .dicSearch:return "撮影した文書の履歴です。"
            case .textRireki:return "辞書の検索機能です。"
            case .configure:return "様々な設定をします。"
        }
    }

    
}
