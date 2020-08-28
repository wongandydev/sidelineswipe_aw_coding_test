//
//  Seller.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/28/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import SwiftyJSON


struct Seller {
    var id: Int?
    var username: String?
}

extension Seller {
    enum Key: String {
        case id
        case username
    }
    
    
    init(fromJSON json: JSON) {
        
        self.id = json[Key.id.rawValue].int
        self.username = json[Key.username.rawValue].string
    }
}

