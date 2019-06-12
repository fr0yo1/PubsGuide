//
//  PubsListViewController.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 19/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit

class PubsListViewController: UIViewController, Storyboarded, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pubListUICollectionView: UICollectionView!
    public weak var pubsCoordinatorDelegate: PubsCoordinatorDelegate?
    public var pubs = [PubModel]()
    private var pubsRepository = PubsRepository.shared
    
    @IBAction func didPressAddNewPub(_ sender: Any) {
        self.pubsCoordinatorDelegate?.navigateToAddNewPub()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
        loadData()
        
        pubListUICollectionView.dataSource = self
        pubListUICollectionView.delegate = self
    }
    
    public func loadData() {
         pubsRepository.getMorePubs()
    }
    
    public func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveMoreData(_:)),
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveNewData(_:)),
                                               name: .didReceiveNewPubsData,
                                               object: nil)
    }
    
    @objc func pubRemovedFromFavorites(_ notification:Notification) {
        let pub = notification.object as! PubModel
        reloadPub(pub)
    }
    
    @objc func pubAddedToFavorites(_ notification:Notification) {
        let pub = notification.object as! PubModel
        reloadPub(pub)
    }
    
    private func reloadPub(_ pub: PubModel) {
        let index = self.pubs.firstIndex { (element) -> Bool in
            if element.id == pub.id {
                return true
            }
            
            return false
            }!
        pubListUICollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    @objc func didReceiveMoreData(_ notification:Notification) {
        let morePubs = notification.object as! [PubModel]
        pubs.append(contentsOf: morePubs)
        pubListUICollectionView.reloadData()
    }
    
    @objc func didReceiveNewData(_ notification:Notification) {
        let newPubs = notification.object as! [PubModel]
        self.pubs = newPubs
        pubListUICollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.pubListUICollectionView.bounds.size.width
        let cellHeight = (self.pubListUICollectionView.bounds.size.height - (itemsPerScreen * 10)) / itemsPerScreen
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pubs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PubCell", for: indexPath) as! PubCell
        
        let pub = self.pubs[indexPath.row]
        cell.populateCell(with: pub)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pubsCoordinatorDelegate?.navigateToPub(pub: self.pubs[indexPath.row])
    }
    
    private var itemsPerScreen: CGFloat {
        switch UIDevice.current.orientation{
        case .landscapeLeft, .landscapeRight:
            return 1
        default:
            return 2
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
