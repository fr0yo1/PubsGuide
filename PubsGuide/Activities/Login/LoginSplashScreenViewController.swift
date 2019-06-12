//
//  ViewController.swift
//  Pub'sGuide
//
//  Created by Adrian Sandru on 29/03/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit
import Firebase

class LoginSplashScreenViewController: UIViewController, Storyboarded {
    weak public var loginSplashScreenDelagete: LoginSplashScreenDelegate?
    
    @IBOutlet var splashScreenView: UIView!
    @IBAction func loginFacebookAction(sender: AnyObject) {
        loginWithFacebook()
    }
    
    private func loginWithFacebook() {
        ProfileRepository.login(from: self, with: { [weak self] facebookLoginError in
            if let err = facebookLoginError, let s = self {
                self?.handleLoginFailure(in: s, with: err)
                return
            }
            
             self?.loginSplashScreenDelagete?.didFinishLogin()
        })
    }
    
    private func handleLoginFailure(in vc: UIViewController,with error: FacebookLoginError) {
        var alert: UIAlertController
        
        switch error {
        case .generalError:
            alert = UIAlertController(title: "Error on authentication", message: error.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {[weak self] _ in self?.loginWithFacebook() }))
        default:
            return
        }
        
        vc.present(alert, animated: true)
    }
}

