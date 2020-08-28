//
//  Images.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/28/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import SwiftyJSON

struct Images {
    var id: Int?
    var thumb_url: String?
    var large_url: String?
}

extension Images {
    enum Key: String {
        case id
        case thumb_url
        case large_url
    }
    
    
    init(fromJSON json: JSON) {
        
        self.id = json[Key.id.rawValue].int
        
        self.thumb_url = json[Key.thumb_url.rawValue].string
        self.large_url = json[Key.large_url.rawValue].string
    }
}
