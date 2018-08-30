//
//  BroseLocationController.swift
//  testedanilo
//
//  Created by mosyle on 22/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import UIKit
import WebKit

class BrowseLocationController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    var currentCity : City = City(id: 0, name: "Default City", country: "DC", lat: 0, lon: 0)
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.autoresizingMask =  [ .flexibleHeight, .flexibleWidth ]
        
        view.addSubview(activityIndicator)
        view.bringSubview(toFront: activityIndicator)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        activityIndicator.autoresizingMask = [ .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleBottomMargin ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = view.bounds
        
        self.title = currentCity.getNameAndCountry()
        
        var urlComponents : URLComponents = URLComponents(string: "https://www.google.com/maps/search/")!
        
        urlComponents.queryItems = [URLQueryItem(name: "api", value: "1"),
                                    URLQueryItem(name: "query", value: "\(currentCity.lat),\(currentCity.lon)")]
        
        //        urlComponents.scheme = "https"
        //        urlComponents.host = "google.com/maps/search/"
        //        let myURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(currentCity.lat),\(currentCity.lon)")
        
        let myRequest = URLRequest(url: urlComponents.url!)
        webView.load(myRequest)
        
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Before: \(self.view.frame)")
        
        coordinator.animate(alongsideTransition: { (context) in
            print("During: \(self.view.frame)")
        }) { (context) in
            print("After: \(self.view.frame)")
            
            UIView.animate(withDuration: 0.2) {
                self.activityIndicator.center = self.view.center
            }
        }
    }
}
