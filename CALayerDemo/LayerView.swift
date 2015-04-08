//
//  LayerView.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/3/18.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

protocol LayerViewDataSource: class {
    func smileFraction(sender:LayerView) -> Int?
}

@IBDesignable
class LayerView: UIView {
    
    @IBInspectable
    var marginWidth:CGFloat = 20
    
    @IBInspectable
    var lineWidth:CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
   weak var dataSource : LayerViewDataSource?

    
//    @IBInspectable
//    var fractionOfSmile:CGFloat = 0.85 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    @IBInspectable
    var faceColor:UIColor = UIColor.blueColor()
    
    
    
    var faceCenter:CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius:CGFloat {
        return min(bounds.width, bounds.height) / 2 * faceScale
    }
    
    var faceScale:CGFloat = 0.90 {
        didSet {
          setNeedsDisplay()
        }
    }
    

    
    private enum Eye {
        case Left, Right
    }
    
    private struct Scaling{
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRadio:CGFloat = 1
        static let FaceRadiusToMouthHeightRadio:CGFloat = 3
        static let FaceRadiusToMouthOffsetRadio:CGFloat = 3
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalWidth = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        eyeCenter.x += whichEye == Eye.Left ? -eyeHorizontalWidth / 2 : eyeHorizontalWidth / 2
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionSmile:Int) -> UIBezierPath {
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRadio
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRadio
        let mouthOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRadio
        
        let smileHeight = CGFloat(Double(max(min(fractionSmile, 100), 0) - 50) / 50) * mouthHeight
        
        let startPoint = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthOffset)
        let endPoint = CGPoint(x: faceCenter.x + mouthWidth / 2, y: startPoint.y)
        let controlPointO = CGPoint(x: faceCenter.x - mouthWidth / 3, y: startPoint.y + smileHeight)
        let controlPointT = CGPoint(x: faceCenter.x + mouthWidth / 3, y: controlPointO.y)
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: controlPointO, controlPoint2: controlPointT)
        return path
    }
    
    private func bezierPathForFace() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    
    
    func scaleChange(sender: UIPinchGestureRecognizer) {
        if sender.state == .Changed {
            faceScale *= sender.scale
            sender.scale = 1
        }
    }


    override func drawRect(rect: CGRect) {
        let fractionOfSmile = dataSource?.smileFraction(self) ?? 50
        faceColor.set()
        bezierPathForFace().stroke()
        bezierPathForEye(Eye.Left).stroke()
        bezierPathForEye(Eye.Right).stroke()
        bezierPathForSmile(fractionOfSmile).stroke()
    }
}
