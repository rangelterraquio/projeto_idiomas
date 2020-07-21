//
//  SelectLanguageViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 09/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

public enum ViewState {
    case fluentlyLanguagesSection
    case learningLanguagesSection
}

public class SelectLanguageViewController: UIViewController,OnBoardingPage {
    
    public var pageDelegate: WalkThroughOnBoardDelegate?
    

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var languagesTableView: UITableView!
    

    let languages: [Languages] = [.english,.french,.portuguese,.portuguesePT,.spanish,.chinese,.korean,.dutch,.german,.italian,.japanese,.russian,.danish]
    
    var fluentlyLanguages:[Languages] = [Languages](){
        didSet{
            nextButton.isEnabled = !fluentlyLanguages.isEmpty
            if  nextButton.isEnabled{
                nextButton.alpha = 1.0
            }else{
                nextButton.alpha = 0.6
            }
        }
    }
    var learningLanguages:[Languages] = [Languages](){
        didSet{
            nextButton.isEnabled = !learningLanguages.isEmpty
            if  nextButton.isEnabled{
                nextButton.alpha = 1.0
            }else{
                nextButton.alpha = 0.6
            }
            
        }
    }
    
    var viewState: ViewState = .learningLanguagesSection
    var router: SelectLanguagesToPresenter? = nil
    var user: User!
    
    
    var nextB: UIBarButtonItem!
    var cancelB: UIBarButtonItem!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
   
    override public func viewWillAppear(_ animated: Bool) {
        setupView()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true

        
       
        // Do any additional setup after loading the view.
        let cellLanguage = UINib(nibName: "LanguageCell", bundle: nil)
        languagesTableView.register(cellLanguage, forCellReuseIdentifier: "LanguageCell")
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        languagesTableView.allowsMultipleSelection = true
        
        
        nextB = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addPost))
        self.navigationItem.setRightBarButton(nextB, animated: true)
        nextB.title = "Next"
        nextB.isEnabled = false

        
        cancelB = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(cancelB, animated: true)
        cancelB.isEnabled = true
        
        
        languagesTableView.layer.cornerRadius = 15
        languagesTableView.layer.masksToBounds = true
        
        
    }

    
    func setupView(){
        nextButton.alpha = 0.6
        if viewState == .fluentlyLanguagesSection{
            nextButton.setTitle("Done", for: .normal)
            backgroundImage.image = UIImage(named: "fundoOnboard2")
        }else{
            nextButton.setTitle("Next", for: .normal)
            backgroundImage.image = UIImage(named: "fundoOnboard1")
        }
    }
    
    @objc func addPost(_ sender: Any){
        if viewState == .fluentlyLanguagesSection{
                  fluentlyLanguages.forEach { (lan) in
                      user.fluentLanguage.append(lan.rawValue)
                  }
                  learningLanguages.forEach { (lan) in
                      user.learningLanguage?.append(lan.rawValue)
                  }
                  router?.didSuccessfullyCreated(user: user)
              }else{
                viewState = .fluentlyLanguagesSection
                  instructionLabel.text = "Select the languages you are able to help someone else:"
                  //languagesTableView.reloadData()
                router?.didSelectTeachingLanguages(user: user, state: .fluentlyLanguagesSection, languagesVC: self)
              }
    }
   
    
    @objc func cancelAction(_ sender: Any){
        if viewState == .learningLanguagesSection{
            router?.cancelUserCreation()
        }else{
            viewState = .learningLanguagesSection
            instructionLabel.text = "Select the languages you are able to help someone else:"
            fluentlyLanguages.removeAll()
            languagesTableView.reloadData()
            
        }
    }
    
    @IBAction func addLanguage(_ sender: Any) {
        
        if viewState == .fluentlyLanguagesSection{
            fluentlyLanguages.forEach { (lan) in
                user.fluentLanguage.append(lan.rawValue)
            }
            learningLanguages.forEach { (lan) in
                user.learningLanguage?.append(lan.rawValue)
            }
            router?.didSuccessfullyCreated(user: user)
        }else{
            viewState = .fluentlyLanguagesSection
            instructionLabel.text = "Select the languages you are able to help someone else:"
            languagesTableView.reloadData()
            pageDelegate?.goNextPage(fowardTo: .teachingOnBoard)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        if viewState == .learningLanguagesSection{
            router?.cancelUserCreation()
        }else{
            viewState = .learningLanguagesSection
            instructionLabel.text = "Select the languages you are learning:"
            fluentlyLanguages.removeAll()
            languagesTableView.reloadData()
            pageDelegate?.goNextPage(fowardTo: .learningOnBoard)
        }
    }
    
//    @IBAction func addLanguages(_ sender: Any) {
//        if viewState == .learningLanguagesSection{
//            fluentlyLanguages.forEach { (lan) in
//                user.fluentLanguage.append(lan.rawValue)
//            }
//            learningLanguages.forEach { (lan) in
//                user.learningLanguage?.append(lan.rawValue)
//            }
//            router?.didSuccessfullyCreated(user: user)
//        }else{
//            viewState = .learningLanguagesSection
//            instructionLabel.text = "Select the languages you are learning:"
//            languagesTableView.reloadData()
//        }
//    }
//    @IBAction func cancel(_ sender: Any) {
//        if viewState == .fluentlyLanguagesSection{
//            router?.cancelUserCreation()
//        }else{
//            viewState = .fluentlyLanguagesSection
//            instructionLabel.text = "Select the languages you are able to help other people:"
//            fluentlyLanguages.removeAll()
//            languagesTableView.reloadData()
//           
//        }
//    }
    
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
         if viewState == .fluentlyLanguagesSection{
                   router?.cancelUserCreation()
               }else{
                   viewState = .fluentlyLanguagesSection
                   instructionLabel.text = "Select the languages you are able to help someone else:"
                   fluentlyLanguages.removeAll()
                   languagesTableView.reloadData()
               }
    }
    
    
    
    
}





extension SelectLanguageViewController: UITableViewDelegate,UITableViewDataSource{
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? LanguageCell{
            let language = languages[indexPath.row]
            cell.populeCell(with: language)
//
            //cell.setSelected(true, animated: true)
            
            return cell
        }
       return UITableViewCell()
    }
    
    
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let language = languages[indexPath.row]
        if viewState == .fluentlyLanguagesSection{
            if user.fluentLanguage.contains(language.rawValue){
                cell.setSelected(true, animated: true)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                fluentlyLanguages.append(languages[indexPath.row])
            }
            
        }else{
            if user.learningLanguage?.contains(language.rawValue) ?? false{
                cell.setSelected(true, animated: true)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                learningLanguages.append(languages[indexPath.row])
            }
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewState == .fluentlyLanguagesSection{
            fluentlyLanguages.append(languages[indexPath.row])
        }else{
            learningLanguages.append(languages[indexPath.row])
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if viewState == .fluentlyLanguagesSection{
            fluentlyLanguages.removeAll(where: {  $0 == languages[indexPath.row] })
        }else{
            learningLanguages.removeAll(where: {  $0 == languages[indexPath.row] })
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}



extension UIButton{
    override open var isEnabled: Bool{
        didSet{
            if isEnabled {
                self.alpha = 1.0
            }else{
                self.alpha = 0.6
            }
        }
    }
}
