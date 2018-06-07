//
//  GitHubProfileViewController.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/6/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation
import UIKit

class GitHubProfileViewController: UIViewController{
    
    var authToken: String?
    
    @IBOutlet weak var testArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authToken = UserDefaults.standard.string(forKey: "oauthToken")
        self.testArea.text = self.authToken
        
        // todo -> make network call with this token
    }
}
