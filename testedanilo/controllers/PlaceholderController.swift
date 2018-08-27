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
    
    var placeholders : [ImagePlaceholder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Placeholders"
        
        collection.delegate = self
        collection.dataSource = self
        
        placeholders = viewModel.getImageURLArray(length: 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let placeholder: ImagePlaceholder = placeholders[indexPath.row]
        
        let cell: PlaceholderCell = collection.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCell
        
        cell.set(imagePlaceholder: placeholder)
        
        return cell
    }
}
