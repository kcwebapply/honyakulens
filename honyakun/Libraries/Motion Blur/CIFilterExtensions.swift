//
//  CIFilterExtensions.swift
//  MotionBlur
//
//  Created by Guanshan Liu on 18/10/2014.
//  Copyright (c) 2014 guanshanliu. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias Color = UIColor
    #elseif os(OSX)
    import Cocoa
    typealias Color = NSColor
#endif

import CoreImage

typealias Filter = (CIImage) -> CIImage

typealias Parameters = Dictionary<String, AnyObject>

extension CIFilter {
    convenience init(name: String, parameters: Parameters) {
        self.init(name: name)!
        setDefaults()
        for (key, value) in parameters {
            setValue(value, forKey: key)
        }
    }

    fileprivate var outputImage: CIImage {
        return self.value(forKey: kCIOutputImageKey) as! CIImage
    }
}

infix operator >>> { associativity left }

func >>> (filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}
