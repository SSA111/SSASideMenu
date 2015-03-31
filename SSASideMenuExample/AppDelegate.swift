//
//  AppDelegate.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2014 Sebastian Andersen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SSASideMenuDelegate {

    var window: UIWindow?

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
    
    func sideMenuWillShowMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController) {
        println("Will Show \(menuViewController)")
    }
    
    func sideMenuDidShowMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController) {
        println("Did Show \(menuViewController)")
    }
    
    func sideMenuDidHideMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController) {
         println("Did Hide \(menuViewController)")
    }
    
    func sideMenuWillHideMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController) {
        println("Will Hide \(menuViewController)")
    }
    func sideMenuDidRecognizePanGesture(sideMenu: SSASideMenu, recongnizer: UIPanGestureRecognizer) {
        println("Did Recognize PanGesture \(recongnizer)")
    }

}

