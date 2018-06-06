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
    
    @IBAction func getStarted(_ sender: Any) {
        getAuthTokenWithWebLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            
            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
            
            self.launchNewNote()
        })
        
        self.webAuthSession?.start()
    }
    
    func launchNewNote() {
        present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextEntryViewController"), animated: true, completion: nil)
    }
}

