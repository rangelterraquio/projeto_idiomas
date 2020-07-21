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
    var notificationManeger: PushNotificationManager!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellXib = UINib.init(nibName: "UserCell", bundle: nil)
        let optionCell = UINib.init(nibName: "OptionCell", bundle: nil)
        profileTableView.register(optionCell, forCellReuseIdentifier: "OptionCell")
        profileTableView.register(cellXib, forCellReuseIdentifier: "UserCell")
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.separatorStyle = .none
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
                        let _ = presenter?.requestProfileImage(from: url, completion: { (result) in
                            DispatchQueue.main.async {
                                do{
                                    let image = try result.get()
                                    self.imageProfile = image
                                    cell.populate(name: self.user.name, image: image)
                                }catch{
                                    let noImgage = UIImage(named: "blankProfile")!
                                    self.imageProfile = noImgage
                                    cell.populate(name: self.user.name, image: noImgage)
                                }
                            }
                        
                        })
                    }else{
                        let noImgage = UIImage(named: "blankProfile")!
                        self.imageProfile = noImgage
                        cell.populate(name: user.name, image: noImgage)

                    }
                    cell.imageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToEditInfo)))
                    cell.imageProfile.isUserInteractionEnabled = true
                    
                   //imageProfile
                   // cell.nameLabel.text = user.name
                    return cell
                }
              case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell{
                    cell.imageOption.image = UIImage(named: "aboutMe")
                    cell.titleLabel.text = "About me"
                    return cell
                }
              case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell{
                    cell.imageOption.image = UIImage(named: "myPosts")
                    cell.titleLabel.text = "My Posts"
                    return cell
                }
              case 4:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell{
                   cell.imageOption.image = UIImage(named: "settings")
                   cell.titleLabel.text = "Settings"
                    return cell
                }
              default:
                break
              }
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
             presenter?.goToEditInfoView(user: user, image: imageProfile)
            
        }else if indexPath.row == 3{
            presenter?.goToUserActivities()
        }else if indexPath.row ==  4{
            presenter?.goToSettings()
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return  245
        }else{
            return 100
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
