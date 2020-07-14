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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UserDefaults.standard.register(defaults: ["hasChangedName": false])

        if let image = image{
            imageProfile.image = image
        }
        self.textFieldName.delegate = self
    }

    @IBAction func changePhoto(_ sender: Any) {
        stateController.cameraHandler.currentVC = self
        stateController.cameraHandler.shwActionSheet(vc: self)

        stateController.cameraHandler.imagePickedBlock = { image in
            self.image = image
            self.stateController.saveImage(userID: self.user.id, image: image)
        }
        
    }
    
    @IBAction func changeName(_ sender: Any) {
        
        if let hasChangeTheName = UserDefaults.standard.value(forKey: hasChangeNameKey) as? Bool{
            if !hasChangeTheName{
                bottomLabelName.constant = 435
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                    self.textFieldName.isHidden = false
                    self.textFieldName.becomeFirstResponder()
                }
            }
        }
       
    }
    
    @IBAction func changeLanguages(_ sender: Any) {
        languageController.user = self.user
        languageController.stateController = self.stateController
        self.navigationController?.pushViewController(languageController, animated: true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.navigationController?.viewControllers.forEach({ (vc) in
            if let profileVc = vc as? ProfileViewController{
                profileVc.imageProfile = image
            }
        })
        super.dismiss(animated: true, completion: completion)
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
            self.bottomLabelName.constant = 403
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
                self.textFieldName.isHidden = true
            }
        }
        
        let button2 = UIAlertAction(title: "No", style: .cancel) { [weak self] (_) in
            self?.textFieldName.becomeFirstResponder()
        }
        
        alert.addAction(button2)
        alert.addAction(button1)
        self.present(alert, animated: true, completion: nil)

    }
    
}
