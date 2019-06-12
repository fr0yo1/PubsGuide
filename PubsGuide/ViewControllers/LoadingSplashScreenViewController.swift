//
//  ViewController.swift
//  Pub'sGuide
//
//  Created by Adrian Sandru on 29/03/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import UIKit

class LoginSplashScreenViewController: UIViewController, Storyboarded {
    public weak var loginSplashScreenDelegate: LoginSplashScreenDelegate?

    @IBOutlet var splashScreenView: UIView!
    @IBAction func didPressLoginButton(_ sender: Any) {
        // TODO:
        self.loginSplashScreenDelegate?.didFinishLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

