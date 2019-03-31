//
//  APIClient.swift
//  BaronClient
//
//  Created by tanaka.naoto on 2019/03/29.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    /**
     * 猫の情報を取得
     */
    static func getCat(completion:@escaping (Cat)->Void){
        let url:String = Endpoint.root.rawValue + Endpoint.getCat.rawValue
        Alamofire.request(url, method: .get).response{response in
            if let jsonData = response.data {
                let cat = try? JSONDecoder().decode(Cat.self, from: jsonData)
                completion(cat!)
            }
        }
    }
}
