//
//  MainFlowHandler.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit
import Firebase

class MainFlowHandler {
    static var shared = MainFlowHandler()
    
    var window: UIWindow?
    var mainCoordinator: Coordinator?
    
    private init() {
        if Auth.auth().currentUser != nil {
           navigateToMainAppCoordinator()
        } else {
           navigateToLoginCoordinator()
        }
    }
    
    public func navigateToLoginCoordinator() {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        mainCoordinator = UserLoginCoordinator(navigationController: navController)
        mainCoordinator!.start()
        replaceRootViewController(with: navController)
    }
    
    public func navigateToMainAppCoordinator() {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        mainCoordinator = MainTabBarCoordinator(navigationController: navController)
        mainCoordinator!.start()
        replaceRootViewController(with: navController)
    }
    
    public func replaceRootViewController(with nc: UINavigationController) {
        
        if let w = self.window {
        UIView.transition(with: w,
                          duration: 0.6,
                          options: UIView.AnimationOptions.transitionFlipFromLeft,
                          animations: {
                            w.rootViewController = nc
        }, completion: nil)
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            window!.rootViewController = nc
            window!.makeKeyAndVisible()
        }
    }
}
