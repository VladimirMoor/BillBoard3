//
//  Post.swift
//  BillBoard3
//
//  Created by Vladimir on 15.05.2021.
//

import Foundation

enum Category: String {
    case transport = "Transport"
    case realEst = "Real estate"
    case clothes = "Clothes"
    case other = "Other"
}

struct Post: Hashable {
    let category: Category
    let title: String
    let subtitle: String
    let price: Int
    let img: String
    
    static func getData() -> [Post]{
        [Post(category: .transport, title: "Audi A-100", subtitle: "Sell my old car Audi, some little damages but condition is normal.", price: 2000, img: "audi"),
         Post(category: .realEst, title: "Big Vllage House", subtitle: "Sell new Big village house near London city, in beauty place. 300 sq meters, 5 rooms, garage, pool, helicopter square", price: 23000000, img: "village"),
         Post(category: .clothes, title: "Old Shoes", subtitle: "Sell my old shoes because I need money to eat but have no job. No one need iOS dev in this city, code for food.", price: 20, img: "shoes"),
         Post(category: .transport, title: "BMW X1", subtitle: "Sell my BMW, in perfect condition, top version with sunroof and climate control, winter tyres as free gift", price: 12000, img: "bmw"),
         Post(category: .other, title: "Finde a cat", subtitle: "Finde one small cat around one year old, gray color, big blue eyes.", price: 0, img: "empty")
        ]
    }
}
