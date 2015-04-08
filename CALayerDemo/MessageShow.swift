//
//  ErrorMessageShow.swift
//  SwiftWebApi
//
//  Created by 何文新 on 15/2/11.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit

enum MessageType {
    case Error
    case Show
    case Warn
}

class MessageShow {
    
    private let pAlertView = UIAlertView()
    private var queue:dispatch_queue_t?
    init(){
        queue = dispatch_get_main_queue()
    }
    
    var message :String = "" {
        willSet (newValue) {
            asyncShowMessage(MessageType.Show, withMessage: newValue)
        }
    }
    
    var errorMessage :String = "" {
        willSet (newValue) {
            asyncShowMessage(MessageType.Error, withMessage: newValue)
        }
    }
    
    private func asyncShowMessage(messageType:MessageType, withMessage message:String){
        dispatch_async(queue, {
            var title:String
            switch(messageType){
            case .Error:
                title = "错误"
                break
            case .Warn:
                title = "警告"
                break
            default:
                title = "提示"
                break
            }
            self.pAlertView.title = title
            self.pAlertView.message = message
            self.pAlertView.addButtonWithTitle("确定")
            self.pAlertView.show()
        })
    }
    
    class var ShareInstance: MessageShow {
        struct Static {
            static let instance : MessageShow = MessageShow()
        }
        return Static.instance
    }
    
    
}
