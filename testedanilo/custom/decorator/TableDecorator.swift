//
//  TableDecorator.swift
//  testedanilo
//
//  Created by mosyle on 03/09/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import UIKit

struct TableDecorator {
    
    let colors = MyColors()
    
}

extension TableDecorator : TableDecoratorProtocol {

    func decorate(tableCell: UITableViewCell) {
        tableCell.backgroundColor = colors.tableColor.background
    }

}
