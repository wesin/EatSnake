//
//  SnakeView.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/3.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

enum RectType {
    case Normal
    case Snake
    case Food
}

enum HeadDirection {
    case East
    case South
    case West
    case North
}

protocol SnakeDelegate {
    func refreshScore()
    func finishGame()
}

@IBDesignable
class SnakeView: UIView {
    
    @IBInspectable
    var horiNum:Int = 20
    @IBInspectable
    var veriNum:Int = 20
    
    
    var marginHori:CGFloat = 20
    var marginVeri:CGFloat = 20
    
    var borderWidth:CGFloat = 1
    var borderColor:UIColor = UIColor.whiteColor()
    var cornerRadius:CGFloat = 2
    
    var normalRectColor:UIColor = UIColor.grayColor()
    var snakeRectColor:UIColor = UIColor.blackColor()
    var foodRectColor:UIColor = UIColor.greenColor()
    
    var currentSpeed:NSTimeInterval = 1     //当前移动速度
    var stepSpeed:NSTimeInterval = -0.01    //每次递增速度
    
    var snakeDirection = HeadDirection.East //当前移动方向
    
    var score = 0                           //积分
    
    private var snakeHead = 0
    
    private var headPoint:CGPoint {
        get {
            return CGPoint(x: marginHori + CGFloat((snakeHead % horiNum)) * rectSize.width, y: marginVeri + CGFloat(Int(snakeHead / horiNum)) * rectSize.height)
        }
    }
    
    var delegate: SnakeDelegate?
    
    private var rectArray = [CALayer]()
    private var snakeArray = [Int]()
    private var nullArray = [Int]()
    private var rectSize = CGSize()
    
    private var timer:NSTimer?
    
    private var food = 0
    
    
    override func layoutSubviews() {
        if rectArray.count == 0 {
            resetNullArray()
            calRectSize()
            drawAllRect()
            drawSnake()
            drawRadomFood()
        }
    }
    
    
    //MARK:Public Method--
    func startGame() {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(currentSpeed, target: self, selector: Selector("moveSnake"), userInfo: nil, repeats: true)
            return
        }
        timer?.fireDate = NSDate()
    }
    
    func finishGame() {
        timer?.fireDate = NSDate.distantFuture() as NSDate
        delegate?.finishGame()
    }
    
    func resetGame() {
        score = 0
        currentSpeed = 1
        resetNullArray()
        resetSnake()
        resetFood()
        snakeDirection = HeadDirection.East
    }
    
    func transDirection(location:CGPoint) {
        let directType = snakeDirection
        
        switch directType {
        case .East, .West:
            if headPoint.y > location.y {
                snakeDirection = .North
            } else if headPoint.y < location.y {
                snakeDirection = .South
            }
        default :
            if headPoint.x > location.x {
                snakeDirection = .West
            } else if headPoint.x < location.x {
                snakeDirection = .East
            }
        }
    }
    
    //MARK:Private Method--
    private func resetNullArray() {
        for i in 0...horiNum * veriNum - 1 {
            nullArray.append(i)
        }
    }
    
    private func resetFood() {
        rectArray[food].backgroundColor = normalRectColor.CGColor
        drawRadomFood()
    }
    
    private func resetSnake(){
        for index in snakeArray {
            rectArray[index].backgroundColor = normalRectColor.CGColor
        }
        drawSnake()
    }
    
    func moveSnake() {
        if checkDirectionDead() {
            finishGame()
            return
        }
        snakeHead = getSnakeHead()
        if snakeArray.find({$0 == self.snakeHead}) >= 0 {
            finishGame()
            return
        }
        //收尾
        if food != snakeHead {
            let value = snakeArray.removeAtIndex(0)
            nullArray.append(value)
            nullArray.removeAtIndex(nullArray.find({$0 == self.snakeHead}))
            rectArray[value].backgroundColor = normalRectColor.CGColor
        } else {
            drawRadomFood()
            score += 1
            delegate?.refreshScore()
            timer?.invalidate()
            currentSpeed += stepSpeed
            timer = NSTimer.scheduledTimerWithTimeInterval(currentSpeed, target: self, selector: Selector("moveSnake"), userInfo: nil, repeats: true)
        }
        //伸头
        snakeArray.append(snakeHead)
        rectArray[snakeHead].backgroundColor = snakeRectColor.CGColor
        
        
    }
    
    private func getSnakeHead() -> Int {
        let headValue = snakeHead
        switch(snakeDirection) {
        case .East:
            return headValue + 1
        case .North:
            return headValue - horiNum
        case .South:
            return headValue + horiNum
        case .West:
            return headValue - 1
        }
        
    }
    
    private func checkDirectionDead() -> Bool  {
        
        switch snakeDirection {
        case .East:
            return snakeArray.last! % horiNum == horiNum - 1
        case .South:
            return Int(snakeArray.last! / horiNum) == veriNum - 1
        case .West:
            return snakeArray.last! % horiNum == 0
        case .North:
            return snakeArray.last! / horiNum < 1
        }
    }
    
    
    //MARK:DrawUI--
    private func calRectSize() {
        let width = CGFloat(self.bounds.width - 2 * marginHori) / CGFloat(horiNum)
        let height = CGFloat(self.bounds.height - 2 * marginVeri) / CGFloat(veriNum)
        rectSize = CGSize(width: width, height: height)
    }
    
    private func createRectLayer() -> CALayer {
        var rectLayer = CALayer()
        rectLayer.backgroundColor = normalRectColor.CGColor
        rectLayer.borderWidth = borderWidth
        rectLayer.borderColor = borderColor.CGColor
        rectLayer.cornerRadius = cornerRadius
        return rectLayer
    }
    
    private func drawRadomFood() {
        food = nullArray[Int(arc4random_uniform(UInt32(nullArray.count - 1)))]
        rectArray[food].backgroundColor = foodRectColor.CGColor
        nullArray.removeAtIndex(nullArray.find({$0 == self.food}))
    }
    
    private func drawSnake() {
        let averNum = horiNum * veriNum / 2 + Int(horiNum / 2)
        snakeArray = [ averNum - 1, averNum, averNum + 1]
        snakeHead = averNum + 1
        nullArray.removeAtIndex(nullArray.find({$0 == averNum - 1}))
        nullArray.removeAtIndex(nullArray.find({$0 == averNum}))
        nullArray.removeAtIndex(nullArray.find({$0 == averNum + 1}))
        for index in snakeArray {
            rectArray[index].backgroundColor = snakeRectColor.CGColor
        }
    }
    
    private func drawAllRect() {
        for y in 0...Int(veriNum) - 1{
            for x in 0...Int(horiNum) - 1 {
                var rect = CGRect(origin: CGPoint(x: marginHori + CGFloat(x) * rectSize.width, y: marginVeri + CGFloat(y) * rectSize.height), size: CGSize(width: rectSize.width, height: rectSize.height))
                var rectLayer = createRectLayer()
                rectLayer.frame = rect
                self.layer.addSublayer(rectLayer)
                rectArray.append(rectLayer)
            }
        }
    }
}
