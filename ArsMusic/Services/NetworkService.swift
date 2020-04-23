//
//  NetworkService.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/21/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit
import Alamofire
class NetworkService {
    func fetchTracks(searchText: String, campetion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        let parameters = ["term":"\(searchText)",
                   "limit":"20",
                   "media":"music"]
               
               AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                campetion(nil)
                return
            }
            
            
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                campetion(objects)
                print("Onject: \(objects)")
            }catch let jsonError{
                campetion(nil)
                print("JsoneError: \(jsonError)")
            }
          //  let someString = String(data: data, encoding: .utf8)
            
        }
    }
    
}
