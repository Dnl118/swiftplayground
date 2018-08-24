//
//  WeatherViewViewController.swift
//  testedanilo
//
//  Created by mosyle on 14/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherTable: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    let viewModel : WeatherTableViewModel = WeatherTableViewModel()
    
    var weatherArray : [Weather] = []
    
    var weatherPresenterArray : [WeatherPresenter] = []
    
    var currentCity : City = City(id: 0, name: "Default City", country: "DC", lat: 0, lon: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Weather"
        
        cityName.text = currentCity.toString()
        
        let browseButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(browseLocationAction))
        
        self.navigationItem.rightBarButtonItem = browseButton
        
        viewModel.getWeathersFromDatabase(cityID: currentCity.id, completion: { array in
            self.weatherPresenterArray = array

            DispatchQueue.main.async {
//                print("from database size: \(self.weatherPresenterArray.count)")
                self.weatherTable.reloadData()
            }
        })
        
        viewModel.getWeathersFromService(cityID: currentCity.id, completion: { array in
            self.weatherPresenterArray = array

            DispatchQueue.main.async {
//                print("from service size: \(self.weatherPresenterArray.count)")
                self.weatherTable.reloadData()
            }
        })
        
        self.weatherTable.estimatedRowHeight = 200
        self.weatherTable.rowHeight = UITableViewAutomaticDimension
    }
    
    @objc func browseLocationAction(){
        presentLocation(city: currentCity)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherPresenterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WeatherCell = tableView.dequeueReusableCell(withIdentifier: "weather_cell", for: indexPath) as! WeatherCell
        
        cell.setWeather(weatherPresenter: weatherPresenterArray[indexPath.row])
        
        if weatherPresenterArray[indexPath.row].showDeatails {
            cell.detailsStackView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isDetailsOpen : Bool = weatherPresenterArray[indexPath.row].showDeatails
        
        weatherPresenterArray[indexPath.row].showDeatails = !isDetailsOpen
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func presentLocation(city: City) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "BrowseLocationController") as? BrowseLocationController else {
            return
        }
        
        controller.currentCity = currentCity
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
