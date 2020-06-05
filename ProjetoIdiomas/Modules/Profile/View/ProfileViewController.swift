//
//  ProfileViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    
    var user: User!
    var imageProfile: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellXib = UINib.init(nibName: "UserCell", bundle: nil)
        let optionCell = UINib.init(nibName: "OptionCell", bundle: nil)
        profileTableView.register(optionCell, forCellReuseIdentifier: "OptionCell")
        profileTableView.register(cellXib, forCellReuseIdentifier: "UserCell")
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }


}


//MARK: -> TableView

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupoTableView(index: indexPath.row)
    }
    
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return  245
        }else{
            return 80
        }
     }
    
    
    func setupoTableView( index: Int)-> UITableViewCell{
        
        switch index {
        case 0:
            let cell = UserCell()
            cell.imageProfile.image = imageProfile
            cell.nameLabel.text = user.name
            return cell
        case 2:
            let cell = OptionCell()
            cell.imageOption.image = UIImage(named: "dasdad")
            cell.titleLabel.text = "About me"
            return cell
        case 3:
             let cell = OptionCell()
             cell.imageOption.image = UIImage(named: "dasdad")
             cell.titleLabel.text = "My Activities"
             return cell
        case 4:
            let cell = OptionCell()
            cell.imageOption.image = UIImage(named: "dasdad")
            cell.titleLabel.text = "Settings"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
