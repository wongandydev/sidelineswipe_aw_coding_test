//
//  UIImageView+Extension.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/28/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        let imageCache = NSCache<NSString, UIImage>()
        
        

        
        // Check if image is cached
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = imageFromCache
                return
            }
            
        }
        
        //Add spinner
        
        let imageSpinner = UIActivityIndicatorView(style: .medium)
        imageSpinner.translatesAutoresizingMaskIntoConstraints = false
        imageSpinner.hidesWhenStopped = true
        
        self.addSubview(imageSpinner)
        imageSpinner.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        
        imageSpinner.startAnimating()

        // If image not in cache, get it then cache it
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
