//
//  PubViewController.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PubViewController: UIViewController, Storyboarded {
    public var pub: PubModel!
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var pubTitle: UILabel!
    @IBOutlet weak var pubDescription: UILabel!
    
    @IBAction func didPressFavoriteButton(_ sender: Any) {
        if self.pub.isFavorite {
            PubsRepository.shared.removeFromFavorites(pub: self.pub)
            return
        }
        
        PubsRepository.shared.addToFavorites(pub: self.pub)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        populate()

        subscribeToNotifications()
    }
    
    private func populate() {
        self.pubTitle.text = pub.title
        self.pubDescription.text = pub.description
        updateFavoriteButtonImage()
        
        centerMapOnLocation(location: self.pub.location)
        
        PubsRepository.shared.getProductImage(for: pub) { [weak self] (pub) in
            self?.picture.imageFromServerURL(pub.puctureUrl!.absoluteString)
        }
    }
    
    private let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: GeoPoint) {
        let location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let annotation = MKPointAnnotation()
            annotation.coordinate = location
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.map.setRegion(coordinateRegion, animated: true)
        self.map.addAnnotation(annotation)
    }

    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.pubAddedToFavorites(_:)),
                                               name: .pubAddedToFavorites,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.pubRemovedFromFavorites(_:)),
                                               name: .pubRemovedFromFavorites,
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
        if self.pub.id == pub.id {
            updateFavoriteButtonImage()
        }
    }
    
    
    private func updateFavoriteButtonImage() {
        if pub.isFavorite {
            self.favoriteButton.setImage(UIImage(named: "full_hearth"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "empty_hearth"), for: .normal)
        }
    }
    
    private func setUpNavBar(){
        self.navigationController?.view.backgroundColor = UIColor.white
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
}
