//
//  File.swift
//  testedanilo
//
//  Created by mosyle on 27/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import UIKit

class PlaceholderController : UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    
    let viewModel : PlaceholderViewModel = PlaceholderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Placeholders"
        
        
    }
}
