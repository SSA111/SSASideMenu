//
//  SSASideMenu.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 06/10/14.
//  Copyright (c) 2014 Sebastian Andersen. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var sideMenuViewController: SSASideMenu? {
        get {
            return getSideViewController(self)
        }
    }
    
    private func getSideViewController(viewController: UIViewController) -> SSASideMenu? {
        if let parent = viewController.parentViewController {
            if parent is SSASideMenu {
                return parent as? SSASideMenu
            }else {
                return getSideViewController(parent)
            }
        }
        return nil
    }
    
    @IBAction func presentLeftMenuViewController() {
        
        sideMenuViewController?._presentLeftMenuViewController()
        
    }
    
    @IBAction func presentRightMenuViewController() {
        
        sideMenuViewController?._presentRightMenuViewController()
    }
    
}

@objc protocol SSASideMenuDelegate {
    
    optional func sideMenuDidRecognizePanGesture(sideMenu: SSASideMenu, recongnizer: UIPanGestureRecognizer)
    optional func sideMenuWillShowMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController)
    optional func sideMenuDidShowMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController)
    optional func sideMenuWillHideMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController)
    optional func sideMenuDidHideMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController)
    
}

class SSASideMenu: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    weak var delegate: SSASideMenuDelegate?
    
    private var visible: Bool = false
    private var leftMenuVisible: Bool = false
    private var rightMenuVisible: Bool = false
    private var originalPoint: CGPoint = CGPoint()
    private var didNotifyDelegate: Bool = false
    
    private let iOS7OrGreater: Bool = kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1
    private let iOS8: Bool = kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_7_1
    
    private let menuViewContainer: UIView = UIView()
    private let contentViewContainer: UIView = UIView()
    private let contentButton: UIButton = UIButton()
    
    private let backgroundImageView: UIImageView = UIImageView()
    
    var backgroundImage: UIImage? {
        willSet {
            if let bckImage = newValue {
                backgroundImageView.image = bckImage
            }
        }
    }
    
    var contentViewController: UIViewController? {
        willSet  {
            setupViewController(contentViewContainer, targetViewController: newValue, tearDown: true)
        }
        didSet {
            setupContentViewShadow()
            if visible {
                setupContentViewControllerMotionEffects()
            }
        }
    }
    
    var leftMenuViewController: UIViewController? {
        willSet  {
            setupViewController(menuViewContainer, targetViewController: newValue, tearDown: true)
        }
        didSet {
            setupMenuViewControllerMotionEffects()
            view.bringSubviewToFront(contentViewContainer)
        }
    }
    var rightMenuViewController: UIViewController? {
        willSet  {
            setupViewController(menuViewContainer, targetViewController: newValue, tearDown: true)
        }
        didSet {
            setupMenuViewControllerMotionEffects()
            view.bringSubviewToFront(contentViewContainer)
        }
    }

    //MARK : Initializers
    
