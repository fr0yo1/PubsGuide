//
//  PubCell.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit

class PubCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var pubTitle: UILabel!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    public var onClick: (()->())?
    public var id: String!
    
    @IBAction func didClickOnAddToFavorite(_ sender: Any) {
        self.onClick?()
    }
    
    public func populateCell(with pubData: PubModel) {
        self.id = pubData.id
        self.userName.text = pubData.userName
        self.pubTitle.text = pubData.title
        self.userProfileImage.imageFromServerURL(pubData.userProfilePictureUrl, circularShape: true)
        self.productImage.image = UIImage(named: "general_image_placeholder")
        PubsRepository.shared.getProductImage(for: pubData) { (pubUpdated) in
            if pubUpdated.id == self.id {
                self.productImage.image = pubUpdated.picture
            }
        }
        
        if pubData.isFavorite {
            self.isFavoriteButton.setImage(UIImage(named: "full_hearth"), for: .normal)
        } else {
            self.isFavoriteButton.setImage(UIImage(named: "empty_hearth"), for: .normal)
        }
        
        self.onClick = {
            if pubData.isFavorite {
                PubsRepository.shared.removeFromFavorites(pub: pubData)
            } else {
                PubsRepository.shared.addToFavorites(pub: pubData)
            }
        }
    }
}
