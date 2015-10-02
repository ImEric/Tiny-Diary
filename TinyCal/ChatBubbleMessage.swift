//
//  ChatBubbleMessage.swift
//  UIChatBubble
//
//  Created by Yang Zhen on 15/7/4.
//  Copyright (c) 2015 Yang Zhen. All rights reserved.
//

import Foundation


enum ChatBubbleEmotionType
{
    case Angry
    case Happy
    case Sad
    case Soso
}

class ChatBubbleMessage
{
    let date: NSDate
    let text: String
    let type: ChatBubbleEmotionType
    
    init(text: String, date: NSDate, type: ChatBubbleEmotionType)
    {
        self.date = date
        self.text = text
        self.type = type
    }
}