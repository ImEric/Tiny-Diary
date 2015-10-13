//
//  ChatBubbleMessage.swift
//  UIChatBubble
//
//  Created by Yang Zhen on 15/7/4.
//  Copyright (c) 2015 Yang Zhen. All rights reserved.
//

import Foundation



class ChatBubbleMessage
{
    let date: NSDate
    let text: String
    let title: String
    let emotion: String
    
    init(text: String, title: String, date: NSDate, emotion: String)
    {
        self.date = date
        self.title = title.uppercaseString
        self.text = text
        self.emotion = emotion
    }
}
