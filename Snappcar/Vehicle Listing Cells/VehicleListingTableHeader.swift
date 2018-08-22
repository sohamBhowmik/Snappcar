//
//  VehicleListingTableHeader.swift
//  Snappcar
//
//  Created by Soham Bhowmik on 19/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit
protocol VehicleListingTableHeaderDelegate: class {
    func vehicleListingTableHeader(_ vehicleListingTableHeader:VehicleListingTableHeader, didSelectCountry country:Country)
    func vehicleListingTableHeader(_ vehicleListingTableHeader:VehicleListingTableHeader, didSelectSort sort:Sort)
    func vehicleListingTableHeader(_ vehicleListingTableHeader:VehicleListingTableHeader, didSelectOrder order:Order)

}

class VehicleListingTableHeader: UIView {

    @IBOutlet weak var countrySegment: UISegmentedControl!
    
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    @IBOutlet weak var orderSegment: UISegmentedControl!

    weak var delegate:VehicleListingTableHeaderDelegate? = nil
    
    @IBAction func countrySelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.vehicleListingTableHeader(self, didSelectCountry: .NL)
            break
        case 1:
            delegate?.vehicleListingTableHeader(self, didSelectCountry: .DE)
            break
        case 2:
            delegate?.vehicleListingTableHeader(self, didSelectCountry: .DK)
            break
        case 3:
            delegate?.vehicleListingTableHeader(self, didSelectCountry: .SE)
            break
        case 4:
            delegate?.vehicleListingTableHeader(self, didSelectCountry: .MyLocation)
            break
        default:
            break
        }
    }
    
    @IBAction func sortSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.vehicleListingTableHeader(self, didSelectSort: .Recommended)
            break
        case 1:
            delegate?.vehicleListingTableHeader(self, didSelectSort: .Price)
            break
        case 2:
            delegate?.vehicleListingTableHeader(self, didSelectSort: .Distance)
            break
        default:
            break
        }
    }
    
    @IBAction func sortOrderSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.vehicleListingTableHeader(self, didSelectOrder: .Ascending)
            break
        case 1:
            delegate?.vehicleListingTableHeader(self, didSelectOrder: .Descending)
            break
        default:
            break
        }
    }
    

}
