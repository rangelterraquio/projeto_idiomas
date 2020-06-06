//
//  ActivityCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 04/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var onReuse: () -> () = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func populate(notif: Notifaction){
        self.msgLabel.text = notif.msg
        self.dateLabel.text = "\(notif.date)"
        if !notif.isViewed {
            self.backgroundColor = .lightGray
        }
    }
    func populateWith(image: UIImage){
        DispatchQueue.main.async {
            self.imageProfile.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageProfile.image = nil
        onReuse()
    }
}
