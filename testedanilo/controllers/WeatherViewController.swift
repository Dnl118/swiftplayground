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
    
    @IBOutlet weak var containerView: UIView!
    
    let viewModel : WeatherTableViewModel = WeatherTableViewModel()
    
    var weatherArray : [Weather] = []
    
    var weatherPresenterArray : [WeatherPresenter] = []
    
    var currentCity : City = City(id: 0, name: "Default City", country: "DC", lat: 0, lon: 0)
    
    var isShowingDetail = false
    
    let decorator : LabelDecoratorProtocol = DecoratorFactory.getLabelDecorator()
    
    //refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action:
            #selector(WeatherViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        requestDataFromServer()
    }
    //refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Weather"
        
        cityName.text = currentCity.toString()
        decorator.decorate(labelTitle: cityName)
        
        let mapFullButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(browseLocationFullScreen))
        
        let mapDetailButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showLocationDetail))
        
        self.navigationItem.rightBarButtonItems = [mapFullButton, mapDetailButton]
        
        viewModel.getWeathersFromDatabase(cityID: currentCity.id, completion: { array in
            self.weatherPresenterArray = array

            DispatchQueue.main.async {
                self.weatherTable.reloadData()
            }
        })
        
        requestDataFromServer()

        self.containerView.isHidden = true
        
        browseLocationDetail()
        
        weatherTable.estimatedRowHeight = 200
        weatherTable.rowHeight = UITableViewAutomaticDimension
        weatherTable.addSubview(refreshControl)
    }
    
    func requestDataFromServer(){
        viewModel.getWeathersFromService(cityID: currentCity.id, completion: { array in
            self.weatherPresenterArray = array
            
            DispatchQueue.main.async {
                self.weatherTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @objc func browseLocationFullScreen(){
    
        guard let controller : BrowseLocationController = presentLocation(city: currentCity) else {
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showLocationDetail(){
        isShowingDetail = !isShowingDetail
        
        UIView.animate(withDuration: 0.3) {
            if self.isShowingDetail {
                self.containerView.isHidden = false
            } else {
                self.containerView.isHidden = true
            }
            
            self.view.layoutIfNeeded()
        }

    }
    
    func browseLocationDetail() {
        guard let controller : BrowseLocationController = presentLocation(city: currentCity) else {
            return
        }
        
        self.containerView.subviews.forEach { $0.removeFromSuperview() }
        
        self.containerView.addSubview(controller.view)
        self.addChildViewController(controller)
        
        controller.view.frame = containerView.bounds
        controller.view.autoresizingMask =  [ .flexibleHeight, .flexibleWidth ]
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
    
    func presentLocation(city: City) -> BrowseLocationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "BrowseLocationController") as? BrowseLocationController else {
            return nil
        }

        controller.currentCity = currentCity
        return controller
    }

}
