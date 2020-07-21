//
//  UserCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    static let notificationName = "informationHasChanged"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        imageProfile.layer.cornerRadius = 90
        imageProfile.layer.masksToBounds = true
        imageProfile.contentMode = .scaleAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: NSNotification.Name(rawValue: UserCell.notificationName), object: nil)
        
        
        loadIndicator.startAnimating()
        loadIndicator.hidesWhenStopped = true
        
    }

    
    @objc func onNotification(notification:Notification){
        
        if let image = notification.userInfo?["image"] as? UIImage{
            imageProfile.image = image
        }else{
            if let name = notification.userInfo?["name"] as? String{
                nameLabel.text = name
            }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(name: String, image: UIImage){
          self.nameLabel.text = name
          self.imageProfile.image = image
          self.loadIndicator.stopAnimating()
      }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
