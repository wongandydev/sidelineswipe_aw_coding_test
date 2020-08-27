//
//  ViewController.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/25/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit
import SnapKit

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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
        
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

