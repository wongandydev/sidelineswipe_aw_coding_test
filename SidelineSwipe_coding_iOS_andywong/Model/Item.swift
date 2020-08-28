//
//  Item.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/28/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Item {
    var id: Int?
    var name: String?
    var price: Double?
    var list_price: Double?
    var url: String?
    var images: [Images]?
    var seller: Seller?

}

extension Item {
    enum Key: String {
        case id
        case name
        case price
        case list_price
        case url
        case images
        case seller
        
    }
    
    init(fromJSON json: JSON) {
        self.id = json["data"][Key.id.rawValue].int
        self.name = json[Key.name.rawValue].string
        self.price = json[Key.price.rawValue].double
        self.list_price = json[Key.list_price.rawValue].double
        self.url = json[Key.url.rawValue].string
                
                            
        let imagesJson = json[Key.images.rawValue]
        self.images = initImages(json: imagesJson)
                            
        let sellerJson = json[Key.seller.rawValue]
        self.seller = initSeller(json: sellerJson)

    }
    

    func initImages(json: JSON) -> [Images] {
       let images = json.arrayValue.map({ (key) -> Images in
            return Images.init(fromJSON: key)
        })

        return images
    }
    
    func initSeller(json: JSON) -> Seller {
        let seller = Seller.init(fromJSON: json)
        return seller
    }
}
