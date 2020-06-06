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
    var presenter: ProfileViewToPresenter? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellXib = UINib.init(nibName: "UserCell", bundle: nil)
        let optionCell = UINib.init(nibName: "OptionCell", bundle: nil)
        profileTableView.register(optionCell, forCellReuseIdentifier: "OptionCell")
        profileTableView.register(cellXib, forCellReuseIdentifier: "UserCell")
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        
        profileTableView.reloadData()
    }

    @objc func goToEditInfo(){
        presenter?.goToEditInfoView(user: user, image: imageProfile)
    }
}


//MARK: -> TableView

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
              case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell{
                    if let url = user.photoURL{
                        let _ = presenter?.requestProfileImage(from: user.photoURL, completion: { (result) in
                            DispatchQueue.main.async {
                                do{
                                    let image = try result.get()
                                    cell.imageProfile.image = image
                                }catch{
                                    cell.imageProfile.image = UIImage(named: "blankProfile")!
                                }
                            }
                        
                        })
                    }else{
                        cell.imageProfile.image = UIImage(named: "blankProfile")!
                    }
                    cell.imageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToEditInfo)))
                    cell.imageProfile.isUserInteractionEnabled = true
                    
                   //imageProfile
                    cell.nameLabel.text = user.name
                    return cell
                }
              case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell{
                    cell.imageOption.image = UIImage(named: "joseph")
                    cell.titleLabel.text = "About me"
                    return cell
                }
              case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell{
                    cell.imageOption.image = UIImage(named: "joseph")
                    cell.titleLabel.text = "My Activities"
                    return cell
                }
              case 4:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell{
                   cell.imageOption.image = UIImage(named: "joseph")
                   cell.titleLabel.text = "Settings"
                    return cell
                }
              default:
                break
              }
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
             presenter?.goToEditInfoView(user: user, image: imageProfile)
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return  245
        }else{
            return 80
        }
     }
    
    
    func setupoTableView(cell: UITableViewCell, index: Int)-> UITableViewCell{
        
        switch index {
        case 0:
             let cell = cell as! UserCell
            cell.imageProfile.image = UIImage(named: "joseph")//imageProfile
            cell.nameLabel.text = user.name
            return cell
        case 2:
            let cell = cell as! OptionCell
            cell.imageOption.image = UIImage(named: "joseph")
            cell.titleLabel.text = "About me"
            return cell
        case 3:
             let cell = cell as! OptionCell
             cell.imageOption.image = UIImage(named: "joseph")
             cell.titleLabel.text = "My Activities"
             return cell
        case 4:
            let cell = cell as! OptionCell
            cell.imageOption.image = UIImage(named: "joseph")
            cell.titleLabel.text = "Settings"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
