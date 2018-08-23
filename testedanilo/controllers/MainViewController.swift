//
//  MainTableViewController.swift
//  testedanilo
//
//  Created by mosyle on 13/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    //UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var currentCities : [City] = []
    var cities: [City] = []
    
    let viewModel : MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cities"
        
        table.tableFooterView = UIView()
        
        table.delegate = self
        table.dataSource = self
        
        searchBar.delegate = self
        
        cities = viewModel.getCitiesFromDatabase()
        currentCities = cities
        
        print("from database: \(cities.count)")

        viewModel.getCitiesFromFakeService(completion: { cities in
            self.cities = cities
            self.currentCities = cities

            print("from service: \(cities.count)")
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        })
//        viewModel.deleteAll()
//        viewModel.save(citiesModel: cities)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city: City = currentCities[indexPath.row]
        
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! MainTableViewCell
        
        cell.setCity(city: city)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(city: currentCities[indexPath.row])
    }
    
    func present(city: City) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            return
        }
        
        controller.currentCity = city
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentCities = cities
            table.reloadData()
            return
        }
        
        currentCities = cities.filter { (city) -> Bool in
            city.name.contains(searchText)
        }
        
        table.reloadData()
    }

}
