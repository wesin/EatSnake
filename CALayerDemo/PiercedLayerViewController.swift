//
//  PiercedLayerViewController.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/3.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class PiercedLayerViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var layer = CALayer()
        layer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.width, height: imgView.frame.origin.y))
        layer.backgroundColor = UIColor.blackColor().CGColor
        layer.opacity = 0.8
        self.view.layer.addSublayer(layer)
        var layer2 = CALayer()
        layer2.frame = CGRect(origin: CGPoint(x: 0, y: imgView.frame.origin.y), size: CGSize(width: imgView.frame.origin.x, height: imgView.frame.size.height))
        layer2.backgroundColor = UIColor.blackColor().CGColor
        layer2.opacity = 0.8
        self.view.layer.addSublayer(layer2)
        var layer3 = CALayer()
        layer3.frame = CGRect(origin: CGPoint(x: imgView.frame.origin.x + imgView.frame.size.width, y: imgView.frame.origin.y), size: CGSize(width: layer2.frame.size.width, height: imgView.frame.size.height))
        layer3.backgroundColor = UIColor.blackColor().CGColor
        layer3.opacity = 0.8
        self.view.layer.addSublayer(layer3)
        var layer4 = CALayer()
        layer4.frame = CGRect(origin: CGPoint(x: 0, y: imgView.frame.origin.y + imgView.frame.height), size: CGSize(width: self.view.bounds.width, height: imgView.frame.origin.y))
        layer4.backgroundColor = UIColor.blackColor().CGColor
        layer4.opacity = 0.8
        self.view.layer.addSublayer(layer4)
    }
    
}
