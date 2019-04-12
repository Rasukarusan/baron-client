//
//  Cat.swift
//  BaronClient
//
//  Created by tanaka.naoto on 2019/03/29.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

// APIを叩いたら取得できるJSONの構造体
struct Cat : Codable {
    let cat_id: String
    let name: String
    let locale: Locale
}

// 猫の位置情報・時間が格納されたJSONの構造体
struct Locale : Codable {
    let eta : String
    let etd : String
    let x_grid : Int
    let y_grid : Int
    let next_x_grid : Int
    let next_y_grid : Int
}
