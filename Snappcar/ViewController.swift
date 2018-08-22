//
//  ViewController.swift
//  Snappcar
//
//  Created by Soham Bhowmik on 15/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation

class ViewController: UIViewController {

    let vehiclesViewModel = VehicleViewModel()
    
    let kVehicleListingCellReuseId = "VehicleListingCellReuseId"
    let kVehicleListingHEaderFooterViewReuseId = "VehicleListingHEaderFooterViewReuseId"
    let maxDistance = 50000
    
    lazy var locationManager = CLLocationManager()
    
    @IBOutlet weak var vehicleListTableView: UITableView!
    
    @IBOutlet weak var vehicleFilterHolderView: UIView!
    
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        vehiclesViewModel.fetchAvailableVehicles()
        
        vehiclesViewModel.availableVehiclesArray.bind { [unowned self] (availableVehiclesArray) in
            self.vehicleListTableView.reloadData()
        }
        
        vehiclesViewModel.isLoading.bind { [unowned self] (isLoading) in
            if isLoading{
                self.loaderView.isHidden = false
                self.loaderView.startAnimating()
            }else{
                self.loaderView.isHidden = true
                self.loaderView.stopAnimating()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI()
    {
        vehicleListTableView.register(UINib.init(nibName: "VehicleListingCell", bundle: nil), forCellReuseIdentifier: kVehicleListingCellReuseId)
        vehicleListTableView.separatorStyle = .none        
        let vehicleListingFilterView = Bundle.main.loadNibNamed("VehicleListingTableHeader", owner: self, options: nil)?.first as! VehicleListingTableHeader
        vehicleListingFilterView.translatesAutoresizingMaskIntoConstraints = false
        vehicleListingFilterView.delegate = self
        self.vehicleFilterHolderView.addSubview(vehicleListingFilterView)
        
        vehicleListingFilterView.topAnchor.constraint(equalTo: vehicleFilterHolderView.topAnchor).isActive = true
        vehicleListingFilterView.bottomAnchor.constraint(equalTo: vehicleFilterHolderView.bottomAnchor).isActive = true
        vehicleListingFilterView.leadingAnchor.constraint(equalTo: vehicleFilterHolderView.leadingAnchor).isActive = true
        vehicleListingFilterView.trailingAnchor.constraint(equalTo: vehicleFilterHolderView.trailingAnchor).isActive = true
        
        loaderView.layer.cornerRadius = 3.0
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    //TableView Datasource and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehiclesViewModel.availableVehiclesArray.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kVehicleListingCellReuseId, for: indexPath) as? VehicleListingCell {
            
            cell.carBodyType.text = vehiclesViewModel.bodyTypeOfCarAtIndex(index: indexPath.row)
            cell.pricePerDay.text = vehiclesViewModel.pricePerDayOfCarAtIndex(index: indexPath.row)
            cell.freeKilometers.text = vehiclesViewModel.freeKilometersOfCarAtIndex(index: indexPath.row)
            cell.totalNumberOfRatings.text = vehiclesViewModel.totalNumberOfRatingsOfCarArIndex(index: indexPath.row)
            cell.populateStarView(withRating: vehiclesViewModel.ratingOfCarArIndex(index: indexPath.row))
            
            if let ownerImageUrl = URL(string: vehiclesViewModel.ownerImageOfCarAtIndex(index: indexPath.row))
            {
                cell.ownerImageView.af_setImage(withURL: ownerImageUrl)
            }
            cell.datasource = self
            cell.indexPath = indexPath
            cell.carImageCollectionView.reloadData()
            return cell
        }
        else{
            return tableView.dequeueReusableCell(withIdentifier: kVehicleListingCellReuseId, for: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == vehiclesViewModel.availableVehiclesArray.value.count - 1 {
            //start incremental fetch
            vehiclesViewModel.fetchNextAvailableVehicles()
        }
    }
    
}

extension ViewController: VehicleListingCarImageDatasource
{
    //VehicleListingCarImage Datasource
    func vehicleListingCell(_ cell: VehicleListingCell, numberOfImagesOfVehicleAtIndex index: Int) -> Int
    {
        return vehiclesViewModel.numberOfImagesOfCarAtIndex(index: index)
    }
    
    func vehicleListingCell(_ cell: VehicleListingCell, imageUrlOfCarAtIndex index: Int, forIndexPath indexPath:IndexPath)->String?
    {
        return vehiclesViewModel.imageUrlOfCarAtIndex(index: index, forIndex: indexPath.row)
    }
}

extension ViewController: VehicleListingTableHeaderDelegate
{
    //VehicleListingTableHeader Delegates
    func vehicleListingTableHeader(_ vehicleListingTableHeader: VehicleListingTableHeader, didSelectCountry country: Country) {
        if country != .MyLocation {
            vehiclesViewModel.fetchAvailableVehicles(byCountry: country)
        }
        else{
            determineCurrentLocation()
        }
    }
    
    func vehicleListingTableHeader(_ vehicleListingTableHeader: VehicleListingTableHeader, didSelectSort sort: Sort) {
        vehiclesViewModel.fetchAvailableVehicles(sortedBy: sort)
    }
    
    func vehicleListingTableHeader(_ vehicleListingTableHeader: VehicleListingTableHeader, didSelectOrder order: Order) {
        vehiclesViewModel.fetchAvailableVehicles(orderedBy: order)
    }
    
    
}

extension ViewController: CLLocationManagerDelegate
{
    //CLLocationManager Delegates
    func determineCurrentLocation()
    {
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
            
        case .notDetermined:
            //display appropiate error
            break
            
        case .restricted:
            //error
            break
            
        case .denied:
            //error
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        vehiclesViewModel.fetchAvailableVehiclesFromLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, maximumDistance: maxDistance)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

