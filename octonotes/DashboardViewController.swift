//
//  DashboardViewController.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/7/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    
    var authToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authToken = UserDefaults.standard.string(forKey: "oauthToken")
        
        // todo -> make network call with this token to get the profile
    }
}
