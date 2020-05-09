//
//  FilterCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    var teachingSelect: () -> () = {}
    var section: SectionSelected = .teachingSection
    var learningSelect: () -> () = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func TeachingFeedButton(_ sender: Any) {
        if section == .teachingSection {
            teachingSelect()
            section = .teachingSection
        }
    }
    @IBAction func learningFeedButton(_ sender: Any) {
        if section == .learningSection {
            learningSelect()
            section = .learningSection
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
}
