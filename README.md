![SSASideMenu](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/Images.xcassets/SSASideMenuCover.imageset/SSASideMenuCover.png)
SSASideMenu is a reimplementation of
[romaonthego/RESideMenu](https://github.com/romaonthego/RESideMenu) in
Swift. A iOS 7/8 style side menu with parallax effect.  

<img src="https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/LeftDemo.gif" alt="RESideMenu Screenshot" width="400" height="568" />
<img src="https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/RightDemo.gif" alt="RESideMenu Screenshot" width="320" height="568" />


![](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/LeftDemo.gif)
![](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/RightDemo.gif)

#Usage

```swift
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //MARK : Setup SSASideMenu
        
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: FirstViewController()), leftMenuViewController: LeftMenuViewController())
        sideMenu.backgroundImage = UIImage(named: "Background.jpg")
        sideMenu.menuPreferredStatusBarStyle = .LightContent
        sideMenu.delegate = self
        
        window?.rootViewController = sideMenu
        window?.makeKeyAndVisible()
               
        return true
    }
```
#Installation 
As for now please clone the repository and drag the source folder into your project to use SSASideMenu. (Cocoapods coming soon) 
#Customization
```swift
enum SSASideMenuPanDirection: Int {
        case Edge = 0
        case EveryWhere = 1
    }
    
    enum SSASideMenuType: Int {
        case Scale = 0
        case Slip = 1
    }
    
    @IBInspectable var contentViewStoryboardID: String?
    @IBInspectable var leftMenuViewStoryboardID: String?
    @IBInspectable var rightMenuViewStoryboardID: String?
    
    @IBInspectable var interactivePopGestureRecognizerEnabled: Bool = true
    @IBInspectable var fadeMenuView: Bool =  true
    @IBInspectable var scaleMenuView: Bool = true
    @IBInspectable var scaleBackgroundImageView: Bool = true
    @IBInspectable var contentViewShadowEnabled: Bool = true
    @IBInspectable var parallaxEnabled: Bool = true
    @IBInspectable var bouncesHorizontally: Bool = true
    @IBInspectable var menuPrefersStatusBarHidden: Bool = false
    @IBInspectable var endAllEditingWhenShown: Bool = false
    
    @IBInspectable var contentViewShadowColor: UIColor = UIColor.blackColor()
    @IBInspectable var contentViewShadowOffset: CGSize = CGSizeZero
    @IBInspectable var contentViewShadowOpacity: Float = 0.4
    @IBInspectable var contentViewShadowRadius: Float = 8.0
    @IBInspectable var contentViewScaleValue: Float = 0.7
    @IBInspectable var contentViewFadeOutAlpha: Float = 1.0
    @IBInspectable var contentViewInLandscapeOffsetCenterX: Float = 30.0
    @IBInspectable var contentViewInPortraitOffsetCenterX: Float = 30.0
    @IBInspectable var parallaxMenuMinimumRelativeValue: Float = -15.0
    @IBInspectable var parallaxMenuMaximumRelativeValue: Float = 15.0
    @IBInspectable var parallaxContentMinimumRelativeValue: Float = -25.0
    @IBInspectable var parallaxContentMaximumRelativeValue: Float = 25.0
    
    @IBInspectable var menuPreferredStatusBarStyle: UIStatusBarStyle?
    @IBInspectable var animationDuration: NSTimeInterval = 0.35
    @IBInspectable var panGestureEnabled: Bool = true
    @IBInspectable var panDirection: SSASideMenuPanDirection = .Edge
    @IBInspectable var sideMenuType: SSASideMenuType = .Scale
    @IBInspectable var panMinimumOpenThreshold: UInt = 60
    @IBInspectable var menuViewControllerTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.5, 1.5)
    
```

#Author

Sebastian Andersen

[romaonthego/RESideMenu](https://github.com/romaonthego/RESideMenu) was
authored by Roman Efimov

#License

SSASideMenu is available under the MIT license. 

Copyright © 2015 Sebastian Andersen.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
