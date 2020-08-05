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
    
    
    func showAlert(error msg: String, title: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.isSpringLoaded = true
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showReportAlest(handlerYes: @escaping ()->()) {
        let title = "Report"
        let msg = "Does this post have inappropriate content? Do you want to report it?"
          let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
          alert.isSpringLoaded = true
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                handlerYes()
            }))
                
                
          alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
}
