//
//  Extension-UIViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    
    func showAlertError(error msg: String, title: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.isSpringLoaded = true
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
