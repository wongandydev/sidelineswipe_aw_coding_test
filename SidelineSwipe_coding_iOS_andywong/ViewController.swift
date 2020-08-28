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
    
    var searchTerm = "nike" {
        didSet {
            page = 1 // reset page number
            print(searchTerm)
        }
    }
    
    var page = 1
    
    
    var items: [Item] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        Spinner.start(view: self.view)
        apiCall({ items in
            self.items = items
            
            DispatchQueue.main.async {
                Spinner.stop()
                self.collectionView.reloadData()
            }
            
        })
    }
    
    private func search() {
        apiCall({ items in
            self.items = items
            
            DispatchQueue.main.async {
                Spinner.stop()
                self.collectionView.reloadData()
            }
            
        })
    }
    
    private func addPage() {
        page += 1
        apiCall({ newItems in
            if !newItems.isEmpty {
                DispatchQueue.main.async {
                    self.items.append(contentsOf: newItems)
                    let newIndexPath = IndexPath(item: self.collectionView.numberOfItems(inSection: 0), section: 0)
                    self.collectionView.insertItems(at: [newIndexPath])
                }
            }
        })
    }
    
    private func apiCall(_ completion: @escaping( ([Item]) -> Void)) {
        guard let apiURL = URL(string: "https://api.staging.sidelineswap.com/v1/facet_items?q=\(searchTerm)%20bag&page=\(page)") else {
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

        
        //MARK: SearchBar
        
        searchBar.placeholder = "Search for items on sale"
        searchBar.delegate = self
        searchBar.tintColor = UIColor(named: "sidelineswap_color")
        
        //MARK: CollectionView
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == items.count - 4 ) {
            addPage()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = searchBar.text ?? ""
        search()
        searchBar.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchBar.text ?? ""
        search()
        Spinner.start(view: self.view)
    }
}


extension UIImageView {
    func load(url: URL) {        
        let imageCache = NSCache<NSString, UIImage>()
        
        //Add spinner
        
        let imageSpinner = UIActivityIndicatorView(style: .white)
        imageSpinner.translatesAutoresizingMaskIntoConstraints = false
        imageSpinner.hidesWhenStopped = true
        
        self.addSubview(imageSpinner)
        imageSpinner.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        imageSpinner.startAnimating()
        
        
        
        

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = imageFromCache
                imageSpinner.stopAnimating()
                return
            }
            
        }

        // image does not available in cache.. so retrieving it from url...
        DispatchQueue.main.async { [weak self] in
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self?.image = image
                    imageSpinner.stopAnimating()
                    imageCache.setObject(image, forKey: (url.absoluteString as NSString))
                }
            }
        }
    }
}
