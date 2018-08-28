//
//  UIImageExtensions.swift
//  testedanilo
//
//  Created by mosyle on 28/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension ImageView {
    
    func loadImage(url: URL) {
        self.kf.setImage(with: url)
    }
    
    func cancelKFDownload(){
        self.kf.cancelDownloadTask()
    }
    
}
