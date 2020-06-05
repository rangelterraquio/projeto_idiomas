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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(name: String, image: UIImage){
          self.nameLabel.text = name
          self.imageProfile.image = image
      }
}
