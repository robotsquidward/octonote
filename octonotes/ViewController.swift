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
        if false {
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
        if false {
            self.primaryButton.setTitle("New Note", for: .normal)
            self.secondaryButton.isHidden = false
        } else {
            self.primaryButton.setTitle("Get Started with GitHub", for: .normal)
            self.secondaryButton.isHidden = true
        }
    }
    
    @available(iOS 12.0, *)
    func getAuthTokenWithWebLogin() {
        
        let state = "todo-create-an-unguessable-random-string"
        let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=b8ec13ff8282fb430098&state=\(state)")
        let callbackUrlScheme = "octonotes://auth"
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            
            let oauthCode = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            let stateReturned = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "state"}).first
            
            if state == stateReturned?.value {
                self.getAuthToken(code: oauthCode)
            }
        })
        
        self.webAuthSession?.start()
    }
    
    func getAuthToken(code: URLQueryItem?) {
        // make network call to get actual token
        let clientId = "?client_id=b8ec13ff8282fb430098"
        let clientSecret = "&client_secret=4fb1d8d09410a44ae8264c224d2dc6620e7ba3a4"
        let oauthParam = "&code=\(code?.value ?? "")"
        let getTokenPostUrl = URL(string: "https://github.com/login/oauth/access_token\(clientId)\(clientSecret)\(oauthParam)")
        var oauthRequest = URLRequest(url: getTokenPostUrl!)
        oauthRequest.httpMethod = "POST"
        oauthRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: oauthRequest, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) as String? {
                guard let url = URLComponents(string: "?\(postString)") else { return }
                let oauthTokenResponse = url.queryItems?.first(where: { $0.name == "access_token" })?.value
                
                UserDefaults.standard.set(oauthTokenResponse, forKey: "oauthToken")
                
                self.launchNewNote()
                
            }
            
        }).resume()
    }
    
    func launchNewNote() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextEntryViewController"), animated: true, completion: nil)
        }
    }
    
    func launchDashboard() {
        present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController"), animated: true, completion: nil)
    }
    
}

