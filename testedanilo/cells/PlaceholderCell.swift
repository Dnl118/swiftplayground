//
//  PlaceholderCell.swift
//  testedanilo
//
//  Created by mosyle on 27/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class PlaceholderCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    
    func set(imagePlaceholder: ImagePlaceholder) {
        print(imagePlaceholder.url)
        image.kf.setImage(with: imagePlaceholder.url)
        text.text = imagePlaceholder.text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image.kf.cancelDownloadTask()
        text.text = "Reuse"
    }
}
