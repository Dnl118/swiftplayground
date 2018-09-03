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

    let labelDecorator : LabelDecoratorProtocol = DecoratorFactory.getLabelDecorator()
    let tableDecorator : TableDecoratorProtocol = DecoratorFactory.getTableDecorator()
    
    func setCity(city: City) {
        cityLabel.text = city.toString()
        labelDecorator.decorate(tableLabel: cityLabel)
        tableDecorator.decorate(tableCell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cityLabel.text = ""
    }
    
}
