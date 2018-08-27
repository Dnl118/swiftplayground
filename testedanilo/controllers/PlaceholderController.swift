//
//  File.swift
//  testedanilo
//
//  Created by mosyle on 27/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import UIKit

class PlaceholderController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collection: UICollectionView!
    
    let viewModel : PlaceholderViewModel = PlaceholderViewModel()
    
    let placeholders : [ImagePlaceholder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Placeholders"
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
