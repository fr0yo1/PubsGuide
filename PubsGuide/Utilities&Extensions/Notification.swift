//
//  Notification.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceivePubsData = Notification.Name("didReceivePubsData")
    static let pubAddedToFavorites = Notification.Name("pubAddedToFavorites")
    static let pubRemovedFromFavorites = Notification.Name("pubRemovedFromFavorites")
    static let didReceiveNewPubsData = Notification.Name("didReceiveNewPubsData")
}
