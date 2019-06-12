//
//  GenericCollectionViewItemModel.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 20/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit

class GenericCollectionViewItem {
    var text: String!
    var image: UIImage!
    
    var onClick: (()->())?
    
    init(text: String, image: UIImage, onClick: (()->())? = nil ) {
        self.text = text
        self.image = image
        self.onClick = onClick
    }
}
