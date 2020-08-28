//
//  Spinner.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/28/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit


open class Spinner {
    internal static var blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    internal static var spinner: UIActivityIndicatorView?

    public static var spinnerStyle: UIActivityIndicatorView.Style = .white
    public static var backgroundColor: UIColor = UIColor.black //.withAlphaComponent(0.8)
    public static var color: UIColor = .white

    public static func start(view: UIView) {
        
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            blurView.layer.cornerRadius = 10
            blurView.layer.borderWidth = 0
            blurView.clipsToBounds = true
            
            window.addSubview(blurView)
            blurView.snp.makeConstraints({ make in
                make.center.equalToSuperview()
                make.width.height.equalTo(60)
            })
            
            spinner = UIActivityIndicatorView(frame: .zero)
            spinner?.backgroundColor = backgroundColor
            spinner?.style = spinnerStyle
            spinner?.color = color
            spinner?.startAnimating()
            spinner?.center = blurView.contentView.center
            
            blurView.contentView.addSubview(spinner!)
            spinner?.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
        
    }
    
    public static func stop() {
        if spinner != nil {
            DispatchQueue.main.async {
                spinner?.stopAnimating()
                spinner?.removeFromSuperview()
                blurView.removeFromSuperview()
                spinner = nil
            }

        }
    }
}

