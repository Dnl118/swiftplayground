//
//  BroseLocationController.swift
//  testedanilo
//
//  Created by mosyle on 22/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import UIKit
import WebKit

class BrowseLocationController : UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    var currentCity : City = City(id: 0, name: "Default City", country: "DC", lat: 0, lon: 0)
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("BrowseLocationController viewDidLoad()")
        
        webView.frame = view.bounds
        
        self.title = currentCity.getNameAndCountry()
        
        var urlComponents : URLComponents = URLComponents(string: "https://www.google.com/maps/search/")!
        //        urlComponents.scheme = "https"
        //        urlComponents.host = "google.com/maps/search/"
        
        urlComponents.queryItems = [URLQueryItem(name: "api", value: "1"),
                                    URLQueryItem(name: "query", value: "\(currentCity.lat),\(currentCity.lon)")]
        
        //        let myURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(currentCity.lat),\(currentCity.lon)")
        let myRequest = URLRequest(url: urlComponents.url!)
        webView.load(myRequest)
    }
}
