//
//  Extensions.swift
//  testplayer
//
//  Created by WKC on 2016/06/25.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit

/*extension UITableView{
    func registerCell<T:UITableViewCell>(type: T.Type){
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        
    }
}*/

extension NSObject {
    class var className: String {
        get {
            return NSStringFromClass(self).components(separatedBy: ".").last!
        }
    }
    
    var className: String {
        get {
            return type(of: self).className
        }
    }
}


extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

extension UIViewController{
    func instantiate<T: UIViewController>(_: T.Type) -> T where T: NSObject {
        let storyboard = UIStoryboard(name: T.className, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
    
    func instantiate<T: UIViewController>(_: T.Type, storyboard: String) -> T where T: NSObject {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: T.className) as! T
    }
    
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

extension AppDelegate{
    func instantiate<T: UIViewController>(_: T.Type) -> T where T: NSObject {
        let storyboard = UIStoryboard(name: T.className, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
    
    func instantiate<T: UIViewController>(_: T.Type, storyboard: String) -> T where T: NSObject {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: T.className) as! T
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

public extension Int {
    
    public static func random(min n: Int, max x: Int) -> Int {
        let min = n < 0 ? 0 : n
        let max = x + 1
        let v = UInt32(max < min ? 0 : max - min)
        let r = Int(arc4random_uniform(v))
        return min + r
    }
}

