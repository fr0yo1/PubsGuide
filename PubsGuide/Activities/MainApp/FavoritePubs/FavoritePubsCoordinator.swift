//
//  FavoritePubsCoordinator.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit

class FavoritePubsCoordinator: PubsListCoordinator {
    
    override init() {
        super.init()
    }
    
    override func start() {
        let favoritePubsViewController = FavoritePubsViewController.instantiate()
        favoritePubsViewController.pubsCoordinatorDelegate = self
        navigationController.pushViewController(favoritePubsViewController, animated: false)
    }
}
