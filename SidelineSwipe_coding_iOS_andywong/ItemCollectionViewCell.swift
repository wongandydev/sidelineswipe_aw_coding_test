//
//  ItemCollectionViewCell.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/28/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    private var itemNameText: String = "Item Text" {
        didSet {
            itemNameLabel.text = itemNameText
        }
    }
    
    private var sellerLabelText: String = "Seller Username" {
        didSet {
            sellerLabel.text = sellerLabelText
        }
    }
    
    private var priceLabelText: String = "0" {
        didSet {
            priceLabel.text = "$\(priceLabelText)"
        }
    }

    
    private var imageView = UIImageView()
    private var itemNameLabel = UILabel()
    private var sellerLabel = UILabel()
    private var priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        setup()
    }
    
    func configure(with item: Item) {
        if let thumbnailImageURLString = item.images?.first?.thumb_url {
            if let thumbnailImageURL = URL(string: thumbnailImageURLString) {
                imageView.load(url: thumbnailImageURL)
            }
        }
        
        if let itemName = item.name { itemNameText = itemName }
        if let sellerUsername = item.seller?.username { self.sellerLabelText = sellerUsername }
        if let price = item.price { priceLabelText = String(Int(price)) }
    }
    
    
    fileprivate func setup() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        // imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
                
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints({ make in
            make.top.right.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
        })
        
        // itemNameText
        
        itemNameLabel.text = itemNameText
        itemNameLabel.textColor = .black
        
        self.contentView.addSubview(itemNameLabel)
        itemNameLabel.snp.makeConstraints({ make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.right.left.equalToSuperview().inset(10)
        })
        
        // sellerLabel
        
        sellerLabel.text = sellerLabelText
        sellerLabel.textColor = .gray
        
        self.contentView.addSubview(sellerLabel)
        sellerLabel.snp.makeConstraints({ make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(10)
            make.right.left.equalToSuperview().inset(10)
        })
        
        priceLabel.text = priceLabelText
        priceLabel.textColor = .white
        priceLabel.layer.zPosition = 1
        
        self.imageView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ make in
            make.bottom.right.equalToSuperview().inset(10)
        })
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        
        self.imageView.addSubview(blurView)
        blurView.snp.makeConstraints({ make in
            make.edges.equalTo(priceLabel)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

