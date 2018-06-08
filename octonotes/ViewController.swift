//
//  ViewController.swift
//  octonotes
//
//  Created by AJ Kueterman on 5/31/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import UIKit
import AuthenticationServices
import CoreData

@available(iOS 12.0, *)
class ViewController: UIViewController {
    
    var webAuthSession: ASWebAuthenticationSession?
    
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    @IBAction func getStarted(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "oauthToken") != nil {
            self.launchNewNote()
        } else {
            getAuthTokenWithWebLogin()
        }
    }
    
    @IBAction func dashboardButtonAction() {
        self.launchDashboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.string(forKey: "oauthToken") != nil {
            self.primaryButton.setTitle("New Note", for: .normal)
        } else {
            self.primaryButton.setTitle("Get Started with GitHub", for: .normal)
        }
    }
    
    @available(iOS 12.0, *)
    func getAuthTokenWithWebLogin() {
        
        let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=b8ec13ff8282fb430098")
        let callbackUrlScheme = "octonotes://auth"
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            
            UserDefaults.standard.set(oauthToken?.value, forKey: "oauthToken")

            self.launchNewNote()
        })
        
        self.webAuthSession?.start()
    }
    
    func launchNewNote() {
        present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextEntryViewController"), animated: true, completion: nil)
    }
    
    func launchDashboard() {
        present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController"), animated: true, completion: nil)
    }
    
}

