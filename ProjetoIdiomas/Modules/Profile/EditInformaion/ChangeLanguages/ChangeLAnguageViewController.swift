//
//  ChangeLAnguageViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class ChangeLAnguageViewController: SelectLanguageViewController {
                  
    var stateController: StateController!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextB.isEnabled = true
        
        
    }


    @objc override func addPost(_ sender: Any){
        if viewState == .learningLanguagesSection{
            user.learningLanguage?.removeAll()
            fluentlyLanguages.forEach { (lan) in
                user.fluentLanguage.append(lan.rawValue)
            }
            learningLanguages.forEach { (lan) in
                user.learningLanguage?.append(lan.rawValue)
            }
            didComplete()
        }else{
            viewState = .learningLanguagesSection
            instructionLabel.text = "Select the languages you are learning:"
            languagesTableView.reloadData()
            nextB.title = "Done"
        }
    }
    
    @objc override func cancelAction(_ sender: Any){
        if viewState == .fluentlyLanguagesSection{
            self.navigationController?.popViewController(animated: true)
        }else{
            viewState = .fluentlyLanguagesSection
            instructionLabel.text = "Select the languages you are able to help other people:"
            fluentlyLanguages.removeAll()
            languagesTableView.reloadData()
        }
    }
    
    
    
    private func didComplete(){
        self.stateController.updateUser(user: self.user) { (completed) in
            if completed{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showAlertError(error: "Try again, something went wrong", title: "Operation Failed")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
