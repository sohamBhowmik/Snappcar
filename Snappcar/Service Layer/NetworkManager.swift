//
//  NetworkManager.swift
//  Snappcar
//
//  Created by Soham Bhowmik on 16/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    func fetchAvailableVehicles(fromUrl urlString: String, _ completionHandler:    @escaping (VehiclesList?, Error?)->()) -> () {
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseData(completionHandler: { (response) in
            
            switch response.result {
            case .success(let data) :
                do{
                    if let statusCode = response.response?.statusCode{
                        let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
                        if statusCode >= 200, statusCode < 300{
                            let availableVehicles = VehiclesList(json: responseJson as? [AnyHashable : Any])
                            completionHandler(availableVehicles, nil)
                        }
                        else{
                            let error = NSError(domain:"", code:(response.response?.statusCode) ?? -1, userInfo:nil)
                            completionHandler(nil,error)
                        }
                    }
                    
                }
                    
                catch {
                    let error = NSError(domain:"", code:(response.response?.statusCode) ?? -1, userInfo:nil)
                    completionHandler(nil,error)
                    
                }
                break
            case .failure(let error) :
                completionHandler(nil,error)
                break
            }
            
        })
        
        
    }
}
