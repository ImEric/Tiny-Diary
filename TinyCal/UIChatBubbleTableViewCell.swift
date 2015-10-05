//
//  UIChatBubbleTableViewCell.swift
//  UIChatBubble
//
//  Created by Yang Zhen on 15/7/4.
//  Copyright (c) 2015 Yang Zhen. All rights reserved.
//

import UIKit

class UIChatBubbleTableViewCell: UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!

    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var thLabel: UILabel!
    @IBOutlet weak var emotionImageView: UIImageView!
    
    
    let cellOffSet: CGFloat = 10
    let imageWidthIncrease: CGFloat = 30
    let imageHeightIncrease: CGFloat = 40
    let imageMargin: CGFloat = 10
    let messageXOffset: CGFloat = 18
    let messageYOffset: CGFloat = 15
    
    
    
    var data: ChatBubbleCellData?
    {
        didSet
        {
            updateCellUI()
        }
    }

    func updateCellUI()
    {
        if let cellData = data
        {
            //set dateLabel's format

            dateLabel.frame = CGRect(x: 10, y: 70, width: 80, height: cellData.dateLabelHeight)
            dateLabel.textAlignment = NSTextAlignment.Left
            dateLabel.textColor = UIColor.grayColor()
            dateLabel.font = cellData.dateFont

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd"
            dateLabel.text = dateFormatter.stringFromDate(cellData.message.date)
            
            //set monthLabel Format
            let monthFormatter = NSDateFormatter()
            monthFormatter.dateFormat = "MM"
            let monthInDigits:String! = monthFormatter.stringFromDate(cellData.message.date)
            var monthInString:String!
            switch monthInDigits
            {
            case "01":
                monthInString = "January"
            case "02":
                monthInString = "Feburary"
            case "03":
                monthInString = "March"
            case "04":
                monthInString = "April"
            case "05":
                monthInString = "May"
            case "06":
                monthInString = "June"
            case "07":
                monthInString = "July"
            case "08":
                monthInString = "August"
            case "09":
                monthInString = "September"
            case "10":
                monthInString = "October"
            case "11":
                monthInString = "November"
            case "12":
                monthInString = "December"
            default:
                break
            }
            
            monthLabel.text = monthInString
            
            monthLabel.frame = CGRect(x: 10, y:  86, width: 80, height: cellData.monthLabelHeight)
            monthLabel.textAlignment = NSTextAlignment.Left
            monthLabel.textColor = UIColor.grayColor()
            monthLabel.font = cellData.monthFont
            
            //set "th" label
        
            thLabel.frame = CGRect(x: 33, y: 70, width: 20, height: cellData.thLabelHeight)
            thLabel.textAlignment = NSTextAlignment.Left
            thLabel.textColor = UIColor.grayColor()
            thLabel.font = cellData.thFont
            let dateText = dateLabel.text!
            switch dateText{
                case "01":
                    thLabel.text = "st"
                case "02":
                    thLabel.text = "nd"
                case "03":
                    thLabel.text = "rd"
            default:
                thLabel.text = "th"
            }
          
            
            //set messageLabel's Format
            
            messageLabel.text = cellData.message.text
            messageLabel.font = cellData.messageFont
            messageLabel.textAlignment = NSTextAlignment.Left
        
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            messageLabel.textColor = UIColor.blackColor()
            
     
           // let messageLabelSize = CGSize(width: self.frame.width - 90 - 20, height: CGFloat.max)
             messageLabel.frame = CGRect(origin: CGPoint(x: 80, y: cellOffSet + imageMargin + 20), size:cellData.messageLabelSize)
           
            let bubbleBackgroundImageSize = CGSize(width: self.frame.width - 60 , height: max((cellData.messageLabelSize.height + imageHeightIncrease), 90))
            
            bubbleImageView.frame = CGRect(origin: CGPoint(x: 60, y: 20), size: bubbleBackgroundImageSize)
            
            
            bubbleImageView.image = UIImage(named: "messageBubble")?.stretchableImageWithLeftCapWidth(15, topCapHeight: 12)
            
            
           
            
            //switch on emotionTypes
            //to be done
            
            let emotionImageSize = CGSize(width: 60, height: 60)
            emotionImageView.frame = CGRect(origin: CGPoint(x: 0, y:20) , size: emotionImageSize)
            emotionImageView.alpha = 1
            
            
            switch cellData.message.emotion
            {
            case "Happy":
                emotionImageView.image = UIImage(named: "Happy")
            case "Angry":
                emotionImageView.image = UIImage(named: "Angry")
            case "Sad":
                emotionImageView.image = UIImage(named: "Sad")
            case "Soso":
                emotionImageView.image = UIImage(named: "Soso")
            default:
                    break
                
            }
            
            
            // set the cell unselectable
            
            
            self.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            }
        }
    }

