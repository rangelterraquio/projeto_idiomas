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
    @IBOutlet weak var learningButton: UIButton!
    @IBOutlet weak var teachingButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func TeachingFeedButton(_ sender: Any) {
        if section == .learningSection {
            teachingSelect()
            section = .teachingSection
        }
        setupButtons()
    }
    @IBAction func learningFeedButton(_ sender: Any) {
        if section == .teachingSection {
            learningSelect()
            section = .learningSection
        }
        setupButtons()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    func setupButtons(){
        if section == .learningSection{
//            / Define attributes
//            let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
//            let attributes :Dictionary = [NSFontAttributeName : labelFont]
//
//            // Create attributed string
//            var attrString = NSAttributedString(string: "Foo", attributes:attributes)
//            label.attributedText = attrString
            
//            let learningFont = UIFont.init(name: "SF Compact Display-Bold", size: 17)
//            let learningAttributes :Dictionary = [NSAttributedString.Key.font : learningFont]
//            learningButton.titleLabel?.attributedText = NSAttributedString(string: "Learning", attributes:learningAttributes as [NSAttributedString.Key : Any])
//
//            let teachingFont = UIFont.init(name: "SF Compact Display-Regular", size: 17)
//            let teachingAttributes :Dictionary = [NSAttributedString.Key.font : teachingFont]
//            teachingButton.titleLabel?.attributedText = NSAttributedString(string: "Teaching", attributes:teachingAttributes as [NSAttributedString.Key : Any])
//
//            let attrs = [NSAttributedString.Key.font : UIFont.init(name: "SF Compact Display Bold", size: 17)]
//            var boldString = NSMutableAttributedString(string: "Learning", attributes:attrs as [NSAttributedString.Key : Any])
//            learningButton.titleLabel?.attributedText = boldString
//            
//            
            
            teachingButton.backgroundColor = SectionColor.unhighlited.color
            learningButton.backgroundColor = SectionColor.learning.color
        }else{
            
//            let teachingFont = UIFont.init(name: "SF Compact Display-Bold", size: 17)
//            let teachingAttributes :Dictionary = [NSAttributedString.Key.font : teachingFont]
//            teachingButton.titleLabel?.attributedText = NSAttributedString(string: "Teaching", attributes:teachingAttributes as [NSAttributedString.Key : Any])
//            
//            let learningFont = UIFont.init(name: "SF Compact Display-Regular", size: 17)
//            let learningAttributes :Dictionary = [NSAttributedString.Key.font : learningFont]
//            learningButton.titleLabel?.attributedText = NSAttributedString(string: "Learning", attributes:learningAttributes as [NSAttributedString.Key : Any])
            
//            teachingButton.titleLabel?.font = UIFont.init(name: "SF Compact Display-Bold", size: 17)
//            learningButton.titleLabel?.font = UIFont.init(name: "SF Compact Display-Regular", size: 17)
            learningButton.backgroundColor = SectionColor.unhighlited.color
            teachingButton.backgroundColor = SectionColor.teaching.color
        }
    }
}


