//
//  SettingViewCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    
    var didSwitch: (Bool)->() = {_ in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didSwitch(_ sender: Any) {
        guard let mySwitch = sender as? UISwitch else {return}
        didSwitch(mySwitch.isOn)
    }
    
    
    func populate(title: String){
        self.settingLabel.text = title
    }
    
    
}
