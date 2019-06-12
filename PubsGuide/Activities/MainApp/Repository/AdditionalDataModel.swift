//
//  AditionalUserData.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 23/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation

//Helper class needed because of Firebase documents structure.
class AdditionalDataModel: Decodable {
    var favPubIds = [String]()
}
