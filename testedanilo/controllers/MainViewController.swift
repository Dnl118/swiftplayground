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
    
    //refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action:
            #selector(MainViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        requestDataFromFakeService()
    }
    //refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cities"
        
        let browseButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(presentPlaceholders))
        
        self.navigationItem.rightBarButtonItem = browseButton
        
        table.tableFooterView = UIView()
        
        table.delegate = self
        table.dataSource = self
        
        searchBar.delegate = self
        
        requestDataFromDatabase()
        
        requestDataFromFakeService()
        
        table.addSubview(refreshControl)
    }
    
    func requestDataFromDatabase(){
        cities = viewModel.getCitiesFromDatabase()
        currentCities = cities
        
        print("from database: \(cities.count)")
    }
    
    func requestDataFromFakeService(){
        viewModel.getCitiesFromFakeService(completion: { cities in
            self.cities = cities
            self.currentCities = cities
            
            print("from service: \(cities.count)")
            DispatchQueue.main.async {
                self.table.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeCity(indexPath: indexPath)
        }
    }
    
    func removeCity(indexPath: IndexPath){
        let cityToDelete = currentCities[indexPath.row]
        
        presentConfirmDeleteAlert(cityToDelete: cityToDelete, indexPath: indexPath)
    }
    
    func presentConfirmDeleteAlert(cityToDelete: City, indexPath: IndexPath){
        let deleteAlert = UIAlertController(title: "Delete city", message: "Are you sure you want to delete \(cityToDelete.name)?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            self.viewModel.deleteCity(city: cityToDelete)
            
            self.currentCities.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .fade)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //nothing to do
        }))
        
        present(deleteAlert, animated: true, completion: nil)
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
    
    func present(city: City) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            return
        }
        
        controller.currentCity = city
        
        let nav = UINavigationController(rootViewController: controller)
        
        splitViewController?.showDetailViewController(nav, sender: self)
    }
    
    @objc func presentPlaceholders() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PlaceholderController") as? PlaceholderController else {
            return
        }
        
        let nav = UINavigationController(rootViewController: controller)
        
        splitViewController?.showDetailViewController(nav, sender: self)
    }
}
