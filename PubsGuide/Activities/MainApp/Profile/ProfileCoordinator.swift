//
//  ProfileCoordinator.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit
import SafariServices
import Firebase

class ProfileCoordinator: NSObject, OnCellClickDelegate, Coordinator, SFSafariViewControllerDelegate {
    public weak var mainTabBarDelegate: MainTabBarDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    override init() {
        navigationController = UINavigationController()
        super.init()
    }
    
    func start() {
        let profilesViewController = ProfileViewController.instantiate()
        profilesViewController.model.OnCellClickDelegate = self
        navigationController.pushViewController(profilesViewController, animated: false)
    }
    
    
    func openWebPage(urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            self.navigationController.present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.navigationController.dismiss(animated: true)
    }
    
    func logOut() {
        ProfileRepository.shared.logout { [weak self] (error) in
            guard let err = error else {
                self?.mainTabBarDelegate?.didSignOut()
                return
            }
            //TODO
        }
    }
    
}