//    override init() {
//        super.init()
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(contentViewController: UIViewController, leftMenuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        
    }
    
    convenience init(contentViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.rightMenuViewController = rightMenuViewController
    }
    
    convenience init(contentViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        self.rightMenuViewController = rightMenuViewController
    }
    
    //MARK : Present / Hide Menu ViewControllers
    
    func _presentLeftMenuViewController() {
        presentMenuViewContainerWithMenuViewController(leftMenuViewController)
        showLeftMenuViewController()
    }
    
    func _presentRightMenuViewController() {
        presentMenuViewContainerWithMenuViewController(rightMenuViewController)
        showRightMenuViewController()
    }
    
    func hideMenuViewController() {
        hideMenuViewController(true)
    }
    
    private func showRightMenuViewController() {
        
        if let viewController = rightMenuViewController {
            
            println(viewController)
            
            viewController.view.hidden = false
            leftMenuViewController?.view.hidden = true
            
            if endAllEditingWhenShown {
                view.window?.endEditing(true)
            }else {
                setupUserInteractionForContentButtonAndTargetViewControllerView(true, targetViewControllerViewInteractive: false)
            }
  
            setupContentButton()
            setupContentViewShadow()
            resetContentViewScale()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                if self.sideMenuType == .Scale {
                    self.contentViewContainer.transform = CGAffineTransformMakeScale(CGFloat(self.contentViewScaleValue), CGFloat(self.contentViewScaleValue))
                }else {
                    self.contentViewContainer.transform = CGAffineTransformIdentity
                }            
                
                self.contentViewContainer.center = CGPointMake(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? -CGFloat(self.contentViewInLandscapeOffsetCenterX) : CGFloat(-self.contentViewInPortraitOffsetCenterX), self.contentViewContainer.center.y)
             
                self.menuViewContainer.alpha = !self.fadeMenuView ? self.fadeMenuView ? 1 : 0 : 1
                self.contentViewContainer.alpha = CGFloat(self.contentViewFadeOutAlpha)
                self.menuViewContainer.transform = CGAffineTransformIdentity
                
                if self.scaleBackgroundImageView {
                    if self.backgroundImage != nil {
                        self.backgroundImageView.transform = CGAffineTransformIdentity
                    }
                }
                
                }, completion: { (Bool) -> Void in
                    
                    if !self.visible {
                        self.delegate?.sideMenuDidShowMenuViewController?(self, menuViewController: viewController)
                    }
                    
                    self.visible = !(self.contentViewContainer.frame.size.width == self.view.bounds.size.width && self.contentViewContainer.frame.size.height == self.view.bounds.size.height && self.contentViewContainer.frame.origin.x == 0 && self.contentViewContainer.frame.origin.y == 0)
                    self.rightMenuVisible = self.visible
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.setupContentViewControllerMotionEffects()
            })
            statusBarNeedsAppearanceUpdate()
        }
  
    }
    
    private func showLeftMenuViewController() {
        
        if let viewController = leftMenuViewController {
            
            viewController.view.hidden = false
            rightMenuViewController?.view.hidden = true
            
            if endAllEditingWhenShown {
                view.window?.endEditing(true)
            }else {
                setupUserInteractionForContentButtonAndTargetViewControllerView(true, targetViewControllerViewInteractive: false)
            }
   
            setupContentButton()
            setupContentViewShadow()
            resetContentViewScale()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                if self.sideMenuType == .Scale {
                    self.contentViewContainer.transform = CGAffineTransformMakeScale(CGFloat(self.contentViewScaleValue), CGFloat(self.contentViewScaleValue))
                }else {
                    self.contentViewContainer.transform = CGAffineTransformIdentity
                }
                
                if self.iOS8 {
                    self.contentViewContainer.center = CGPointMake(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? CGFloat(self.contentViewInLandscapeOffsetCenterX) + CGFloat(CGRectGetWidth(self.view.frame)) : CGFloat(self.contentViewInPortraitOffsetCenterX) + CGFloat(CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y)
                } else {
                    self.contentViewContainer.center = CGPointMake(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? CGFloat(self.contentViewInLandscapeOffsetCenterX) + CGFloat(CGRectGetHeight(self.view.frame)) : CGFloat(self.contentViewInPortraitOffsetCenterX) + CGFloat(CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y)
                }
        
                /*self.contentViewContainer.center = CGPointMake(UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? CGFloat(self.contentViewInLandscapeOffsetCenterX) + CGRectGetWidth(self.view.frame) : CGFloat(self.contentViewInPortraitOffsetCenterX) + CGRectGetWidth(self.view.frame), self.contentViewContainer.center.y)*/
               
                self.menuViewContainer.alpha = !self.fadeMenuView ? self.fadeMenuView ? 1 : 0 : 1
                self.contentViewContainer.alpha = CGFloat(self.contentViewFadeOutAlpha)
                self.menuViewContainer.transform = CGAffineTransformIdentity
                
                if self.scaleBackgroundImageView {
                    if self.backgroundImage != nil {
                        self.backgroundImageView.transform = CGAffineTransformIdentity
                    }
                    
                }
                
                }, completion: { (Bool) -> Void in
                    
                    if !self.visible {
                        self.delegate?.sideMenuDidShowMenuViewController?(self, menuViewController: viewController)
                    }
                    
                    self.visible = true
                    self.leftMenuVisible = true
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.setupContentViewControllerMotionEffects()
            })
            
            statusBarNeedsAppearanceUpdate()
            
        }
    }
    
    private func presentMenuViewContainerWithMenuViewController(menuViewController: UIViewController?) {
        
        menuViewContainer.transform = CGAffineTransformIdentity
        menuViewContainer.frame = view.bounds
        
        if scaleBackgroundImageView {
            if backgroundImage != nil {
                backgroundImageView.transform = CGAffineTransformIdentity
                backgroundImageView.frame = view.bounds
                backgroundImageView.transform = CGAffineTransformMakeScale(1.7, 1.7)
            }
        }
        
        if scaleMenuView {
            menuViewContainer.transform = menuViewControllerTransformation
        }
        menuViewContainer.alpha = !fadeMenuView ? fadeMenuView ? 1 : 0 : 0

        if let viewController = menuViewController {
            delegate?.sideMenuWillShowMenuViewController?(self, menuViewController: viewController)
        }
        
    }
    
    private func hideMenuViewController(animated: Bool) {
        
        let isRightMenuVisible: Bool = rightMenuVisible
        
        if isRightMenuVisible {
            
            if let viewController = rightMenuViewController {
                
                delegate?.sideMenuWillHideMenuViewController?(self, menuViewController: viewController)
                
            }
            
        }else {
            
            if let viewController = leftMenuViewController {
                
                delegate?.sideMenuWillHideMenuViewController?(self, menuViewController: viewController)
                
            }
        }
        
        if !endAllEditingWhenShown {
            setupUserInteractionForContentButtonAndTargetViewControllerView(false, targetViewControllerViewInteractive: true)
        }
        
        visible = false
        leftMenuVisible = false
        rightMenuVisible = false
        contentButton.removeFromSuperview()
        
        let animationsClosure: () -> () =  {[unowned self] () -> () in
            
            self.contentViewContainer.transform = CGAffineTransformIdentity
            self.contentViewContainer.frame = self.view.bounds
            
            if self.scaleMenuView {
                self.menuViewContainer.transform = self.menuViewControllerTransformation
            }
            self.menuViewContainer.alpha = !self.fadeMenuView ? self.fadeMenuView ? 0 : 1 : 1
            self.contentViewContainer.alpha = CGFloat(self.contentViewFadeOutAlpha)
            
            if self.scaleBackgroundImageView {
                if self.backgroundImage != nil {
                    self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7, 1.7)
                }
            }
            
            if self.parallaxEnabled {
                if self.iOS7OrGreater {                    
                    self.removeMotionEffects(self.contentViewContainer)
                }
            }

        }
        
        let completionClosure: () -> () =  {[unowned self] () -> () in
     
            if isRightMenuVisible {
                
                if let viewController = self.rightMenuViewController {
                    
                    self.delegate?.sideMenuDidHideMenuViewController?(self, menuViewController: viewController)
                    
                }
                
            }else {
                
                if let viewController = self.leftMenuViewController {
                    
                    self.delegate?.sideMenuDidHideMenuViewController?(self, menuViewController: viewController)
                    
                }
            }
            
            
          
        }
        
        if animated {
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                
                animationsClosure()
                
                }, completion: { (Bool) -> Void in
                    completionClosure()
                    
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            })
            
        }else {
            
            animationsClosure()
            completionClosure()
        }
        
        statusBarNeedsAppearanceUpdate()
        
    }
    
    
    override func awakeFromNib() {
        
        if iOS8 {
            if let cntentViewStoryboardID = contentViewStoryboardID {
                contentViewController = storyboard?.instantiateViewControllerWithIdentifier(cntentViewStoryboardID) as? UIViewController
            }
            if let lftViewStoryboardID = leftMenuViewStoryboardID {
                leftMenuViewController = storyboard?.instantiateViewControllerWithIdentifier(lftViewStoryboardID) as? UIViewController
            }
            if let rghtViewStoryboardID = rightMenuViewStoryboardID {
                rightMenuViewController = storyboard?.instantiateViewControllerWithIdentifier(rghtViewStoryboardID) as? UIViewController
            }
        }
        
    }
    
    
    //MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        menuViewContainer.frame = view.bounds;
        menuViewContainer.autoresizingMask = .FlexibleWidth | .FlexibleHeight;
        menuViewContainer.alpha = !fadeMenuView ? fadeMenuView ? 1 : 0 : 0
        
        contentViewContainer.frame = view.bounds
        contentViewContainer.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        setupViewController(contentViewContainer, targetViewController: contentViewController, tearDown: true)
        setupViewController(menuViewContainer, targetViewController: leftMenuViewController, tearDown: true)
        setupViewController(menuViewContainer, targetViewController: rightMenuViewController, tearDown: true)
        
        if panGestureEnabled {
            view.multipleTouchEnabled = false
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panGestureRecognized:"))
            panGestureRecognizer.delegate = self
            view.addGestureRecognizer(panGestureRecognizer)
        }
        
        if let image = backgroundImage {
            if scaleBackgroundImageView {
                backgroundImageView.transform = CGAffineTransformMakeScale(1.7, 1.7)
            }
            backgroundImageView.frame = view.bounds
            backgroundImageView.contentMode = .ScaleAspectFill;
            backgroundImageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight;
            view.addSubview(backgroundImageView)
        }
        
        view.addSubview(menuViewContainer)
        view.addSubview(contentViewContainer)
        
        setupMenuViewControllerMotionEffects()
        setupContentViewShadow()
        
    }
 
    
    // MARK : Setup
    
    private func setupViewController(targetView: UIView, targetViewController: UIViewController?, tearDown: Bool) {
        if let viewController = targetViewController {
            if tearDown {
                hideViewController(viewController)
            }
            addChildViewController(viewController)
            viewController.view.frame = view.bounds
            viewController.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            targetView.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            
        }
    }
    
    private func hideViewController(targetViewController: UIViewController) {
            targetViewController.willMoveToParentViewController(nil)
            targetViewController.view.removeFromSuperview()
            targetViewController.removeFromParentViewController()
    }
    
    //MARK : Layout
    
    private func setupContentButton() {
        
        if (contentButton.superview != nil)  {
            return
        }else {
            contentButton.addTarget(self, action: Selector("hideMenuViewController"), forControlEvents:.TouchUpInside)
            contentButton.autoresizingMask = .None
            contentButton.frame = contentViewContainer.bounds
            contentButton.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            contentButton.tag = 101
            contentViewContainer.addSubview(contentButton)
        }
    }
    
    private func statusBarNeedsAppearanceUpdate() {
        
        if self.respondsToSelector(Selector("setNeedsStatusBarAppearanceUpdate")) {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }
    
    private func setupContentViewShadow() {
        
        if contentViewShadowEnabled {
            let layer: CALayer = contentViewContainer.layer
            let path: UIBezierPath = UIBezierPath(rect: layer.bounds)
            layer.shadowPath = path.CGPath
            layer.shadowColor = contentViewShadowColor.CGColor
            layer.shadowOffset = contentViewShadowOffset
            layer.shadowOpacity = contentViewShadowOpacity
            layer.shadowRadius = CGFloat(contentViewShadowRadius)
        }
        
    }
    
    //MARK : Helper Functions 
    
    private func resetContentViewScale() {
        let t: CGAffineTransform = contentViewContainer.transform
        let scale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let frame: CGRect = contentViewContainer.frame
        contentViewContainer.transform = CGAffineTransformIdentity
        contentViewContainer.transform = CGAffineTransformMakeScale(scale, scale)
        contentViewContainer.frame = frame
    }
    
    private func setupUserInteractionForContentButtonAndTargetViewControllerView(contentButtonInteractive: Bool, targetViewControllerViewInteractive: Bool) {
        
        if let viewController = contentViewController {
            for view in viewController.view.subviews as! [UIView] {
                if view.tag == 101 {
                    view.userInteractionEnabled = contentButtonInteractive
                }else {
                    view.userInteractionEnabled = targetViewControllerViewInteractive
                }
            }
        }
        
    }
    
    //MARK: Motion Effects (Private)
    
    private func removeMotionEffects(targetView: UIView) {
        
        if let targetViewMotionEffects = targetView.motionEffects {
            for effect in targetViewMotionEffects {
                targetView.removeMotionEffect(effect as! UIMotionEffect)
            }
        }
        
    }
    
    private func setupMenuViewControllerMotionEffects() {
        
        if parallaxEnabled {
            
            if iOS7OrGreater {
                
                removeMotionEffects(menuViewContainer)
                
                // We need to refer to self in closures!
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    let interpolationHorizontal: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
                    interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                    interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                    
                    let interpolationVertical: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
                    interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                    interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                    
                    self.menuViewContainer.addMotionEffect(interpolationHorizontal)
                    self.menuViewContainer.addMotionEffect(interpolationVertical)
                    
                })
                
            }
            
        }
    }
    
    private func setupContentViewControllerMotionEffects() {
        
        if parallaxEnabled {
            
            if iOS7OrGreater {
                
                removeMotionEffects(contentViewContainer)
                
                // We need to refer to self in closures!
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    let interpolationHorizontal: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
                    interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                    interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                    
                    let interpolationVertical: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
                    interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                    interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                    
                    self.contentViewContainer.addMotionEffect(interpolationHorizontal)
                    self.contentViewContainer.addMotionEffect(interpolationVertical)
                    
                })
                
            }
            
        }
        
        
    }
    
    //MARK: View Controller Rotation handler
    
    override func shouldAutorotate() -> Bool {
        
        if let cntViewController = contentViewController {
            
            return cntViewController.shouldAutorotate()
        }
        return false
        
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        if visible {
            
            menuViewContainer.bounds = view.bounds
            contentViewContainer.transform = CGAffineTransformIdentity
            contentViewContainer.frame = view.bounds
            
            if sideMenuType == .Scale {
                contentViewContainer.transform = CGAffineTransformMakeScale(CGFloat(contentViewScaleValue), CGFloat(contentViewScaleValue))
            } else {
                contentViewContainer.transform = CGAffineTransformIdentity
            }
            
            var center: CGPoint
            if leftMenuVisible {
                if iOS8 {
                    center = CGPointMake(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? CGFloat(contentViewInLandscapeOffsetCenterX) + CGFloat(CGRectGetWidth(view.frame)) : CGFloat(contentViewInPortraitOffsetCenterX) + CGFloat(CGRectGetWidth(view.frame)), contentViewContainer.center.y)
                } else {
                    center = CGPointMake(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? CGFloat(contentViewInLandscapeOffsetCenterX) + CGFloat(CGRectGetHeight(view.frame)) : CGFloat(contentViewInPortraitOffsetCenterX) + CGFloat(CGRectGetWidth(view.frame)), contentViewContainer.center.y)
                }
            } else {
                center = CGPointMake(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? -CGFloat(contentViewInLandscapeOffsetCenterX) : CGFloat(-contentViewInPortraitOffsetCenterX), contentViewContainer.center.y)
            }
            
            contentViewContainer.center = center
        }
        
        setupContentViewShadow()
        
    }
    
    //MARK: Status Bar Appearance Management
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        var statusBarStyle: UIStatusBarStyle  = .Default
        
        if iOS7OrGreater {
            
            if let cntViewController = contentViewController {
                
                if let menuPreferredStatusBarStyle = menuPreferredStatusBarStyle {
                    
                    statusBarStyle = visible ? menuPreferredStatusBarStyle : cntViewController.preferredStatusBarStyle()
                    
                    if contentViewContainer.frame.origin.y > 10 {
                        statusBarStyle = menuPreferredStatusBarStyle
                    } else {
                        statusBarStyle = cntViewController.preferredStatusBarStyle()
                    }
                    
                }
                
            }
            
        }
        return statusBarStyle
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        var statusBarHidden: Bool = false
        
        if iOS7OrGreater {
            
            if let cntViewController = contentViewController {
                
                statusBarHidden = visible ? menuPrefersStatusBarHidden : cntViewController.prefersStatusBarHidden()
                
                if contentViewContainer.frame.origin.y > 10 {
                    statusBarHidden = menuPrefersStatusBarHidden
                } else {
                    statusBarHidden = cntViewController.prefersStatusBarHidden()
                }
                
            }
            
        }
        
        return statusBarHidden
        
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        
        var statusBarAnimation: UIStatusBarAnimation = .None
        
        if iOS7OrGreater {
            
            if let cntViewController = contentViewController {
                
                if let leftMenuViewController = leftMenuViewController {
                    
                    statusBarAnimation = visible ? leftMenuViewController.preferredStatusBarUpdateAnimation() : cntViewController.preferredStatusBarUpdateAnimation()
                    
                }else if let rghtMenuViewController = rightMenuViewController {
                    
                    statusBarAnimation = visible ? rghtMenuViewController.preferredStatusBarUpdateAnimation() : cntViewController.preferredStatusBarUpdateAnimation()
                }
                
                if contentViewContainer.frame.origin.y > 10 {
                    
                    if let leftMenuViewController = leftMenuViewController {
                        
                        statusBarAnimation = leftMenuViewController.preferredStatusBarUpdateAnimation()
                        
                    }else if let rghtMenuViewController = rightMenuViewController {
                        
                        statusBarAnimation = rghtMenuViewController.preferredStatusBarUpdateAnimation()
                    }
                    
                } else {
                    statusBarAnimation = cntViewController.preferredStatusBarUpdateAnimation()
                }
                
            }
            
        }
        
        return statusBarAnimation
        
        
    }
    
    //MARK: UIGestureRecognizer Delegate (Private)
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if iOS7OrGreater {
            
            if interactivePopGestureRecognizerEnabled {
                
                if  let viewController = contentViewController as? UINavigationController {
                    
                    if viewController.viewControllers.count > 1 && viewController.interactivePopGestureRecognizer.enabled {
                        
                        return false
                    }
                    
                    
                }
            }
            
        }
        
        if gestureRecognizer is UIPanGestureRecognizer && !visible {
            
            if panDirection == .Edge {
                let point: CGPoint = touch.locationInView(gestureRecognizer.view)
                if point.x < 20.0 || point.x > view.frame.size.width - 20.0 {
                    return true
                } else {
                    return false
                }
            } else if panDirection == .EveryWhere {
                return true
            }
            
        }
        
        return true
        
    }
    
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        
        delegate?.sideMenuDidRecognizePanGesture?(self, recongnizer: recognizer)
        
        if !panGestureEnabled {
            return
        }
        
        var point: CGPoint = recognizer.translationInView(view)
        
        if recognizer.state == .Began {
            setupContentViewShadow()
            
            originalPoint = CGPointMake(contentViewContainer.center.x - CGRectGetWidth(contentViewContainer.bounds) / 2.0,
                contentViewContainer.center.y - CGRectGetHeight(contentViewContainer.bounds) / 2.0)
            menuViewContainer.transform = CGAffineTransformIdentity
            
            if (scaleBackgroundImageView) {
                backgroundImageView.transform = CGAffineTransformIdentity
                backgroundImageView.frame = view.bounds
            }
            
            menuViewContainer.frame = view.bounds
            setupContentButton()
            
            if endAllEditingWhenShown {
                view.window?.endEditing(true)
            }else {
                setupUserInteractionForContentButtonAndTargetViewControllerView(true, targetViewControllerViewInteractive: false)
            }
   
            didNotifyDelegate = false
        }
        
        if recognizer.state == .Changed {
            
            //TO DO: Use Swift primitive types (Float) instead of CGFloat
            var delta: CGFloat = 0.0
            if visible {
                delta = originalPoint.x != 0 ? (point.x + originalPoint.x) / originalPoint.x : 0
            } else {
                delta = point.x / view.frame.size.width
            }
            
            delta = min(fabs(delta), 1.6)
            
            var contentViewScale: CGFloat = sideMenuType == .Scale ? 1 - ((1 - CGFloat(contentViewScaleValue)) * delta) : 1
            
            var backgroundViewScale: CGFloat = 1.7 - (0.7 * delta)
            var menuViewScale: CGFloat = 1.5 - (0.5 * delta)
            
            if !bouncesHorizontally {
                contentViewScale = max(contentViewScale, CGFloat(contentViewScaleValue))
                backgroundViewScale = max(backgroundViewScale, 1.0)
                menuViewScale = max(menuViewScale, 1.0)
            }
            
            menuViewContainer.alpha = !fadeMenuView ? 0 : delta
            contentViewContainer.alpha = 1 - (1 - CGFloat(contentViewFadeOutAlpha)) * delta
            
            if scaleBackgroundImageView {
                backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale)
            }
            
            if scaleMenuView {
                menuViewContainer.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale)
            }
            
            if scaleBackgroundImageView {
                if backgroundViewScale < 1 {
                    backgroundImageView.transform = CGAffineTransformIdentity
                }
            }
            
            if bouncesHorizontally && visible {
                if contentViewContainer.frame.origin.x > contentViewContainer.frame.size.width / 2.0 {
                    point.x = min(0.0, point.x)
                }
                
                if contentViewContainer.frame.origin.x < -(contentViewContainer.frame.size.width / 2.0) {
                    point.x = max(0.0, point.x)
                }
                
            }
            
            // Limit size
            if point.x < 0 {
                point.x = max(point.x, -UIScreen.mainScreen().bounds.size.height)
            } else {
                point.x = min(point.x, UIScreen.mainScreen().bounds.size.height)
            }
            
            recognizer.setTranslation(point, inView: view)
            
            if !didNotifyDelegate {
                if point.x > 0 {
                    
                    if !visible {
                        if let viewController = leftMenuViewController {
                            self.delegate?.sideMenuWillShowMenuViewController?(self, menuViewController: viewController)
                        }
                    }
                    
                }
                if point.x < 0 {
                    
                    if !visible {
                        if let viewController = rightMenuViewController {
                            self.delegate?.sideMenuWillShowMenuViewController?(self, menuViewController: viewController)
                        }
                    }
                    
                }
                didNotifyDelegate = true
            }
            
            if contentViewScale > 1 {
                let oppositeScale: CGFloat = (1 - (contentViewScale - 1))
                contentViewContainer.transform = CGAffineTransformMakeScale(oppositeScale, oppositeScale)
                contentViewContainer.transform = CGAffineTransformTranslate(contentViewContainer.transform, point.x, 0)
            } else {
                contentViewContainer.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale)
                contentViewContainer.transform = CGAffineTransformTranslate(contentViewContainer.transform, point.x, 0)
            }
            
            leftMenuViewController?.view.hidden = contentViewContainer.frame.origin.x < 0
            rightMenuViewController?.view.hidden = contentViewContainer.frame.origin.x > 0
            
            if  leftMenuViewController == nil && contentViewContainer.frame.origin.x > 0 {
                contentViewContainer.transform = CGAffineTransformIdentity
                contentViewContainer.frame = view.bounds
                visible = false
                leftMenuVisible = false
            } else if self.rightMenuViewController == nil && contentViewContainer.frame.origin.x < 0 {
                contentViewContainer.transform = CGAffineTransformIdentity
                contentViewContainer.frame = view.bounds
                visible = false
                rightMenuVisible = false
            }
            
            statusBarNeedsAppearanceUpdate()
        }
        
        if recognizer.state == .Ended {
            
            didNotifyDelegate = false
            if panMinimumOpenThreshold > 0 && contentViewContainer.frame.origin.x < 0 && contentViewContainer.frame.origin.x > -CGFloat(panMinimumOpenThreshold) || contentViewContainer.frame.origin.x > 0 && contentViewContainer.frame.origin.x < CGFloat(panMinimumOpenThreshold)  {
                
                hideMenuViewController()
                
            }else if contentViewContainer.frame.origin.x == 0 {
                
                hideMenuViewController(false)
                
            }else {
                if recognizer.velocityInView(view).x > 0  {
                    if contentViewContainer.frame.origin.x < 0 {
                        hideMenuViewController()
                    } else {
                        if leftMenuViewController != nil {
                            showLeftMenuViewController()
                        }
                    }
                } else {
                    if contentViewContainer.frame.origin.x < 20 {
                        if rightMenuViewController != nil {
                            showRightMenuViewController()
                        }
                    } else {
                        hideMenuViewController()
                    }
                }
            }
        }
        
    }
    
}