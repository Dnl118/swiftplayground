//
//  PlaceholderViewModel.swift
//  testedanilo
//
//  Created by mosyle on 27/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import  UIKit

class PlaceholderViewModel {
    
    func getImageURLArray(imageSize:CGSize = CGSize(width: 120, height: 120), length:Int) -> [ImagePlaceholder] {
        return (0...length)
            .compactMap {
                
                guard let url : URLComponents = URLComponents(string:"http://placehold.it/\(Int(imageSize.width))x\(Int(imageSize.height))&text=image\($0)") else {
                    return nil
                }
                
                return ImagePlaceholder(url: url)
        }
    }
    
}
