//
//  ViewController.swift
//  octonotes
//
//  Created by AJ Kueterman on 5/31/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

class ViewController: UIViewController {
    
    var authSession: SFAuthenticationSession?
    
    @IBAction func getStarted(_ sender: Any) {
        // Let's authenticate with GitHub
        getAuthToken()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getAuthToken() {
        
        //OAuth Provider URL
        let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=b8ec13ff8282fb430098")
        let callbackUrlScheme = "https://ajkueterman.com/octonote/auth/"
        
        //Initialize auth session
        self.authSession = SFAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme,
                                                        completionHandler: { (callBack:URL?, error:Error?) in
            
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "oauth_token"}).first
            
            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
        })
            
        //Kick it off
        self.authSession?.start()
    }
}

