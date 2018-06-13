//
//  RequestManager.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/12/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation

class RequestManager {
    
    let callbackUrlScheme = "octonotes://auth"
    let state = "octonotes_state_id"
    
    let clientId = "?client_id=b8ec13ff8282fb430098"
    let clientSecret = "&client_secret=4fb1d8d09410a44ae8264c224d2dc6620e7ba3a4"
    
    func getWebAuthUrl() -> URL? {
        return URL(string: "https://github.com/login/oauth/authorize?scope=gist%20repo%20read:user&client_id=b8ec13ff8282fb430098&state=\(state)")
    }
    
    func getAuthRequest(code: URLQueryItem?) -> URLRequest {
        let oauthParam = "&code=\(code?.value ?? "")"
        let getTokenPostUrl = URL(string: "https://github.com/login/oauth/access_token\(clientId)\(clientSecret)\(oauthParam)")
        var oauthRequest = URLRequest(url: getTokenPostUrl!)
        oauthRequest.httpMethod = "POST"
        oauthRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return oauthRequest
    }
    
    func getNewGistRequest(gistPost: GistPost) throws -> URLRequest {
        
        let token = UserDefaults.standard.string(forKey: "oauthToken")
        var request = URLRequest(url: URL(string: "https://api.github.com/gists?access_token=\(token ?? "")")!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let gistPost = gistPost
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(gistPost)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } catch {
            throw error
        }

        return request
    }
}
