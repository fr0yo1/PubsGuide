//
//  MainCoordonator.swift
//  Pub'sGuide
//
//  Created by Adrian Sandru on 29/03/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit

protocol LoginSplashScreenDelegate: class {
    func didFinishLogin()
}

class UserLoginCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)

    }
    
    func start() {
        let loadingSplashScreen = LoginSplashScreenViewController.instantiate()
        loadingSplashScreen.loginSplashScreenDelagete = self
        self.navigationController.pushViewController(loadingSplashScreen, animated: false)
    }
    
}

extension UserLoginCoordinator: LoginSplashScreenDelegate {
    
    func didFinishLogin() {
         MainFlowHandler.shared.navigateToMainAppCoordinator()
    }
}
