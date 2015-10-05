//  AnimationTabBarController.swift
//
// Copyright (c) 11/10/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class RAMAnimatedTabBarItem: UITabBarItem {

    @IBOutlet weak var animation: RAMItemAnimation?
    @IBInspectable var textColor = UIColor.blackColor()
    

    func playAnimation(icon: UIImageView, textLabel: UILabel){
        guard let animation = animation else {
            print("add animation in UITabBarItem")
            return
        }
        animation.playAnimation(icon, textLabel: textLabel)
    }

    func deselectAnimation(icon: UIImageView, textLabel: UILabel) {
        animation?.deselectAnimation(icon, textLabel: textLabel, defaultTextColor: textColor)
    }

    func selectedState(icon: UIImageView, textLabel: UILabel) {
        animation?.selectedState(icon, textLabel: textLabel)
    }
}

class RAMAnimatedTabBarController: UITabBarController {
    
    
    var iconsView: [(icon: UIImageView, textLabel: UILabel)] = []
    var buttonSelected = false
    let tempButton = UIButton(type:UIButtonType.Custom) as UIButton


// MARK: life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        //overlayButton()

        let containers = createViewContainers()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeSubview:", name:"remove", object: nil)

        createCustomIcons(containers)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        overlayButton()
        
    }
    
// Customize the central button
    func overlayButton(){
      
        tempButton.frame = CGRectMake(0.0, 0.0, 50, 50);
        let buttonImage = UIImageView()
        buttonImage.frame = CGRect(x: 0,y: 0,width: 70,height: 70)
        buttonImage.image = UIImage(named: "writeButton")
        
        buttonImage.frame = CGRect(x: 0,y: 0,width: 60,height: 60)
        tempButton.setBackgroundImage(buttonImage.image, forState:UIControlState.Normal)
        tempButton.setBackgroundImage(buttonImage.image, forState:UIControlState.Highlighted)
        
        let heightDifference = buttonImage.frame.height - self.tabBar.frame.size.height;
        if (heightDifference < 0){
            tempButton.center = self.tabBar.center
        }
        else
        {
            var center = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            tempButton.center = center;
        }
        tempButton.layer.zPosition = 0
        
        //tempButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        tempButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(tempButton)
        
    }
    
    func removeAllSubview(){
        for sv in self.view.subviews{
            if sv.tag == 100 || sv.tag == 110 || sv.tag == 111
            {
                
                sv.removeFromSuperview()
                buttonSelected = false
            }
        }
    }
    
    func removeSubview(notification: NSNotification){
        for sv in self.view.subviews{
            if sv.tag == 100 || sv.tag == 110 || sv.tag == 111
            {
                sv.removeFromSuperview()
                buttonSelected = false
                entryAdded()
            }
        }
    }
    
    
//set button tap action
    

    
    func buttonPressed(sender: UIButton!)
    {
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let containerView = UIView(frame: CGRect(x: 40, y: 90, width: self.view.frame.width - 80, height: self.view.frame.height - 140))
        
        if !buttonSelected{
            
            let backButton = UIButton(type:UIButtonType.Custom) as UIButton
            backButton.frame = tempButton.frame
            backButton.setBackgroundImage(UIImage(named: "backButton"), forState:UIControlState.Normal)
            backButton.setBackgroundImage(UIImage(named: "backButton"), forState:UIControlState.Highlighted)
            backButton.addTarget(self, action: "backButtonPressed:", forControlEvents: .TouchUpInside)
            
            subView.opaque = true
            subView.backgroundColor = UIColor.grayColor()
            subView.alpha = 0.9
            //subView.addSubview(backButton)
            
            containerView.center = subView.center
            //containerView.clipsToBounds = true
            containerView.opaque = true
        
            //animation
            containerView.alpha = 0
            containerView.frame.origin.y = self.view.frame.height
            UIView.animateWithDuration(0.5, animations: {
                containerView.alpha = 1
                containerView.frame.origin.y = 70
                })
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 15
            containerView.layer.shadowColor = UIColor(white: 0, alpha: 0.1).CGColor
            containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).CGPath
            containerView.layer.shadowOpacity = 1.0;
            containerView.layer.shadowRadius = 3.0;
        
        
            let VC = storyboard!.instantiateViewControllerWithIdentifier("WriteNewViewController") as! WriteNewViewController
            VC.view.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)
            self.addChildViewController(VC)
            containerView.addSubview(VC.view)
            
            
            subView.tag = 100
            containerView.tag = 110
            backButton.tag = 111
            
            self.view.addSubview(subView)
            self.view.addSubview(containerView)
            self.view.addSubview(backButton)
            VC.didMoveToParentViewController(self)
            buttonSelected = true
        }else
        {
            removeAllSubview()
        }
        

    }
    
    
    func backButtonPressed(sender: UIButton!)
    {
        removeAllSubview()
    }
