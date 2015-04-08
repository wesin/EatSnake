//
//  SnakeViewController.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/4.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController, SnakeDelegate,UIAlertViewDelegate {
    
    @IBOutlet var highestScoreTxt: UILabel!
    @IBOutlet var scoreTxt: UILabel!
    @IBOutlet var game: SnakeView!
    @IBOutlet var sadTxt: UILabel!
    var alertView = UIAlertView()
    var highestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreTxt.text = "0"
        game.delegate = self
        highestScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore") ?? 0
        highestScoreTxt.text = "\(highestScore)"
        
        alertView.addButtonWithTitle("OK")
        alertView.delegate = self
    }
    
    @IBAction func startGame(sender: AnyObject) {
        game.startGame()
    }
    
    @IBAction func turnTranslation(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(game)
        game.transDirection(location)
    }
    
    func finishGame() {
        if highestScore < (scoreTxt.text!.toInt()? ?? 0) {
            alertView.title = "恭喜"
            alertView.message = "You are the best guy：" + scoreTxt.text!
            alertView.show()
        } else {
            alertView.title = "失败"
            alertView.message = "you are dead"
            alertView.show()
        }
    }
    
    func refreshScore() {
        scoreTxt.text = "\(game.score)"
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(scoreTxt.text!.toInt()!, forKey: "highscore")
        game.resetGame()
    }
    
}
