//
//  ViewController.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/25/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class ViewController: UIViewController {
    lazy var searchBar = UISearchBar(frame: .zero)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        apiCall({ items in
            
        })
    }
    
    private func apiCall(_ completion: @escaping( ([String]) -> Void)) {
        var items: [String] = []
        
        
        guard let apiURL = URL(string: "https://api.staging.sidelineswap.com/v1/facet_items?q=nike%20bag&page=1") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiURL , completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSON(data: data)
                let items = self.initItems(json: json["data"])
                print(items)
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
        
    }
    
    private func initItems(json: JSON) -> [Item] {
        let target = json.arrayValue.map({ (key) -> Item in
            return Item.init(fromJSON: key)
        })
        
        return target
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        self.navigationItem.titleView = searchBar

        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .red
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(44 + UIApplication.shared.statusBarFrame.height)
            make.left.bottom.right.equalToSuperview()
        })
    }

}


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
        guard let images = json.dictionary?.map({ (key, subJson) -> Images in
            return Images.init(fromJSON: [key: subJson])
        }) else {return [Images]() }

        return images
    }
    
    func initSeller(json: JSON) -> Seller {
        let seller = Seller.init(fromJSON: json)
        return seller
    }
}


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
