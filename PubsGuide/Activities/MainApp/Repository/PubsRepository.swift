//
//  PubsRepository.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 21/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class PubsRepository {
    public static var BATCH_SIZE = Int.max
    public static var shared = PubsRepository()
    
    public var pubs = [PubModel]()
    public var pubsAdditionalData: AdditionalDataModel?
    
    private var storage: Storage
    private var postsDB: CollectionReference
    private var additionalDataDB: CollectionReference
    private init() {
        postsDB = Firestore.firestore().collection("Posts")
        additionalDataDB = Firestore.firestore().collection("PostsAdditionalData")
        storage = Storage.storage()
    }
    
    public func getMorePubs(number: Int? = BATCH_SIZE) {
        if self.pubsAdditionalData == nil {
            additionalDataDB.document(ProfileRepository.shared.user.uid).getDocument { [unowned self] (snapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    if let s = snapshot {
                        self.pubsAdditionalData = try? FirebaseDecoder().decode(AdditionalDataModel.self, from: s.data() as Any)
                    }
                    if self.pubsAdditionalData == nil {
                        self.pubsAdditionalData = AdditionalDataModel()
                    }
                    self.continueWithGettingPubs(number: number!)
                }
            }
        } else {
            continueWithGettingPubs(number: number!)
        }
    }
    
    private func continueWithGettingPubs(number: Int) {
        var filter = NSPredicate()
        if self.pubs.count > 0 {
            filter = NSPredicate(format: "timestamp < %@", self.pubs[self.pubs.count - 1].timestamp)
        } else {
            filter = NSPredicate(format: "timestamp > %@", Timestamp(seconds: 0, nanoseconds: 0))
        }
        
        postsDB.order(by: "timestamp", descending: true).filter(using: filter).limit(to: number).getDocuments { [unowned self] (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for document in (snapshot?.documents)! {
                    let post = try! FirestoreDecoder().decode(PubModel.self, from: document.data())
                    if self.pubsAdditionalData!.favPubIds.contains(document.documentID) {
                        post.isFavorite = true
                    }
                    post.id = document.documentID
                    self.pubs.append(post)
                }
            }
            
            NotificationCenter.default.post(name: .didReceivePubsData, object: self.pubs)
        }
    }
    
    public func getFavoritePubs() -> [PubModel] {
        let favPubs = self.pubs.filter({ (element) -> Bool in
            if element.isFavorite {
                return true
            }
            
            return false
        })
        
        return favPubs
    }
    
    public func getNewItems() {
        if self.pubsAdditionalData == nil {
            additionalDataDB.document(ProfileRepository.shared.user.uid).getDocument { [unowned self] (snapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    if let s = snapshot {
                        self.pubsAdditionalData = try? FirebaseDecoder().decode(AdditionalDataModel.self, from: s.data() as Any)
                    }
                    if self.pubsAdditionalData == nil {
                        self.pubsAdditionalData = AdditionalDataModel()
                    }
                    self.continueWithGettingNewPubs()
                }
            }
        } else {
            continueWithGettingNewPubs()
        }
    }
    
    private func continueWithGettingNewPubs() {
        var filter = NSPredicate()
        if self.pubs.count > 0 {
            filter = NSPredicate(format: "timestamp > %@", self.pubs[0].timestamp)
        } else {
            filter = NSPredicate(format: "timestamp > %@", Timestamp(seconds: 0, nanoseconds: 0))
        }
        
        postsDB.order(by: "timestamp", descending: false).filter(using: filter).getDocuments { [unowned self] (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for document in (snapshot?.documents)! {
                    let post = try! FirestoreDecoder().decode(PubModel.self, from: document.data())
                    if self.pubsAdditionalData!.favPubIds.contains(document.documentID) {
                        post.isFavorite = true
                    }
                    post.id = document.documentID
                    self.pubs.insert(post, at: 0)
                }
            }
            
            NotificationCenter.default.post(name: .didReceiveNewPubsData, object: self.pubs)
        }
    }
    
    public func addNewPub(pub: PubModel, with completion: ((Bool)->())? = nil) {
        pub.userName = ProfileRepository.shared.user.displayName
        pub.userProfilePictureUrl = ProfileRepository.shared.profileImageUrl
        pub.timestamp = Timestamp.init()
        pub.pictureId = NSUUID().uuidString
        
        uploadImage(img: pub.picture,id: pub.pictureId) { [unowned self] hasSuccesfullyUploaded in
            
            if hasSuccesfullyUploaded {
                let document = try! FirestoreEncoder().encode(pub)
                self.postsDB.addDocument(data: document) { error in
                    if error == nil {
                        completion?(true)
                        self.getNewItems()
                    } else {
                        completion?(false)
                    }
                }
            } else {
                completion?(false)
            }
        }
    }
    
    public func addToFavorites(pub: PubModel) {
        
        if pub.stateWillChange {
            return
        }
        
        var favPubsIds = self.pubsAdditionalData!.favPubIds.map { $0.copy() }
        favPubsIds.append(pub.id)
        let data = ["favPubIds" : favPubsIds]
        pub.stateWillChange = true
        
        self.additionalDataDB.document(ProfileRepository.shared.user.uid).setData(data, merge: true) { (error) in
            if error == nil {
                self.pubsAdditionalData?.favPubIds.append(pub.id)
                pub.isFavorite = true
                NotificationCenter.default.post(name: .pubAddedToFavorites, object: pub)
            } else {
                //TODO
            }
            
            pub.stateWillChange = false
        }
    }
    
    public func removeFromFavorites(pub: PubModel) {
        
        if pub.stateWillChange {
            return
        }
        
        let favPubsIds = self.pubsAdditionalData!.favPubIds.filter { (element) -> Bool in
            if element != pub.id {
                return true
            }
            return false
        }
        
        let data = ["favPubIds" : favPubsIds]
        pub.stateWillChange = true
        
        self.additionalDataDB.document(ProfileRepository.shared.user.uid).setData(data, merge: true) { (error) in
            if error == nil {
                self.pubsAdditionalData?.favPubIds = favPubsIds
                pub.isFavorite = false
                NotificationCenter.default.post(name: .pubRemovedFromFavorites, object: pub)
            } else {
                //TODO
            }
            
            pub.stateWillChange = false
        }
    }
    
    public func getProductImage(for pub: PubModel, with completion: ((PubModel)->())? = nil) {
        if pub.puctureUrl != nil {
            ImageHandler.imageFromServerURL(pub.puctureUrl!.absoluteString, circularShape: false) { (image) in
                pub.picture = image
                completion?(pub)
            }
        } else {
            storage.reference(withPath: pub.pictureId).downloadURL { (url, error) in
                pub.puctureUrl = url
                ImageHandler.imageFromServerURL(pub.puctureUrl!.absoluteString, circularShape: false) { (image) in
                    pub.picture = image
                    completion?(pub)
                }
            }
        }
    }
    
    private func uploadImage(img :UIImage,id: String, with completion: ((Bool)->())? = nil) {
        let data = img.jpegData(compressionQuality: 0.8)! as Data
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = self.storage.reference()
        storageRef.child(id).putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(false)
            }
            completion?(true)
        }
    }
}

