//
//  MainTabBarCoordinator.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit


protocol MainTabBarDelegate: class {
    func didSignOut()
}

class MainTabBarCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        addChildCoordinators()
        startChildCoordinators()
    }
    
    private func addChildCoordinators() {
        childCoordinators.append(PubsListCoordinator())
        childCoordinators.append(FavoritePubsCoordinator())
        childCoordinators.append(ProfileCoordinator())
    }
    
    private func startChildCoordinators() {
        let mainTabBarController = MainTabBarController.instantiate()
        var viewControllers = [UIViewController]()
        
        for (index, childCoordinator) in self.childCoordinators.enumerated() {
            childCoordinator.start()
            let vc = childCoordinator.navigationController
            switch index {
            case 0:
                vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Search", comment: ""),
                                             image: UIImage(named: "search_icon"),
                                             tag: 0)
            case 1:
                vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Favorites", comment: ""),
                                             image: UIImage(named: "favorites_icon"),
                                             tag: 1)
            case 2:
                vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""),
                                             image: UIImage(named: "profile_icon"),
                                             tag: 2)
                (childCoordinator as! ProfileCoordinator).mainTabBarDelegate = self
            default: break
            }
            viewControllers.append(vc)
        }
        
        mainTabBarController.viewControllers = viewControllers
        self.navigationController.pushViewController(mainTabBarController, animated: false)
    }
}

extension MainTabBarCoordinator: MainTabBarDelegate {
    func didSignOut() {
        MainFlowHandler.shared.navigateToLoginCoordinator()
    }
}
