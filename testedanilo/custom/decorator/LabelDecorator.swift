//
//  LabelProtocol.swift
//  testedanilo
//
//  Created by mosyle on 03/09/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import UIKit

struct LabelDecorator {
    let colors = MyColors()
}

extension LabelDecorator : LabelDecoratorProtocol {
    
    func decorate(label: UILabel) {
        label.textColor = colors.labelColor.text
    }
    
    func decorate(tableLabel: UILabel) {
        tableLabel.textColor = colors.labelColor.tableText
    }
    
}
