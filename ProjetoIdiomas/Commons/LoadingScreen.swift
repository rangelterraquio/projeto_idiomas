//
//  LoadingScreen.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 16/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class LoadingScreen: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        let image = UIImage(named: "icon")!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = CGPoint(x: self.center.x, y: self.center.y - 100)
        activityIndicator.center = self.center

        self.addSubview(imageView)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
