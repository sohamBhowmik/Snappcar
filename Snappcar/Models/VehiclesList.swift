//
//  Vehicle.swift
//  Snappcar
//
//  Created by Soham Bhowmik on 16/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import Foundation


struct Vehicle
{
    let ci: String?
    let user: User?
    let car: Car?
    let flags: Flags?
    let priceInformation: PriceInfo?
}


struct VehiclesList
{
    let vehiclesList: [Vehicle]
    let totalResults:Int
    
    //Parse JSON
    init(json: [AnyHashable: Any]?) {
        if let jsonResponse = json
        {
            if let sums = jsonResponse["sums"] as? [AnyHashable: Any]
            {
                if let totalVehicles = sums["totalResults"] as? Int {
                    totalResults = totalVehicles
                }
                else{
                     totalResults = 1000
                }
            }
            else{
                totalResults = 1000
            }
            
            if let results = jsonResponse["results"] as? [[AnyHashable: Any]]
            {
                var availableVehicles: [Vehicle] = []
                for data in results {
                    autoreleasepool {
                        var vehicleCi: String?
                        var userInfo: User?
                        var userCarInfo: Car?
                        var priceInformation: PriceInfo?
                        var flags: Flags?
                        var firstName: String?
                        var imageURLString: String?
                        var streetName: String?
                        var cityName: String?
                        var fuelType: String?
                        var createdDate: String?
                        var year: Int?
                        var make: String?
                        var gear: String?
                        var bodyType: String?
                        var model: String?
                        var seats: Int?
                        var ownerId: String?
                        var reviewCount: Int?
                        var reviewAvg: Int?
                        var accessories: [String]?
                        var images: [String]?
                        var price: Float?
                        var pricePerKm: Float?
                        var freeKmsPerDay: Int?
                        var rentalDays: Int?
                        var isoCurrencyCode: String?
                        var isFavorite = false
                        var isNew = false
                        var isInstantBookable = false
                        var isPreviouslyRented = false
                        var isKeyless = false
                        
                        if let ci = data["ci"] as? String {
                            vehicleCi = ci
                        }
                        
                        if let userDetails = data["user"] as? [AnyHashable: Any]
                        {
                            if let fName = userDetails["firstName"] as? String {
                                firstName = fName
                            }
                            
                            if let imgString = userDetails["imageUrl"] as? String
                            {
                                imageURLString = imgString
                            }
                            
                            if let street = userDetails["street"] as? String
                            {
                                streetName = street
                            }
                            
                            if let city = userDetails["city"] as? String
                            {
                                cityName = city
                            }
                        }
                        
                        userInfo = User(firstName: firstName, imageUrl: imageURLString, street: streetName, city: cityName)
                        
                        if let carInfo = data["car"] as? [AnyHashable: Any]
                        {
                            if let fType = carInfo["fuelType"] as? String {
                                fuelType = fType
                            }
                            if let created = carInfo["createdAt"] as? String {
                                createdDate = created
                            }
                            if let yearOfCar = carInfo["year"] as? Int {
                                year = yearOfCar
                            }
                            if let carMake = carInfo["make"] as? String {
                                make = carMake
                            }
                            if let carGear = carInfo["gear"] as? String {
                                gear = carGear
                            }
                            if let carbBodyType = carInfo["bodyType"] as? String {
                                bodyType = carbBodyType
                            }
                            if let carModel = carInfo["model"] as? String {
                                model = carModel
                            }
                            if let noOfSeats = carInfo["seats"] as? Int {
                                seats = noOfSeats
                            }
                            if let carOwnerId = carInfo["ownerId"] as? String {
                                ownerId = carOwnerId
                            }
                            if let carReviewCount = carInfo["reviewCount"] as? Int {
                                reviewCount = carReviewCount
                            }
                            if let carReviewAvg = carInfo["reviewAvg"] as? Int {
                                reviewAvg = carReviewAvg
                            }
                            if let carAccessories = carInfo["accessories"] as? [String]
                            {
                                accessories = carAccessories
                            }
                            if let carImages = carInfo["images"] as? [String]
                            {
                                images = carImages
                            }
                        }
                        
                        userCarInfo = Car(fuelType: fuelType, createdAt: createdDate, year: year, make: make, gear: gear, bodyType: bodyType, model: model, seats: seats, ownerId: ownerId, reviewCount: reviewCount, accessories: accessories, images: images, reviewAvg: reviewAvg)
                        
                        if let priceData = data["priceInformation"] as? [AnyHashable: Any]
                        {
                            if let pricePerDay = priceData["price"] as? Float{
                                price = pricePerDay
                            }
                            if let pperKm = priceData["pricePerKilometer"] as? Float{
                                pricePerKm = pperKm
                            }
                            if let freeKms = priceData["freeKilometersPerDay"] as? Int{
                                freeKmsPerDay = freeKms
                            }
                            if let carRentalDays = priceData["rentalDays"] as? Int{
                                rentalDays = carRentalDays
                            }
                            if let currencyCode = priceData["isoCurrencyCode"] as? String{
                                isoCurrencyCode = currencyCode
                            }
                        }
                        
                        priceInformation = PriceInfo(price: price, pricePerKilometer: pricePerKm, freeKilometersPerDay: freeKmsPerDay, rentalDays: rentalDays, isoCurrencyCode: isoCurrencyCode)
                        
                        if let flagsData = data["flags"] as? [AnyHashable: Any]
                        {
                            if let isFav = flagsData["favorite"] as? Bool{
                                isFavorite = isFav
                            }
                            if let new = flagsData["new"] as? Bool{
                                isNew = new
                            }
                            if let instantBookable = flagsData["instantBookable"] as? Bool{
                                isInstantBookable = instantBookable
                            }
                            if let previouslyRented = flagsData["previouslyRented"] as? Bool{
                                isPreviouslyRented = previouslyRented
                            }
                            if let keyless = flagsData["isKeyless"] as? Bool{
                                isKeyless = keyless
                            }
                            flags = Flags(favorite: isFavorite, new: isNew, instantBookable: isInstantBookable, previouslyRented: isPreviouslyRented, isKeyless: isKeyless)
                        }
                        else{
                            flags = Flags(favorite: false, new: false, instantBookable: false, previouslyRented: false, isKeyless: false)
                        }
                        
                        let vehicle = Vehicle(ci: vehicleCi, user: userInfo, car: userCarInfo, flags: flags, priceInformation: priceInformation)
                        
                        availableVehicles.append(vehicle)
                    }
                }
                
                vehiclesList = availableVehicles
            }
            else{
                vehiclesList = []
            }
        }
        else{
            vehiclesList = []
            totalResults = 0
        }
    }
}











