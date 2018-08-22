//
//  MainTableViewCell.swift
//  testedanilo
//
//  Created by mosyle on 13/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    func setCity(city: City) {
        cityLabel.text = city.toString()
    }
    
}
