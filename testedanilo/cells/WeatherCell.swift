//
//  WeatherCell.swift
//  testedanilo
//
//  Created by mosyle on 14/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var max: UILabel!
    @IBOutlet weak var earlyWeather: UILabel!
    @IBOutlet weak var morningWeather: UILabel!
    @IBOutlet weak var eveningWeather: UILabel!
    @IBOutlet weak var nightWeather: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var detailsStackView: UIStackView!
    
    let labelDecorator : LabelDecoratorProtocol = DecoratorFactory.getLabelDecorator()
    let tableDecorator : TableDecoratorProtocol = DecoratorFactory.getTableDecorator()

    func setWeather(weatherPresenter: WeatherPresenter) {
        date.text = weatherPresenter.getTextDate()
        min.text = weatherPresenter.getMinTemp()
        max.text = weatherPresenter.getMaxTemp()
        earlyWeather.text = weatherPresenter.getEarlyWeather()
        morningWeather.text = weatherPresenter.getMorningWeather()
        eveningWeather.text = weatherPresenter.getEveningWeather()
        nightWeather.text = weatherPresenter.getNightWeather()
        pressure.text = weatherPresenter.getPressure()
        humidity.text = weatherPresenter.getHumidity()
        
        labelDecorator.decorate(tableLabel: date)
        labelDecorator.decorate(tableLabel: min)
        labelDecorator.decorate(tableLabel: max)
        labelDecorator.decorate(tableLabel: earlyWeather)
        labelDecorator.decorate(tableLabel: morningWeather)
        labelDecorator.decorate(tableLabel: eveningWeather)
        labelDecorator.decorate(tableLabel: nightWeather)
        labelDecorator.decorate(tableLabel: pressure)
        labelDecorator.decorate(tableLabel: humidity)
        
        tableDecorator.decorate(tableCell: self)
        
        detailsStackView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        date.text = ""
        min.text = ""
        max.text = ""
        earlyWeather.text = ""
        morningWeather.text = ""
        eveningWeather.text = ""
        nightWeather.text = ""
        pressure.text = ""
        humidity.text = ""
        
        detailsStackView.isHidden = true
    }
    
}
