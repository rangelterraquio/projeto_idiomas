//
//  LanguageCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 09/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var languagetext: UILabel!
    @IBOutlet weak var isSelectedView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.backgroundColor = .systemBlue
        }else{
            self.backgroundColor = .white
        }
         isSelectedView.isHidden = !selected
    }
    
    func populeCell(with language: Languages){
        flagImageView.image = UIImage(named: language.name)
        languagetext.text = language.name
    }
    
}