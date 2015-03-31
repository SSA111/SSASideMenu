![SSASideMenu](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/Images.xcassets/SSASideMenuCover.imageset/SSASideMenuCover.png)
SSASideMenu is a reimplementation of
[romaonthego/RESideMenu](https://github.com/romaonthego/RESideMenu) in
Swift. A iOS 7/8 style side menu with parallax effect.  

![](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/LeftDemo.gif)
![](https://github.com/SSA111/SSASideMenu/blob/master/SSASideMenuExample/RightDemo.gif)

###Please Notice

This project is using `Swift 1.2` which is currently in beta and cannot be used in applications
submitted to the Apple App Store.

#Usage

```swift
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //MARK : Setup SSASideMenu
        
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: FirstViewController()), leftMenuViewController: LeftMenuViewController(), rightMenuViewController: RightMenuViewController())
        sideMenu.backgroundImage = UIImage(named: "Background.jpg")
        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 0.7))
        sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.blackColor(), opacity: 0.6, radius: 6.0))
        sideMenu.delegate = self
        
        window?.rootViewController = sideMenu
        window?.makeKeyAndVisible()
               
        return true
    }
```
#Installation 
As for now please clone the repository and drag the source folder into your project to use SSASideMenu. (Cocoapods & Carthage
support coming soon) 
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
    
    enum SSAStatusBarStyle: Int {
        case Hidden = 0
        case Black = 1
        case Light = 2
    }

    struct ContentViewShadow {
    
        var enabled: Bool = true
        var color: UIColor = UIColor.blackColor()
        var offset: CGSize = CGSizeZero
        var opacity: Float = 0.4
        var radius: Float = 8.0
    }
    
    struct MenuViewEffect {
        
        var fade: Bool = true
        var scale: Bool = true
        var scaleBackground: Bool = true
        var parallaxEnabled: Bool = true
        var bouncesHorizontally: Bool = true
        var statusBarStyle: SSAStatusBarStyle = .Black
    
    }

    struct ContentViewEffect {
        
        var alpha: Float = 1.0
        var scale: Float = 0.7
        var landscapeOffsetX: Float = 30
        var portraitOffsetX: Float = 30
        var minParallaxContentRelativeValue: Float = -25.0
        var maxParallaxContentRelativeValue: Float = 25.0
        var interactivePopGestureRecognizerEnabled: Bool = true
 
    }
    
    struct SideMenuOptions {
        
        var animationDuration: NSTimeInterval = 0.35
        var panGestureEnabled: Bool = true
        var panDirection: SSASideMenuPanDirection = .Edge
        var type: SSASideMenuType = .Scale
        var panMinimumOpenThreshold: UInt = 60
        var menuViewControllerTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.5, 1.5)
        var backgroundTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.7, 1.7)
        var endAllEditing: Bool = false
    }
    
    // MARK : Storyboard Support
    @IBInspectable var contentViewStoryboardID: String?
    @IBInspectable var leftMenuViewStoryboardID: String?
    @IBInspectable var rightMenuViewStoryboardID: String?
    
    // MARK : Private Properties: MenuView & BackgroundImageView
    @IBInspectable private var fadeMenuView: Bool =  true
    @IBInspectable private var scaleMenuView: Bool = true
    @IBInspectable private var scaleBackgroundImageView: Bool = true
    @IBInspectable private var parallaxEnabled: Bool = true
    @IBInspectable private var bouncesHorizontally: Bool = true
    
    // MARK : Public Properties: MenuView
    @IBInspectable var statusBarStyle: SSAStatusBarStyle = .Black
    
    // MARK : Private Properties: ContentView
    @IBInspectable private var contentViewScaleValue: Float = 0.7
    @IBInspectable private var contentViewFadeOutAlpha: Float = 1.0
    @IBInspectable private var contentViewInLandscapeOffsetCenterX: Float = 30.0
    @IBInspectable private var contentViewInPortraitOffsetCenterX: Float = 30.0
    @IBInspectable private var parallaxContentMinimumRelativeValue: Float = -25.0
    @IBInspectable private var parallaxContentMaximumRelativeValue: Float = 25.0
    
    // MARK : Public Properties: ContentView
    @IBInspectable var interactivePopGestureRecognizerEnabled: Bool = true
    @IBInspectable var endAllEditing: Bool = false
    
    // MARK : Private Properties: Shadow for ContentView
    @IBInspectable private var contentViewShadowEnabled: Bool = true
    @IBInspectable private var contentViewShadowColor: UIColor = UIColor.blackColor()
    @IBInspectable private var contentViewShadowOffset: CGSize = CGSizeZero
    @IBInspectable private var contentViewShadowOpacity: Float = 0.4
    @IBInspectable private var contentViewShadowRadius: Float = 8.0
    
    // MARK : Public Properties: SideMenu
    @IBInspectable var animationDuration: NSTimeInterval = 0.35
    @IBInspectable var panGestureEnabled: Bool = true
    @IBInspectable var panDirection: SSASideMenuPanDirection = .Edge
    @IBInspectable var type: SSASideMenuType = .Scale
    @IBInspectable var panMinimumOpenThreshold: UInt = 60
    @IBInspectable var menuViewControllerTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.5, 1.5)
    @IBInspectable var backgroundTransformation: CGAffineTransform = CGAffineTransformMakeScale(1.7, 1.7)

    var backgroundImage: UIImage?
    var contentViewController: UIViewController?
    var leftMenuViewController: UIViewController?
    var rightMenuViewController: UIViewController?
```

#Author

Sebastian Andersen

[romaonthego/RESideMenu](https://github.com/romaonthego/RESideMenu) was
authored by Roman Efimov

#License

SSASideMenu is available under the MIT license. See the LICENSE file for more info.
