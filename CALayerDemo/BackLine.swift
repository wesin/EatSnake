//
//  BackLine.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/3/19.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import Foundation
import UIKit

class BackLine: CALayer {
    
    var marginX:CGFloat = 5
    var marginY:CGFloat = 5
    var lineYHeightScale:CGFloat = 1 / 10
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        let line = UIBezierPath()
        let beginPoint = CGPoint(x: bounds.origin.x + marginX, y: bounds.origin.y + bounds.height - marginY - lineYHeightScale * bounds.height)
        line.moveToPoint(beginPoint)
        line.addLineToPoint(CGPoint(x: bounds.origin.x + marginX, y: bounds.origin.y + bounds.height - marginY))
        line.addLineToPoint(CGPoint(x: bounds.origin.x + bounds.width - marginX, y: bounds.origin.y + bounds.height - marginY))
        line.addLineToPoint(CGPoint(x: bounds.origin.x + bounds.width - marginX, y: bounds.origin.y + bounds.height - marginY - lineYHeightScale * bounds.height))
        
        let shadowColor = UIColor.blackColor()
        CGContextSetStrokeColorWithColor(ctx, shadowColor.CGColor)
        CGContextAddPath(ctx, line.CGPath)
        CGContextStrokePath(ctx)
    }
    

    
}