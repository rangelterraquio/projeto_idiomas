//
//  SelectLanguageViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 09/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

enum ViewState {
    case fluentlyLanguagesSection
    case learningLanguagesSection
}

class SelectLanguageViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var languagesTableView: UITableView!
    
    @IBOutlet weak var canccelButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    let languages: [Languages] = [.english,.french,.portuguese,.spanish,.chinese,.english,.french,.portuguese,.spanish,.chinese,.english,.french,.portuguese,.spanish,.chinese,.english,.french,.portuguese,.spanish,.chinese,.english,.french,.portuguese,.spanish,.chinese]
    
    var fluentlyLanguages:[Languages] = [Languages](){
        didSet{
            nextButton.isEnabled = !fluentlyLanguages.isEmpty
        }
    }
    var learningLanguages:[Languages] = [Languages](){
        didSet{
             nextButton.isEnabled = !learningLanguages.isEmpty
            
        }
    }
    
    var viewState: ViewState = .fluentlyLanguagesSection
    var router: SelectLanguagesToPresenter? = nil
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        // Do any additional setup after loading the view.
        let cellLanguage = UINib(nibName: "LanguageCell", bundle: nil)
        languagesTableView.register(cellLanguage, forCellReuseIdentifier: "LanguageCell")
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        languagesTableView.allowsMultipleSelection = true
        
    }

    @IBAction func addLanguages(_ sender: Any) {
        if viewState == .learningLanguagesSection{
            fluentlyLanguages.forEach { (lan) in
                user.fluentLanguage.append(lan.rawValue)
            }
            learningLanguages.forEach { (lan) in
                user.learningLanguage?.append(lan.rawValue)
            }
            router?.didSuccessfullyCreated(user: user)
        }else{
            viewState = .learningLanguagesSection
            instructionLabel.text = "Select the languages you are learning:"
            languagesTableView.reloadData()
        }
    }
    @IBAction func cancel(_ sender: Any) {
        if viewState == .fluentlyLanguagesSection{
            router?.cancelUserCreation()
        }else{
            viewState = .fluentlyLanguagesSection
            instructionLabel.text = "Select the languages you are able to help other people:"
            fluentlyLanguages.removeAll()
            languagesTableView.reloadData()
        }
    }
    
}





extension SelectLanguageViewController: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? LanguageCell{
            let language = languages[indexPath.row]
            cell.populeCell(with: language)
            return cell
        }
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewState == .fluentlyLanguagesSection{
            fluentlyLanguages.append(languages[indexPath.row])
        }else{
            learningLanguages.append(languages[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if viewState == .fluentlyLanguagesSection{
            fluentlyLanguages.removeAll(where: {  $0 == languages[indexPath.row] })
        }else{
            learningLanguages.removeAll(where: {  $0 == languages[indexPath.row] })
        }
    }
    
}
