//
//  TakePictureUIViewController.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class AddNewPubViewController: UIViewController, UINavigationControllerDelegate,
                        UIImagePickerControllerDelegate, Storyboarded, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var pubTitle: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersLeft: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var cameraPreview: UIImageView!
    
    @IBAction func didPressSaveButton(_ sender: Any) {
        didStartSaving()
        view.endEditing(true)
        
        let pub = self.getPubModel()
        if let p = pub {
            PubsRepository.shared.addNewPub(pub: p, with: { [weak self] didSuccess in
                self?.didFinishSaving()
                
                if didSuccess {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.show(message: "Something went wrong")
                }
            })
        } else {
            didFinishSaving()
        }
    }
    
    private var photoTaken: UIImage?
    private var locValue: CLLocationCoordinate2D?
    private var imagePicker: UIImagePickerController!
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionField.delegate = self

        setOnClickListeners()
        getLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func didStartSaving() {
        activityIndicator.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    private func didFinishSaving() {
        activityIndicator.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func setOnClickListeners() {
        let didPressToTakePciture = UITapGestureRecognizer(target: self, action: #selector(pickSource))
        self.cameraPreview.isUserInteractionEnabled = true
        self.cameraPreview.addGestureRecognizer(didPressToTakePciture)
    }
    
    private func getLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.locValue = locValue
        locationManager.stopUpdatingLocation()
    }
    
    private func getPubModel() -> PubModel? {
        
        guard let image = self.photoTaken else {
            show(message: "No photo taken")
            return nil
        }
        
        if self.pubTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            show(message: "Please select a title")
            return nil
        }
        
        if self.descriptionField.text.trimmingCharacters(in: .whitespacesAndNewlines).count < 30 {
            show(message: "Description should have more then 30 characters")
            return nil
        }
        
        guard let loc = self.locValue else {
            show(message: "We couldn't determine your location")
            return nil
        }
        
        let pub = PubModel()
        pub.description = self.descriptionField.text
        pub.location = GeoPoint(latitude: loc.latitude, longitude: loc.longitude)
        pub.picture = image
        pub.title = pubTitle.text
        
        return pub
    }
    
    private func show(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc private func pickSource() {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let pickCameraAction = UIAlertAction(title: "Camera", style: .default, handler:
        {[unowned self]
            (alert: UIAlertAction!) -> Void in
            self.takePhoto(from: .camera)
        })
        
        let pickLibraryAction = UIAlertAction(title: "Library", style: .default, handler:
        { [unowned self]
            (alert: UIAlertAction!) -> Void in
            self.takePhoto(from: .photoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(pickCameraAction)
        optionMenu.addAction(pickLibraryAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func takePhoto(from source: UIImagePickerController.SourceType) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.photoTaken = info[.originalImage] as? UIImage
        cameraPreview.image = info[.originalImage] as? UIImage
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        view.endEditing(true)
        return true
    }
    
    private var maxLength = 150
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == self.descriptionField {
            let newLength = maxLength - (textView.text?.count ?? 0)
            self.charactersLeft.text = String(newLength)
            if newLength > 0 {
                return true
            }
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                    - (self.tabBarController?.tabBar.frame.size.height ?? 0)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
