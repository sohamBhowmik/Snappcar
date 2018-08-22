//
//  VehicleViewModel.swift
//  Snappcar
//
//  Created by Soham Bhowmik on 16/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import Foundation

class VehicleViewModel {
    
    let limit = 10
    let endpoint = "https://api.snappcar.nl/v2/search/query"
    var availableVehiclesArray: Box<[Vehicle]> = Box([Vehicle]())
    var totalCount = 0
    var offset = 0
    var country = Country.NL
    var sort = Sort.Recommended
    var order = Order.Ascending
    var latitude: Double? = nil
    var longitude: Double? = nil
    var maximumDistance: Int? = nil
    var isLoading:Box<Bool> = Box(false)
    
    func fetchAvailableVehicles()
    {
        var urlString = endpoint + "?country=\(country.rawValue)&sort=\(sort.rawValue)&order=\(order.rawValue)&offset=\(offset)&limit=\(limit)"
        if latitude != nil, longitude != nil, maximumDistance != nil {
            urlString.append("&lat=\(latitude!)&lng=\(longitude!)&max-distance=\(maximumDistance!)")
        }
        isLoading.value = true
        NetworkManager.sharedManager.fetchAvailableVehicles(fromUrl: urlString) {
            [weak self] (vehicles, err) in
            guard let weakSelf = self else{ return }
            weakSelf.isLoading.value = false
            if err == nil{
                var updatedList = weakSelf.availableVehiclesArray.value
                if weakSelf.offset == 0
                {
                    updatedList.removeAll()
                }
                updatedList.append(contentsOf: vehicles?.vehiclesList ?? [])
                weakSelf.availableVehiclesArray.value = updatedList
                weakSelf.totalCount = vehicles?.totalResults ?? 0
            }else{
                //Display error as required
            }
        }
    }
    
    func fetchNextAvailableVehicles()
    {
        if availableVehiclesArray.value.count < totalCount{
            offset += 1
            fetchAvailableVehicles()
        }
    }
    
    func fetchAvailableVehicles(byCountry country: Country)
    {
        self.country = country
        offset = 0
        self.latitude = nil
        self.longitude = nil
        self.maximumDistance = nil
        fetchAvailableVehicles()
    }
    
    func fetchAvailableVehicles(sortedBy sort: Sort)
    {
        self.sort = sort
        offset = 0
        fetchAvailableVehicles()
    }
    
    func fetchAvailableVehicles(orderedBy order: Order)
    {
        self.order = order
        offset = 0
        fetchAvailableVehicles()
    }
    
    func fetchAvailableVehiclesFromLocation(latitude: Double, longitude: Double, maximumDistance: Int)
    {
        offset = 0
        self.latitude = latitude
        self.longitude = longitude
        self.maximumDistance = maximumDistance
        fetchAvailableVehicles()
    }
    
}

extension VehicleViewModel
{
    func bodyTypeOfCarAtIndex(index: Int) -> String?
    {
        let vehicle = availableVehiclesArray.value[index]
        return vehicle.car?.bodyType?.uppercased() ?? "NA"
    }
    
    func pricePerDayOfCarAtIndex(index: Int) -> String?
    {
        let vehicle = availableVehiclesArray.value[index]
        let price = vehicle.priceInformation?.price ?? 0
        if let isoCurrencyCode = vehicle.priceInformation?.isoCurrencyCode {
            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = isoCurrencyCode
            numberFormatter.numberStyle = .currency
            
            let priceString = numberFormatter.string(from: NSNumber(value: price))
            
            return priceString! + " per day"
        }
        else{
            return "€" + String(price) + " per day"
        }
    }
    
    func freeKilometersOfCarAtIndex(index: Int) -> String?
    {
        let vehicle = availableVehiclesArray.value[index]
        return String(vehicle.priceInformation?.freeKilometersPerDay ?? 0) + " Free Kms"
    }
    
    func totalNumberOfRatingsOfCarArIndex(index: Int) -> String{
        let vehicle = availableVehiclesArray.value[index]
        return String(vehicle.car?.reviewCount ?? 0)
    }
    
    func ratingOfCarArIndex(index: Int) -> Int{
        let vehicle = availableVehiclesArray.value[index]
        return vehicle.car?.reviewAvg ?? 0
    }
    
    func ownerImageOfCarAtIndex(index: Int) -> String
    {
        let vehicle = availableVehiclesArray.value[index]
        return vehicle.user?.imageUrl ?? ""
    }
    
    func numberOfImagesOfCarAtIndex(index: Int) -> Int
    {
        let vehicle = availableVehiclesArray.value[index]
        return vehicle.car?.images?.count ?? 0
    }
    
    func imageUrlOfCarAtIndex(index: Int, forIndex:Int) -> String?
    {
        let vehicle = availableVehiclesArray.value[forIndex]
        if let car = vehicle.car, let images = car.images{
            if images.count > index{
                return images[index]
            }
        }
        return nil
    }
}
