//
//  SettingsModel.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 20/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit

protocol OnCellClickDelegate: class {
    func openWebPage(urlString: String)
    func logOut()
}

class SettingsModel {
    private(set) var options = [GenericCollectionViewItem]()
    public weak var OnCellClickDelegate: OnCellClickDelegate?
    
    init() {
        let privacyPolicyItem =
            GenericCollectionViewItem( text: "Privacy policy",
                                            image: UIImage(named: "privacy_policy_icon")!,
                                            onClick: {
                                                self.OnCellClickDelegate?.openWebPage(urlString: "https://www.google.ro")
                                            })
        
        self.options.append(privacyPolicyItem)
        
        let logOutItem =
            GenericCollectionViewItem( text: "Log out",
                                            image: UIImage(named: "logout_icon")!,
                                            onClick: {
                                                self.OnCellClickDelegate?.logOut()
                                            })
        self.options.append(logOutItem)
    }
}
