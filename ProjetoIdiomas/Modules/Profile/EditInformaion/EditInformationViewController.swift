//
//  EditInformationViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class EditInformationViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var bottomLabelName: NSLayoutConstraint!
    var stateController: StateController!
    var user: User!
    var image: UIImage?{
        didSet{
            if imageProfile != nil{
                imageProfile.image = image
            }
        }
    }
    let hasChangeNameKey = "hasChangedName"
    
    lazy var languageController = ChangeLAnguageViewController(nibName: "ChangeLAnguageViewController", bundle: nil)
    
    var manegeButton: UIBarButtonItem!
    
    
    lazy var loadIndicator = UIActivityIndicatorView(style: .large)
    
    
    weak var manegeAccountelegate: ManegeAccountDelegate? = nil
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Edit Informations"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UserDefaults.standard.register(defaults: ["hasChangedName": false])

        
        
        manegeButton = UIBarButtonItem(image: UIImage(named: "exitIcon"), style: .plain, target: self, action: #selector(manegeAccount))
        self.navigationItem.setRightBarButton(manegeButton, animated: true)
        manegeButton.isEnabled = true
        
        if let image = image{
            imageProfile.image = image
        }
        self.textFieldName.delegate = self
        self.labelName.text = user.name
        
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        imageProfile.layer.cornerRadius = 90
        imageProfile.layer.masksToBounds = true
        imageProfile.contentMode = .scaleAspectFill
    }

    @IBAction func changePhoto(_ sender: Any) {
        stateController.cameraHandler.currentVC = self
        stateController.cameraHandler.shwActionSheet(vc: self)

        stateController.cameraHandler.imagePickedBlock = { image in
            self.image = image
            self.stateController.saveImage(userID: self.user.id, image: image)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserCell.notificationName), object: nil, userInfo:["image": image])
        }
        
    }
    
    @IBAction func changeName(_ sender: Any) {
        
        if let hasChangeTheName = UserDefaults.standard.value(forKey: hasChangeNameKey) as? Bool{
            if !hasChangeTheName{
                self.textFieldName.isHidden = false
                self.textFieldName.becomeFirstResponder()
                self.labelName.isHidden = true
               
            }else{
                self.showAlertError(error: "I can change the name only once.", title: "Operation not allowed")
            }
        }
       
    }
    
    @IBAction func changeLanguages(_ sender: Any) {
        languageController.user = self.user
        languageController.stateController = self.stateController
        self.navigationController?.pushViewController(languageController, animated: true)
    }
    
    @objc func manegeAccount(_ sender: Any){
        actionSheet()
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.navigationController?.viewControllers.forEach({ (vc) in
            if let profileVc = vc as? ProfileViewController{
                profileVc.imageProfile = image
            }
        })
        super.dismiss(animated: true, completion: completion)
    }
    
    
    private func actionSheet(){
        let actionSheet = UIAlertController(title: "", message: "Manege Account", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            self.manegeAccountelegate?.signOut()
            
        }
       
        
        let action2 = UIAlertAction(title: "Delete Account", style: .destructive) { (_) in
            self.manegeAccountelegate?.reauthetication()
        }
           
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    private func deleteAccount(){
        
        
        
        
//        self.view.addSubview(loadIndicator)
//        loadIndicator.startAnimating()
//        self.manegeAccountelegate?.deleteAccount()
//        stateController.deleteUserAccount { (error) in
//            DispatchQueue.main.async {
//                self.loadIndicator.stopAnimating()
//                self.loadIndicator.removeFromSuperview()
//            }
//            switch error{
//            case .internetError:
//                self.showAlertError(error: "Verify your internet connection", title: "Operation failed")
//            case .operationFailed:
//                self.showAlertError(error: "Something went wrong, try it again!", title: "Operation failed")
//            case .none:
//                self.manegeAccountelegate?.deleteAccount()
//            }
//        }
    }

}


extension EditInformationViewController: UITextFieldDelegate{
    
    func isTextValid() -> Bool{
        if let text = textFieldName.text{
            if text.count <= 1{
                return false
            }
            return true
        }
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if !isTextValid(){
            showAlertError(error: "Name Invalid")
            return false
        }else{
            showConfirmAlest()
        }
    
        return true
    }
    
    func showAlertError(error msg: String) {
           let alert = UIAlertController(title: "Operation Failed", message: msg, preferredStyle: .alert)
           alert.isSpringLoaded = true
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    
    
    func showConfirmAlest(){
        let alert = UIAlertController(title: "Are you sure?", message: "You can change your name only once. Are you sure you want to change it?", preferredStyle: .alert)
        
        let button1 = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
            guard let self = self else{return}
            
            //chamar funcao de salvar
            UserDefaults.standard.set(true, forKey: self.hasChangeNameKey)
            self.textFieldName.resignFirstResponder()
            self.textFieldName.isHidden = true
            self.stateController.updateUserName(newName: self.textFieldName.text ?? self.user.name, user: self.user)
            self.labelName.text = self.textFieldName.text
            self.labelName.isHidden = false
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserCell.notificationName), object: nil, userInfo:["name": self.labelName.text! as String])
            
        }
        
        let button2 = UIAlertAction(title: "No", style: .cancel) { [weak self] (_) in
            self?.textFieldName.becomeFirstResponder()
        }
        
        alert.addAction(button2)
        alert.addAction(button1)
        self.present(alert, animated: true, completion: nil)

    }
    
}
