//
//  Order.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/10/3.
//

import Foundation


struct Order:Codable{
    var id :String
    var item: String
    var name: String
    var drinkSize: DrinkSize
    var sweetness:SweetLevel
    var ice: Ice
    var defaultPrice:Int
    var fixedPrice:Int
    var imageIndex:String
}


enum DrinkSize: String, Codable {
    case medium = "中杯"
    case mediumBubble = "中杯 + 珍珠"
    case big = "大杯"
    case bigBubble = "大杯 + 珍珠"
}


enum SweetLevel: String, Codable {
    case none = "無糖"
    case quarter = "微糖"
    case half = "半糖"
    case threeFour = "少糖"
    case full = "全糖"
}


enum Ice: String, Codable {
    case none = "去冰"
    case light = "少冰"
    case full = "正常"
    case hot = "熱飲"
}
