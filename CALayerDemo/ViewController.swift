//
//  ViewController.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/3/18.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LayerViewDataSource {

    @IBOutlet weak var smileView: LayerView! {
        didSet {
            smileView.dataSource = self
            smileView.addGestureRecognizer(UIPinchGestureRecognizer(target: smileView, action: "scaleChange:"))
        }
    }
    
    var happiness:Int = 50 {
        didSet {
            happiness = max(min(happiness, 100), 0)
            smileView.setNeedsDisplay()
        }
    }
    
    let changePerPoint:CGFloat = 4
    

    @IBOutlet var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        layer.shadowRadius = 10
        
        
    }
    
    func changeHappiness() {
        if min(happiness, 100) == 100 {
            happlyPlus = false
        } else if max(happiness, 0) == 0 {
            happlyPlus = true
        }
        happiness += happlyPlus ? 10 : -10
    }
    
    func smileFraction(sender: LayerView) -> Int? {
        println(happiness)
        return happiness
    }
    
    var happlyPlus = true
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        let timer = NSTimer(timeInterval: 1, target: self, selector: Selector("changeHappiness"), userInfo: nil, repeats: true)
//        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func smileChange(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let changeValue = sender.translationInView(smileView)
            happiness += Int(changeValue.y / changePerPoint)
            sender.setTranslation(CGPointZero, inView: smileView)
        default:break
        }
    }

}

