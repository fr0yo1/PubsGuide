//
//  FavoritePubsViewController.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit

class FavoritePubsViewController: PubsListViewController {
    
    override func loadData() {
        self.pubs = PubsRepository.shared.getFavoritePubs()
    }
    
    override func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadData(_:)),
                                               name: .didReceivePubsData,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.pubAddedToFavorites(_:)),
                                               name: .pubAddedToFavorites,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.pubRemovedFromFavorites(_:)),
                                               name: .pubRemovedFromFavorites,
                                               object: nil)
    }
    
    @objc override func pubRemovedFromFavorites(_ notification:Notification) {
        let pub = notification.object as! PubModel
        let index = pubs.firstIndex { (element) -> Bool in
            if element.id == pub.id {
                return true
            }
            return false
        }
        
        if let i = index {
            self.pubs.remove(at: i)
            pubListUICollectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
        }
    }
    
    @objc override func pubAddedToFavorites(_ notification:Notification) {
        let pub = notification.object as! PubModel
        self.pubs.insert(pub, at: 0)
        pubListUICollectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
    }
    
    @objc func reloadData(_ notification:Notification) {
        self.pubs = PubsRepository.shared.getFavoritePubs()
        pubListUICollectionView.reloadData()
    }
}
