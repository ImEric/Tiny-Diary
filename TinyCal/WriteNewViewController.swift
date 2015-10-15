//
//  WriteNewViewController.swift
//  TinyCal
//
//  Created by ERIC on 9/26/15.
//  Copyright © 2015 Eric Hu. All rights reserved.
//

import UIKit


class WriteNewViewController: UIViewController {
    
    let emotionButtonSelected = false
    var emotionString: String = ""
    var message: ChatBubbleMessage = ChatBubbleMessage(text: "", title: "", date: NSDate(), emotion: "")
    
 
    
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var yourWordsLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textFieldImageView: UIImageView!
    
    @IBOutlet weak var yourFeelingLabel: UILabel!
    
    @IBOutlet weak var happyButton: UIButton!
    
    
    @IBAction func happyButtonTouched(sender: AnyObject) {
        buttonSelected(happyButton)
        emotionString = "Happy"
    }
    
    @IBOutlet weak var sosoButton: UIButton!
    
    @IBAction func sosoButtonTouched(sender: AnyObject) {
        buttonSelected(sosoButton)
        emotionString = "Soso"
    }
    
    
    @IBOutlet weak var sadButton: UIButton!
    
    @IBAction func sadButtonTouched(sender: AnyObject) {
        buttonSelected(sadButton)
        emotionString = "Sad"
    }
    
    
    @IBOutlet weak var angryButton: UIButton!
    
    @IBAction func angryButtonTouched(sender: AnyObject) {
        buttonSelected(angryButton)
        emotionString = "Angry"
    }
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveButtonImageView: UIImageView!
    
    @IBOutlet weak var emotionButtonSelectedView: UIView!
    
