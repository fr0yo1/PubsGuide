//
//  Coordonator.swift
//  Pub'sGuide
//
//  Created by Adrian Sandru on 29/03/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
