//
//  UIViewMotionBlurExtension.swift
//  MotionBlur
//
//  Created by Guanshan Liu on 18/10/2014.
//  Copyright (c) 2014 guanshanliu. All rights reserved.
//

import UIKit
import CoreImage

private var kUIViewBlurLayer: UInt8 = 0
private var kUIViewDisplayLink: UInt8 = 0
private var kUIViewLastPosition: UInt8 = 0

func CGImageCreateByApplyingMotionBlur(_ snapshot: UIImage, angle: Float) -> CGImage {
    let context = CIContext(options: [ kCIContextPriorityRequestLow: NSNumber(value: true as Bool) ])
    let inputImage = CIImage(cgImage: snapshot.cgImage!)
    let outputImage = motionBlur(angle)(inputImage)
    let blurredImageRef = context.createCGImage(outputImage, from: outputImage.extent)
    return blurredImageRef!
}

extension UIView {

    // MARK: Properties
    var blurLayer: CALayer? {
        get {
            return objc_getAssociatedObject(self, &kUIViewBlurLayer) as? CALayer
        }
        set {
            objc_setAssociatedObject(self, &kUIViewBlurLayer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var displayLink: CADisplayLink? {
        get {
            return objc_getAssociatedObject(self, &kUIViewDisplayLink) as? CADisplayLink
        }
        set {
            objc_setAssociatedObject(self, &kUIViewDisplayLink, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    var lastPosition: NSValue? {
        get {
            return objc_getAssociatedObject(self, &kUIViewLastPosition) as? NSValue
        }
        set {
            objc_setAssociatedObject(self, &kUIViewLastPosition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: Public methods
    func enableMotionBlur(_ angle: Float, completion: ((Void) -> Void)?) {
        // snapshot has to be performed on the main thread
        // TODO: WHY??
        let snapshot = self.layerSnapshot()

        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { () -> Void in
            let blurredImageRef: CGImage = CGImageCreateByApplyingMotionBlur(snapshot, angle: angle)

            DispatchQueue.main.async(execute: { () -> Void in
                self.disableMotionBlur()

                let blurLayer = CALayer()
                blurLayer.contents = blurredImageRef
                blurLayer.opacity = 0

                let scale = UIScreen.main.scale
                let difference = CGSize(width: CGFloat(blurredImageRef.width) / scale - self.frame.width, height: CGFloat(blurredImageRef.height) / scale - self.frame.height)
                blurLayer.frame = self.bounds.insetBy(dx: -difference.width / 2, dy: -difference.height / 2)

                blurLayer.actions = [ "opacity": NSNull() ]
                self.layer.addSublayer(blurLayer)
                self.blurLayer = blurLayer

                let displayLink = CADisplayLink(target: self, selector: #selector(UIView.tick(_:)))
                displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
                self.displayLink = displayLink

                if let complete = completion {
                    complete()
                }
            })
        }
    }

    func disableMotionBlur() {
        displayLink?.invalidate()
        blurLayer?.removeFromSuperlayer()
    }

    // MARK: Internal methods
    func layerSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.fill(bounds)

        // good explanation of differences between drawViewHierarchyInRect:afterScreenUpdates: and renderInContext: https://github.com/radi/LiveFrost/issues/10#issuecomment-28959525
        layer.render(in: context!)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }

    func tick(_ displayLink: CADisplayLink) {
        let realPosition = self.layer.presentation()!.position

        if let lastPostionValue = lastPosition {
            // TODO: there's an assumption that the animation has constant FPS. The following code should also use a timestamp of the previous frame.

            let lastPositionPoint = lastPostionValue.cgPointValue
            let dx = Float(abs(realPosition.x - lastPositionPoint.x))
            let dy = Float(abs(realPosition.y - lastPositionPoint.y))
            let delta = sqrtf(powf(dx, 2) + powf(dy, 2))

            // A rough approximation of a good looking blur. The larger the speed, the larger opacity of the blur layer.
            let unboundedOpacity = log2f(delta) / 5
            let opacity = fmaxf(fminf(unboundedOpacity, 1), 0)
            blurLayer?.opacity = opacity
        }

        lastPosition = NSValue(cgPoint: realPosition)
    }

}
