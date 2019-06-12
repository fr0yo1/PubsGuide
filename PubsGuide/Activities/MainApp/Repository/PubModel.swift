//
//  PubModel.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase

class PubModel: Decodable, Encodable {
    var id: String!
    var title: String!
    var description: String!
    var location: GeoPoint!
    var pictureId: String!
    var puctureUrl: URL?
    var timestamp: Timestamp!
    var userId: String!
    var userName: String!
    var userProfilePictureUrl: String!
    
    var isFavorite: Bool = false
    var stateWillChange: Bool = false
    var picture: UIImage!
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case location
        case pictureId
        case timestamp
        case userId
        case userName
        case userProfilePictureUrl
    }
}

extension GeoPoint: GeoPointType {}
extension Timestamp: TimestampType {}
