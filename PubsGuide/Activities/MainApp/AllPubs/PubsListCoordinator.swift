//
//  PubsListCoordinator.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit

protocol PubsCoordinatorDelegate: class {
    func navigateToPub(pub: PubModel)
    func navigateToAddNewPub()
}

class PubsListCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
    }
    
    func start() {
        let pubListViewController = PubsListViewController.instantiate()
        pubListViewController.pubsCoordinatorDelegate = self
        navigationController.pushViewController(pubListViewController, animated: false)
    }
}

extension PubsListCoordinator: PubsCoordinatorDelegate {
    func navigateToPub(pub: PubModel) {
        let pubViewController = PubViewController.instantiate()
        pubViewController.pub = pub
        self.navigationController.pushViewController(pubViewController, animated: true)
    }
    
    func navigateToAddNewPub() {
        let addNewPubViewController = AddNewPubViewController.instantiate()
        self.navigationController.pushViewController(addNewPubViewController, animated: true)
    }
}
