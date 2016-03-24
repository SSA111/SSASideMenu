//
//  FirstViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .Plain, target: self, action: #selector(SSASideMenu.presentRightMenuViewController))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
}

