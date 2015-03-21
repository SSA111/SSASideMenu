![SSASideMenu](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/Images.xcassets/SSASideMenuCover.imageset/SSASideMenuCover.png)
SSASideMenu is a reimplementation of
[romaonthego/RESideMenu](https://github.com/romaonthego/RESideMenu) in
Swift. A iOS 7/8 style side menu with parallax effect.  

![](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/LeftDemo.gif)
![](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/RightDemo.gif)

#Usage

 SideMenu's properties has been grouped into multiple structs called: MenuEffect, ContentEffect, Shadow
All of these structs have default value for its properties, so you can change them freely

This may lead to less confusion for new users.

```swift
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //MARK : Setup SSASideMenu
        
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: FirstViewController()), leftMenuViewController: LeftMenuViewController())
        sideMenu.backgroundImage = UIImage(named: "Background.jpg")
        sideMenu.statusBarStyle = .Light
        sideMenu.configure(SSASideMenu.MenuEffect(fade: true, scale: true, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentEffect(alpha: 1.0, scale: 0.7))
        sideMenu.configure(SSASideMenu.Shadow(enabled: true, color: UIColor.blackColor(), opacity: 0.6, radius: 6.0))
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
    @IBInspectable var endAllEditingWhenShown: Bool = false
    @IBInspectable var statusBarStyle: StatusBar = StatusBar.Light
    @IBInspectable var animationDuration: NSTimeInterval = 0.35
    @IBInspectable var panGestureEnabled: Bool = true
    @IBInspectable var panDirection: SSASideMenuPanDirection = .Edge
    @IBInspectable var sideMenuType: SSASideMenuType = .Scale
    @IBInspectable var panMinimumOpenThreshold: UInt = 60
    @IBInspectable var menuViewControllerTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.5, 1.5)
    @IBInspectable var backgroundTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.7, 1.7)
    
    
    struct MenuEffect {
        var fade = true
        var scale = true
        var scaleBackground = true
        var parallaxEnabled = true
        var bouncesHorizontally = true
    }
    
    struct Shadow {
        var enabled = true
        var color = UIColor.blackColor()
        var offset = CGSizeZero
        var opacity: Float = 0.4
        var radius: Float = 8.0
    }
    
    struct ContentEffect {
        var alpha: Float = 1.0
        var scale: Float = 0.7
        var landscapeOffsetX: Float = 30
        var portraitOffsetX: Float = 30
        var minParallaxContentRelativeValue: Float = -25.0
        var maxParallaxContentRelativeValue: Float = 25.0
    }
```

#Author

Sebastian Andersen

[romaonthego/RESideMenu](https://github.com/romaonthego/RESideMenu) was
authored by Roman Efimov

#License

SSASideMenu is available under the MIT license. See the LICENSE file for more info.
