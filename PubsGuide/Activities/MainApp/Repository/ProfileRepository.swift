//
//  ProfileRepository.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 22/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

enum FacebookLoginError: String {
    case generalError = "Something went wrong"
    case cancelled
}

class ProfileRepository {
    public var user: User
    public var profileImageUrl: String
    
    public static var shared = ProfileRepository()
    
    private init() {
        user = Auth.auth().currentUser!
        
        let facebookUserId = user.providerData[0].uid
        profileImageUrl =  "https://graph.facebook.com/" + facebookUserId + "/picture?height=500";
    }
    
    public func logout(with completion: ((Error?) -> ())? = nil) {
        do {
            try Auth.auth().signOut()
        } catch let err {
            completion?(err)
        }
        completion?(nil)
    }
    
    static func login(from vc: UIViewController, with completion: ((FacebookLoginError?) -> ())? = nil) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: vc) { (result, error) -> Void in
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                
                if (result?.isCancelled)!{
                    completion?(FacebookLoginError.cancelled)
                    return
                }
    
                if(fbloginresult.grantedPermissions.contains("email")) {
                    getFBUserData(with: completion)
                }
            } else {
                completion?(FacebookLoginError.generalError)
            }
        }
    }
    
    private static func getFBUserData(with completion: ((FacebookLoginError?) -> ())? = nil){
        if let token = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let _ = error {
                    completion?(FacebookLoginError.generalError)
                } else {
                    completion?(nil)
                }
            }
        } else {
            completion?(FacebookLoginError.generalError)
        }
    }
}
