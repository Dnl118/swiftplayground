//
//  ImagePlaceholder.swift
//  testedanilo
//
//  Created by mosyle on 27/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

struct ImagePlaceholder {
    let url: URLComponents
    let text: String
    
    init(url: URLComponents) {
        self.url = url
        
        guard let queryItems : [URLQueryItem] = url.queryItems,
            let textQueryItem : URLQueryItem = queryItems.first(where: { $0.name == "text"}),
            let text : String = textQueryItem.value else {
            self.text = "Error"
            return
        }
        
        self.text = text
    }
}