    @IBOutlet weak var titleTextFieldImage: UIImageView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewEntry"{
            let title1:String
            if titleTextField.text == ""
            {
                title1 = "DEAR DIARY:"
            }else{
                title1 = titleTextField.text!
            }
            message = ChatBubbleMessage(text: textView.text!, title: title1, date: NSDate(), emotion: emotionString)
        }
    }
        
    @IBAction func saveButtonPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("remove", object: nil)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /**************** FORMAT SETTING ****************/
    //declare constants
    
  
    let navigationBarHeight: CGFloat = 10
    let yourWordsLabelHeight: CGFloat = 20
    let verticalSpacing:CGFloat = 20
    let horizontalSpacing:CGFloat = 20
    func updateTextfieldHeight(){
        
        
    }
    func updateUI(){
        
        let frameWidth = self.view.frame.width - 80
        let frameHeight = self.view.frame.height - 140
        
        //set titleLabel
        titleLabel.text = "TITLE:"
        titleLabel.font = UIFont(name: "FZMiaoWuS-GB", size: 20.0)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.frame = CGRect(x: horizontalSpacing , y: verticalSpacing + navigationBarHeight - 10, width: 80 , height: 20)
        titleLabel.sizeToFit()
        
        
        //set title textfield
        
        titleTextField.text = ""
        titleTextField.frame = CGRect(x: horizontalSpacing + 10 , y: titleLabel.frame.maxY + 10, width: frameWidth - 2 * horizontalSpacing - 20, height: 30)
        titleTextField.textAlignment = NSTextAlignment.Left
        titleTextField.textColor = UIColor.blackColor()
        titleTextField.font = UIFont(name: "FZMiaoWuS-GB", size:20.0)
        titleTextField.tintColor = UIColor.grayColor()
        titleTextField.borderStyle = UITextBorderStyle.None
        
        
        //set title text field image
        
        titleTextFieldImage.frame = CGRect(x: 0, y: 0 , width: frameWidth - 2 * horizontalSpacing - 5, height: titleTextField.frame.height + 16)
        titleTextFieldImage.center = titleTextField.center
        titleTextFieldImage.image = UIImage(named: "myBubble")?.stretchableImageWithLeftCapWidth(15, topCapHeight: 12)
        titleTextFieldImage.alpha = 0.5
        
        
        
        //set yourWordsLabel
        
        
        yourWordsLabel.text = "YOUR WORDS:"
        yourWordsLabel.font = UIFont(name: "FZMiaoWuS-GB", size: 20.0)
        yourWordsLabel.textAlignment = NSTextAlignment.Left
        yourWordsLabel.textColor = UIColor.blackColor()
        yourWordsLabel.frame = CGRect(x: horizontalSpacing  , y: verticalSpacing + navigationBarHeight + 65, width: 80 , height: 20)
        yourWordsLabel.sizeToFit()
        
        
        
        
        // set save button
        
        saveButton.setTitle("SAVE", forState: .Normal)
        saveButton.titleLabel!.font = UIFont(name: "FZMiaoWuS-GB", size: 20.0)
        saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton.frame = CGRect(x: (frameWidth - 60) / 2, y: frameHeight - 50, width: 60, height: 20)

        
        
        //set saveButtonImageView
        
        saveButtonImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 70)
        saveButtonImageView.center = saveButton.center
        saveButtonImageView.image = UIImage(named: "saveButtonImage")?.stretchableImageWithLeftCapWidth(0, topCapHeight: 0)
        saveButtonImageView.alpha = 0.8
        
        
        saveButton.backgroundImageForState(UIControlState.Normal)
        
        
        
        
        // set emotionImages
        //let bubbleBackgroundImageSize = CGSize(width: self.frame.width, height: max((cellData.messageLabelSize.height + imageHeightIncrease), 80))
        
        
        let imageWidth:CGFloat = (frameWidth - 2 * horizontalSpacing) / 4
        let emotionImagesYPos = saveButton.frame.maxY - 2 * verticalSpacing - imageWidth
        
        happyButton.frame = CGRect(x: horizontalSpacing, y: emotionImagesYPos, width: imageWidth, height: imageWidth)
        happyButton.setBackgroundImage(UIImage(named: "Happy"), forState: .Normal)
        
        
        angryButton.frame = CGRect(x: horizontalSpacing + imageWidth, y: emotionImagesYPos, width: imageWidth, height: imageWidth)
        angryButton.setBackgroundImage(UIImage(named: "Angry"), forState: .Normal)
        
        
        sadButton.frame = CGRect(x: horizontalSpacing + 2*imageWidth, y: emotionImagesYPos, width: imageWidth, height: imageWidth)
        sadButton.setBackgroundImage(UIImage(named: "Sad"), forState: .Normal)
        
        
        sosoButton.frame = CGRect(x: horizontalSpacing + 3*imageWidth, y: emotionImagesYPos, width: imageWidth, height: imageWidth)
        sosoButton.setBackgroundImage(UIImage(named: "Soso"), forState: .Normal)
        
        
        happyButton.setTitle("", forState: .Normal)
        angryButton.setTitle("", forState: .Normal)
        sadButton.setTitle("", forState: .Normal)
        sosoButton.setTitle("", forState: .Normal)
        
        emotionButtonSelectedView.frame = CGRect(x: 0, y: 0, width: 6, height: 6)
        emotionButtonSelectedView.layer.cornerRadius = 3
        emotionButtonSelectedView.backgroundColor = UIColor.grayColor()
        emotionButtonSelectedView.alpha = 0
        
        //set yourFeelingLabel
        let yourFeelingLabelYPos = emotionImagesYPos - 35
        yourFeelingLabel.text = "YOUR FEELING:"
        yourFeelingLabel.font = UIFont(name: "FZMiaoWuS-GB", size: 20.0)
        yourFeelingLabel.textAlignment = NSTextAlignment.Left
        yourFeelingLabel.textColor = UIColor.blackColor()
        yourFeelingLabel.frame = CGRect(x: horizontalSpacing, y: yourFeelingLabelYPos, width: 60 , height: 20)
        yourFeelingLabel.sizeToFit()
        
        
        
        //set textViewImage
        let textImageYPos = yourWordsLabel.frame.maxY + 10
        textFieldImageView.frame = CGRect(x: horizontalSpacing, y: textImageYPos , width: frameWidth - 2 * horizontalSpacing, height: yourFeelingLabel.frame.minY - textImageYPos - verticalSpacing + 10 )
        textFieldImageView.image = UIImage(named: "myBubble")?.stretchableImageWithLeftCapWidth(15, topCapHeight: 12)
        textFieldImageView.alpha = 0.5
        
        
        //set textView
        let textFieldYPos: CGFloat =  textImageYPos + 10
        textView.text = ""
        textView.frame = CGRect(x: horizontalSpacing , y: textFieldYPos, width: frameWidth - 2 * horizontalSpacing - 20, height: textFieldImageView.frame.height - 25)
        textView.textAlignment = NSTextAlignment.Left
        textView.textColor = UIColor.blackColor()
        textView.font = UIFont(name: "FZMiaoWuS-GB", size:20.0)
        textView.tintColor = UIColor.grayColor()
        //textView. = NSLineBreakMode.ByWordWrapping
        
   
        // set emotionImages
        //let bubbleBackgroundImageSize = CGSize(width: self.frame.width, height: max((cellData.messageLabelSize.height + imageHeightIncrease), 80))
        
        
        
    }
    

    
    func buttonSelected(button:UIButton) {
        if !emotionButtonSelected{
            emotionButtonSelectedView.alpha = 1
        }
        
        emotionButtonSelectedView.frame = CGRect(x: (button.center.x - 3), y: (button.frame.maxY), width: 6, height: 6)
    }
    
    @IBAction func saveButtonCliked(sender: AnyObject) {
        emotionButtonSelectedView.alpha = 0
    }
    
    //Set your words label
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

  
}
