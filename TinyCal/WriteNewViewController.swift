//
//  WriteNewViewController.swift
//  TinyCal
//
//  Created by ERIC on 9/26/15.
//  Copyright © 2015 Eric Hu. All rights reserved.
//

import UIKit


class WriteNewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    let emotionButtonSelected = false
    var emotionString: String = "Soso"//default
    var message: ChatBubbleMessage = ChatBubbleMessage(text: "", title: "", date: NSDate(), emotion: "")
    let emotionButton = UIButton()
    let fontName = NSLocalizedString("FONT", comment: "font name")
 
    

   
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var yourWordsLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
 
    
    @IBOutlet weak var yourFeelingLabel: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveButtonImageView: UIImageView!
    
    
    @IBOutlet weak var titleTextFieldImage: UIImageView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        textView.delegate = self
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
                title1 = NSLocalizedString("WRITE_NEW_TITLE_IF_EMPTY", comment: "DEAR DIARY")
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
    
    
  
    let TOP_OFFSET: CGFloat = 10
    let VERTICAL_SPACING:CGFloat = 20
    let HORIZONTAL_SPACING:CGFloat = 20
  
    
    func updateUI(){
        
        
        //declare constants and variables
        let frameWidth = self.view.frame.width - 60
        let frameHeight = self.view.frame.height - 140
        let dateLabel = UILabel()
        
        
        //set emotion button
       
        emotionButton.setBackgroundImage(UIImage(named: "addEmotionImage"), forState: .Normal)
        emotionButton.frame = CGRect(x: HORIZONTAL_SPACING , y: VERTICAL_SPACING
            , width: 60 , height: 60)
        self.view.addSubview(emotionButton)
        emotionButton.addTarget(self, action: "emotionButtonTapped:", forControlEvents: .TouchUpInside)
        
  
        
        //set title textfield
        titleTextField.placeholder = NSLocalizedString("WRITE_NEW_TITLE_TEXTFIELD_PLACEHOLDER", comment: "TITLE")
        titleTextField.textColor = UIColor.blackColor()
        titleTextField.frame = CGRect(x: HORIZONTAL_SPACING + 70 , y: VERTICAL_SPACING + 3, width: frameWidth - 2 * HORIZONTAL_SPACING - 80, height: 30)
        titleTextField.textAlignment = NSTextAlignment.Left
        titleTextField.font = UIFont(name: fontName, size:18.0)
        titleTextField.tintColor = UIColor.grayColor()
        titleTextField.borderStyle = UITextBorderStyle.None

        
        //set date label
        dateLabel.text = getDate()
        dateLabel.frame = CGRect(x: HORIZONTAL_SPACING + 70 , y: VERTICAL_SPACING + TOP_OFFSET + 16, width: frameWidth - 2 * HORIZONTAL_SPACING - 20, height: 30)
        dateLabel.font = UIFont(name: fontName, size: 18)
        dateLabel.textColor = UIColor.grayColor()
        self.view.addSubview(dateLabel)
        

        //set a divider
        let divider = UIImageView()
        divider.frame = CGRect(x: 25, y: emotionButton.frame.maxY + 10 , width: frameWidth - 50, height: 3)
        divider.image = UIImage(named: "monthLabelViewImage")
        divider.alpha = 0.5
        self.view.addSubview(divider)
        
        
        //set textView
        let textFieldYPos: CGFloat =  divider.frame.maxY + 10
        textView.text = NSLocalizedString("WRITE_NEW_DIARY_TEXTVIEW_PLACEHOLDER", comment: "DIARY")
        textView.textColor = UIColor.lightGrayColor()
        //textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        
        
        textView.frame = CGRect(x: HORIZONTAL_SPACING , y: textFieldYPos, width: frameWidth - 2 * HORIZONTAL_SPACING - 20, height: frameHeight - textFieldYPos - 65)
        textView.textAlignment = NSTextAlignment.Left
        textView.tintColor = UIColor.grayColor()
        //textView.textColor = UIColor.blackColor()
        textView.font = UIFont(name: fontName, size: 18.0)
        //textView. = NSLineBreakMode.ByWordWrapping
        
        if (textView.text == "") {
            textViewDidEndEditing(textView)
        }
        //let tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //self.view.addGestureRecognizer(tapDismiss)
        textView.keyboardDismissMode = .Interactive

        

        
        // set save button
        
        saveButton.setTitle(NSLocalizedString("WRITE_NEW_SAVE_BUTTON_TITLE", comment: "SAVE"), forState: .Normal)
        saveButton.titleLabel!.font = UIFont(name: fontName, size: 18.0)
        saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton.frame = CGRect(x: (frameWidth - 60) / 2, y: frameHeight - 50, width: 60, height: 20)
        
        
        
        //set saveButtonImageView
        
        saveButtonImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 70)
        saveButtonImageView.center = saveButton.center
        saveButtonImageView.image = UIImage(named: "saveButtonImage")?.stretchableImageWithLeftCapWidth(0, topCapHeight: 0)
        saveButtonImageView.alpha = 0.8
        
        
        saveButton.backgroundImageForState(UIControlState.Normal)

    }
    
    func emotionButtonTapped(sender: UIButton)
    {
        let popUpView = UIView()
        popUpView.backgroundColor = UIColor.whiteColor()
        popUpView.frame = CGRect(x: HORIZONTAL_SPACING , y: VERTICAL_SPACING - 5, width: 0, height: 65)
        popUpView.layer.cornerRadius = 10
        
        let layer = popUpView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        
        // animation
        UIView.animateWithDuration(0.3, animations: {
            popUpView.frame = CGRect(x: self.HORIZONTAL_SPACING , y: self.VERTICAL_SPACING - 5, width: self.view.frame.width - 40, height: 65)


        })
        
        //emotion buttons
        let happyButton = UIButton()
        let angryButton = UIButton()
        let sadButton = UIButton()
        let sosoButton = UIButton()
        
        let BUTTON_WIDTH:CGFloat = 60
        let PADDING = (popUpView.frame.width - (4 * BUTTON_WIDTH)) / 5
        
        happyButton.frame = CGRect(x: PADDING, y: 5 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        angryButton.frame = CGRect(x: 2 * PADDING + BUTTON_WIDTH, y: 5, width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        sadButton.frame = CGRect(x: 3 * PADDING + 2 * BUTTON_WIDTH, y: 5 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        sosoButton.frame = CGRect(x: 4 * PADDING + 3 * BUTTON_WIDTH, y: 5 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        
        happyButton.setBackgroundImage(UIImage(named: "Happy"), forState: .Normal)
        angryButton.setBackgroundImage(UIImage(named: "Angry"), forState: .Normal)
        sadButton.setBackgroundImage(UIImage(named: "Sad"), forState: .Normal)
        sosoButton.setBackgroundImage(UIImage(named: "Soso"), forState: .Normal)
        
        popUpView.addSubview(happyButton)
        popUpView.addSubview(angryButton)
        popUpView.addSubview(sadButton)
        popUpView.addSubview(sosoButton)
        happyButton.alpha = 0
        angryButton.alpha = 0
        sadButton.alpha = 0
        sosoButton.alpha = 0
        popUpView.tag = 909
        
        self.view.addSubview(popUpView)
        UIView.animateWithDuration(0.5, animations: {
            happyButton.alpha = 1.0
            angryButton.alpha = 1.0
            sadButton.alpha = 1.0
            sosoButton.alpha = 1.0
            
            
        })
        
        
        happyButton.addTarget(self, action: "happyButtonTapped:", forControlEvents: .TouchUpInside)
        angryButton.addTarget(self, action: "angryButtonTapped:", forControlEvents: .TouchUpInside)
        sadButton.addTarget(self, action: "sadButtonTapped:", forControlEvents: .TouchUpInside)
        sosoButton.addTarget(self, action: "sosoButtonTapped:", forControlEvents: .TouchUpInside)
 
    }
    
    func happyButtonTapped(sender:UIButton){
        emotionString = "Happy"
        emotionButton.setBackgroundImage(UIImage(named: "Happy"), forState: .Normal)
        dismissEmotionPopUp()
    }
    
    func angryButtonTapped(sender:UIButton){
        emotionString = "Angry"
        emotionButton.setBackgroundImage(UIImage(named: "Angry"), forState: .Normal)
        dismissEmotionPopUp()
    }
    
    func sadButtonTapped(sender:UIButton){
        emotionString = "Sad"
        emotionButton.setBackgroundImage(UIImage(named: "Sad"), forState: .Normal)
        dismissEmotionPopUp()
    }
    
    func sosoButtonTapped(sender:UIButton){
        emotionString = "Soso"
        emotionButton.setBackgroundImage(UIImage(named: "Soso"), forState: .Normal)
        dismissEmotionPopUp()
    }
    
    
    func dismissEmotionPopUp(){
        for views in self.view.subviews{
            if views.tag == 909{
                views.removeFromSuperview()
            }
        }
    }
    
    
    @IBAction func saveButtonCliked(sender: AnyObject) {
       // emotionButtonSelectedView.alpha = 0
    }
    

    func getDate() -> String{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.stringFromDate(NSDate())
            return date
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        //let maxLength = 16
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        let textSize:CGSize = newString.sizeWithAttributes([NSFontAttributeName: textField.font!])
        return textSize.width < textField.bounds.size.width
        
        //return NewString.length <= maxLength
    }
    
    
    // text view
    
    func dismissKeyboard(){
        textView.resignFirstResponder()
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = NSLocalizedString("WRITE_NEW_DIARY_TEXTVIEW_PLACEHOLDER", comment: "DIARY")
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == NSLocalizedString("WRITE_NEW_DIARY_TEXTVIEW_PLACEHOLDER", comment: "DIARY")){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
  
}