// MARK: create methods

    func createCustomIcons(containers : [String: UIView]) {

        if let items = tabBar.items as? [RAMAnimatedTabBarItem] {
            
            let itemsCount = items.count as Int - 1
            
            for (index, item) in items.enumerate() {

                //assert(item.image != nil, "add image icon in UITabBarItem")
                
                guard let container = containers["container\(itemsCount-index)"] else
                {
                    print("No container given")
                    continue
                }
                container.tag = index

                let icon = UIImageView(image: item.image)
                icon.translatesAutoresizingMaskIntoConstraints = false
                icon.tintColor = UIColor.clearColor()

                // text
                let textLabel = UILabel()
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clearColor()
                textLabel.textColor = item.textColor
                textLabel.font = UIFont.systemFontOfSize(10)
                textLabel.textAlignment = NSTextAlignment.Center
                textLabel.translatesAutoresizingMaskIntoConstraints = false

                container.addSubview(icon)

                
                if let itemImage = item.image {
                    createConstraints(icon, container: container, size: itemImage.size, yOffset: -5)
                }

                container.addSubview(textLabel)
                
                if let tabBarItem = tabBar.items {
                    let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBarItem.count) - 5.0
                    createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16)
                }

                let iconsAndLabels = (icon:icon, textLabel:textLabel)
                iconsView.append(iconsAndLabels)

                if 0 == index { // selected first elemet
                    item.selectedState(icon, textLabel: textLabel)
                }

                item.image = nil
                item.title = ""

            }
        }
    }

    func createConstraints(view: UIView, container: UIView, size: CGSize, yOffset: CGFloat) {

        let constX = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0)
        container.addConstraint(constX)

        let constY = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: yOffset)
        container.addConstraint(constY)

        let constW = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.width)
        view.addConstraint(constW)

        let constH = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.height)
        view.addConstraint(constH)
    }

    func createViewContainers() -> [String: UIView] {

        var containersDict = [String: UIView]()
        
        guard let tabBarItems = tabBar.items else
        {
            return containersDict
        }
        
        let itemsCount: Int = tabBarItems.count - 1

        for index in 0...itemsCount {
            let viewContainer = createViewContainer()
            containersDict["container\(index)"] = viewContainer
        }

        var formatString = "H:|-(0)-[container0]"
        for index in 1...itemsCount {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        let constranints = NSLayoutConstraint.constraintsWithVisualFormat(formatString,
                                                                    options:NSLayoutFormatOptions.DirectionRightToLeft,
                                                                    metrics: nil,
                                                                      views: containersDict)
        view.addConstraints(constranints)

        return containersDict
    }

    func createViewContainer() -> UIView {
        let viewContainer = UIView()
        viewContainer.backgroundColor = UIColor.clearColor() // for test
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)

        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapHandler:")
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)

        // add constrains
        let constY = NSLayoutConstraint(item: viewContainer,
                                   attribute: NSLayoutAttribute.Bottom,
                                   relatedBy: NSLayoutRelation.Equal,
                                      toItem: view,
                                   attribute: NSLayoutAttribute.Bottom,
                                  multiplier: 1,
                                    constant: 0)

        view.addConstraint(constY)

        let constH = NSLayoutConstraint(item: viewContainer,
                                   attribute: NSLayoutAttribute.Height,
                                   relatedBy: NSLayoutRelation.Equal,
                                      toItem: nil,
                                   attribute: NSLayoutAttribute.NotAnAttribute,
                                  multiplier: 1,
                                    constant: tabBar.frame.size.height)
        viewContainer.addConstraint(constH)

        return viewContainer
    }

// MARK: actions

    func tapHandler(gesture:UIGestureRecognizer) {

        let items = tabBar.items as! [RAMAnimatedTabBarItem]

        let currentIndex = gesture.view!.tag
        if selectedIndex != currentIndex && selectedIndex != 2 && currentIndex != 2{
            let animationItem : RAMAnimatedTabBarItem = items[currentIndex]
            let icon = iconsView[currentIndex].icon
            let textLabel = iconsView[currentIndex].textLabel
            animationItem.playAnimation(icon, textLabel: textLabel)

            let deselelectIcon = iconsView[selectedIndex].icon
            let deselelectTextLabel = iconsView[selectedIndex].textLabel
            let deselectItem = items[selectedIndex]
            deselectItem.deselectAnimation(deselelectIcon, textLabel: deselelectTextLabel)

            selectedIndex = gesture.view!.tag
        }
    }
    
    func setSelectIndex(from from: Int,to: Int) {
        if to != 2{
        selectedIndex = to
        }
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        items[from].deselectAnimation(iconsView[from].icon, textLabel: iconsView[from].textLabel)
        items[to].playAnimation(iconsView[to].icon, textLabel: iconsView[to].textLabel)

    }
    
    func entryAdded() {
        
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        
        let currentIndex = 0
        if selectedIndex != currentIndex && selectedIndex != 2 && currentIndex != 2{
            let animationItem : RAMAnimatedTabBarItem = items[currentIndex]
            let icon = iconsView[currentIndex].icon
            let textLabel = iconsView[currentIndex].textLabel
            animationItem.playAnimation(icon, textLabel: textLabel)
            
            let deselelectIcon = iconsView[selectedIndex].icon
            let deselelectTextLabel = iconsView[selectedIndex].textLabel
            let deselectItem = items[selectedIndex]
            deselectItem.deselectAnimation(deselelectIcon, textLabel: deselelectTextLabel)
            //setSelectIndex(from: selectedIndex, to: currentIndex)
            selectedIndex = 0
        }
    }
    

}



