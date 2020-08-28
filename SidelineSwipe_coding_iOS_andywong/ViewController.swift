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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    var items: [Item] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        apiCall({ items in
            self.items = items
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })
    }
    
    private func apiCall(_ completion: @escaping( ([Item]) -> Void)) {
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
                completion(items)
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
        self.view.backgroundColor = UIColor(named: "sidelineswap_color")
        
        self.navigationItem.titleView = searchBar

        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "item")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.backgroundColor = .clear
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(44 + UIApplication.shared.statusBarFrame.height)
            make.left.bottom.right.equalToSuperview()
        })
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.height/4 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ItemCollectionViewCell
        let item = items[indexPath.row]
        
        cell.configure(with: item)
        
        return cell
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
