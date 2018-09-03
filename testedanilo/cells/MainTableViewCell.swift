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

    let decorator : LabelDecoratorProtocol = DecoratorFactory.getLabelDecorator()
    
    func setCity(city: City) {
        cityLabel.text = city.toString()
        decorator.decorate(tableLabel: cityLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cityLabel.text = ""
    }
    
}
