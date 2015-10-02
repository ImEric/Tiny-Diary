//
//  ChatBubbleCellData.swift
//  UIChatBubble
//
//  Created by Yang Zhen on 15/7/4.
//  Copyright (c) 2015 Yang Zhen. All rights reserved.
//

import Foundation
import UIKit


class ChatBubbleCellData
{
    let message: ChatBubbleMessage
    
    // Use Customized font later
    
    let dateFont: UIFont
    let dateLabelHeight: CGFloat
    
    let monthFont: UIFont
    let monthLabelHeight: CGFloat
    
    let thFont: UIFont
    let thLabelHeight: CGFloat

    let messageFont: UIFont
    let messageLabelSize: CGSize
    
        
    private let spacing:CGFloat = 50
    let cellHeight: CGFloat
    
    let messageWidthConstrain: CGFloat = 20

    
    init(message: ChatBubbleMessage, frameWidth: CGFloat)
    {
        self.message = message
        
       
        self.dateFont = UIFont(name: "Helvetica", size: 20.0)!
        self.dateLabelHeight = 22
        
        self.monthFont = UIFont(name: "Helvetica", size: 9.0)!
        self.monthLabelHeight = 20
       
        self.thFont = UIFont(name: "Helvetica", size: 10.0)!
        self.thLabelHeight = 20
        
        self.messageFont = UIFont(name: "FZMiaoWuS-GB", size: 20.0)!
        let messageLabel = UILabel(frame: CGRectMake(90, 0, frameWidth - messageWidthConstrain - 70, CGFloat.max))
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageLabel.font = messageFont
        messageLabel.text = message.text
        messageLabel.sizeToFit()
        
        self.messageLabelSize = messageLabel.frame.size
        self.cellHeight = max((self.messageLabelSize.height + spacing), 100)
    }
    

}