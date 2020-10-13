//
//  DrinkDB.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/10/3.
//

import Foundation



struct DrinkDB:Codable{
    var drink:String
    var option:[DrinkOption]
}

struct DrinkOption:Codable {
    var drinkSize:String
    var price :Int
}
