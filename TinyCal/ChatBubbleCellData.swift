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
    let fontName = NSLocalizedString("FONT", comment: "font name")
    
    // Use Customized font later
    
    let dateFont: UIFont
    let dateLabelHeight: CGFloat
    
    let monthFont: UIFont
    let monthLabelHeight: CGFloat
    
    let thFont: UIFont
    let thLabelHeight: CGFloat
    
    let textFont: UIFont

    /*
    let messageFont: UIFont
    let messageLabelSize: CGSize
    */
    
    let titleFont: UIFont
   //let titleLabelSize: CGSize
    
    let cellHeight: CGFloat
    
    private let spacing:CGFloat = 50
    
    
    let messageWidthConstrain: CGFloat = 90

    
    init(message: ChatBubbleMessage, frameWidth: CGFloat)
    {
        self.message = message
        
       
        self.dateFont = UIFont(name: "Helvetica", size: 20.0)!
        self.dateLabelHeight = 22
        
        self.monthFont = UIFont(name: "Helvetica", size: 9.0)!
        self.monthLabelHeight = 20
       
        self.thFont = UIFont(name: "Helvetica", size: 10.0)!
        self.thLabelHeight = 20
        
        self.textFont = UIFont(name: fontName, size: 17.0)!
        
        self.titleFont = UIFont(name: fontName, size: 20.0)!
        
        self.cellHeight = 100
      
        /*
       let titleLabel = UILabel(frame: CGRectMake(90, 0, frameWidth - messageWidthConstrain, CGFloat.max))
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.font = titleFont
        titleLabel.text = message.title
        titleLabel.sizeToFit()
        self.titleLabelSize = titleLabel.frame.size
        
       */
       
        //max((self.titleLabelSize.height + spacing), 100)


    }
}