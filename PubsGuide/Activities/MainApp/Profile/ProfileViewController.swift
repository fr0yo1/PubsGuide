//
//  ProfileViewController.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, Storyboarded, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var profileOptionsCollectionView: UICollectionView!
    private(set) var model = SettingsModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileOptionsCollectionView.dataSource = self
        self.profileOptionsCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.profileOptionsCollectionView.bounds.width
        if( indexPath.section == 0) {
            let cellHeight = self.profileOptionsCollectionView.bounds.height / 3
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        let cellHeight = CGFloat(40)
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return self.model.options.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellResult: UICollectionViewCell!
        switch (indexPath.section) {
        case 0:
            let profileImageUrl = ProfileRepository.shared.profileImageUrl

            let cell = profileOptionsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell
            cell.profileImage.imageFromServerURL(profileImageUrl, placeHolder: UIImage(named: "profile_image_placeholder"), circularShape: true)
            cell.userName.text = ProfileRepository.shared.user.displayName
            cellResult = cell
        case 1:
            let cell = profileOptionsCollectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! GeneralCollectionViewCell
            cell.imageView.image = model.options[indexPath.row].image
            cell.optionName.text = model.options[indexPath.row].text!
            cellResult = cell
        default:
            break
        }

        return cellResult
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.model.options[indexPath.row].onClick?()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
