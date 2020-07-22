//
//  CreatePostViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, CreatePostPresenterToView {
    
    
    
    
    enum SelectLanguageViewState{
        case colapsed
        case moving
        case expand
    }
    
    
    @IBOutlet weak var selectLanguageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var textPost: UITextView!


    @IBOutlet weak var languagesTableView: UITableView!
    
    var nextButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    @IBOutlet weak var selectLanguageButton: UIButton!
    @IBOutlet weak var languageSelectedImage: UIImageView!
    
    lazy var loadingIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .large)
    lazy var blurEffectView: UIVisualEffectView? = UIVisualEffectView()
    var presenter: CreatePostViewToPresenter!
    
    let languages: [Languages] = [.english,.french,.portuguese,.spanish,.chinese]
    var languagePost: Languages? = nil{
        didSet{
            if languagePost != nil{
                languageSelectedImage.image = UIImage(named: languagePost!.name)
                presenter.validatePost(title: postTitle.text ?? "", text: textPost.text, language: languagePost)
            }else{
                languageSelectedImage.image = nil
            }
           
        }
    }
    
    var selectedIndexPath: IndexPath?
    var viewState: SelectLanguageViewState = .colapsed
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Create Post"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textPost.delegate = self
        postTitle.delegate = self
        
        
         nextButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addPost))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        nextButton.isEnabled = false
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPost))
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        
        
        
        let cellLanguage = UINib(nibName: "LanguageCell", bundle: nil)
        languagesTableView.register(cellLanguage, forCellReuseIdentifier: "LanguageCell")
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        languagesTableView.separatorStyle = .none
        languagesTableView.backgroundColor = UIColor(red: 246/255, green: 243/255, blue: 251/255, alpha: 1.0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        postTitle.text = ""
        languagePost = nil
        textPost.text = ""
        nextButton.isEnabled = false
        textPost.endEditing(true)
        postTitle.endEditing(true)
        if let index = selectedIndexPath{
            languagesTableView.deselectRow(at: index, animated: false)
        }
    }
    
    @objc func addPost(sender: UIButton){
        addBlurLoading()
        presenter.createPost(title: postTitle.text!, text: textPost.text, language: languagePost)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
//    @IBAction func createPost(_ sender: Any) {
//        
//        addBlurLoading()
//        presenter.createPost(title: postTitle.text!, text: textPost.text, language: languagePost)
//    }
//
    
    @objc func cancelPost(sender: UIButton){
        presenter.cancelCreatePost()
    }
    @IBAction func cancel(_ sender: Any) {
        //router vai entrar aqui
        presenter.cancelCreatePost()
    }
    
    @IBAction func selectLanguage(_ sender: Any) {
        //Configure the presentation controller
//        let popoverContentController = LanguagePopoverController(nibName: "LanguagePopoverController", bundle: nil)
//        popoverContentController.modalPresentationStyle = .popover
//        popoverContentController.languages = languages
//        popoverContentController.delegate = self
//        /* 3 */
//        if let popoverPresentationController = popoverContentController.popoverPresentationController {
//            popoverPresentationController.permittedArrowDirections = .up
//            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect =  CGRect(origin: selectLanguageButton.frame.origin, size: (sender as! UIView).bounds.size)
//            popoverPresentationController.delegate = self
//
//
//
//            present(popoverContentController, animated: true, completion: nil)
//
//
//        }
        
        
        animateSelectLanguageView()
        
    }
    
    @IBAction func didSelect(_ sender: Any) {
        animateSelectLanguageView()
    }
    func updateDoneStatus() {
        nextButton.style = .done
        nextButton.isEnabled = true
    }
    
    func showAlertError(error msg: String) {
        loadingIndicator?.removeFromSuperview()
        blurEffectView?.removeFromSuperview()
        let alert = UIAlertController(title: "Operation Failed", message: msg, preferredStyle: .alert)
        alert.isSpringLoaded = true
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.show(alert, sender: nil)
    }
    
    
    
    //add load opetion
    func addBlurLoading(){
        let blur = UIBlurEffect(style: .extraLight)
        blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView!.frame = view.bounds
        blurEffectView!.alpha = 0.5
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.layer.zPosition = 4
        loadingIndicator?.color = .blue
        self.view.addSubview(blurEffectView!)
        self.view.addSubview(loadingIndicator!)
        loadingIndicator!.center = self.view.center
        loadingIndicator!.startAnimating()
    }
    
    
    func postCreated() {
        blurEffectView?.removeFromSuperview()
        loadingIndicator?.removeFromSuperview()
    }
}

//MARK: -> TextView
extension CreatePostViewController: UITextViewDelegate{
    public func textViewDidChange(_ textView: UITextView) {
        presenter.validatePost(title: postTitle.text ?? "", text: textView.text, language: languagePost)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "What is yout doubt?"
            textView.textColor = .lightGray
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}



//MARK: -> PopoverLanguage
extension CreatePostViewController: UIPopoverPresentationControllerDelegate, LanguagePopoverDelegate{
    
    func languageDidSelect(language: Languages) {
        languagePost = language
    }
    
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
    }
     
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
     
    }
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return false
    }
    
}


//MARK: -> TextField Delegate
extension CreatePostViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.validatePost(title: textField.text ?? "", text: textPost.text, language: languagePost)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





//MARK: -> Select Langague View
extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Languages.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? LanguageCell{
        let language = Languages.languages[indexPath.row]
        cell.populeCell(with: language)
       // cell.backgroundColor = UIColor(red: 246/255, green: 243/255, blue: 251/255, alpha: 1.0)
        
        return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = SectionColor.commonAreas.color
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = Languages.languages[indexPath.row]
        languagePost = language
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor(red: 246/255, green: 243/255, blue: 251/255, alpha: 1.0)
    }
    func animateSelectLanguageView(){
        if viewState == .moving {return}
        
        if viewState == .colapsed{
            selectLanguageHeightConstraint.constant = 400
            UIView.animate(withDuration: 0.7, animations: {
                self.view.layoutIfNeeded()
                self.viewState = .moving
            }) { (_) in
                self.viewState = .expand
            }
        }else{
            selectLanguageHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.7, animations: {
                self.view.layoutIfNeeded()
                self.viewState = .moving
            }) { (_) in
                self.viewState = .colapsed
            }
        }
    }
    
    
}
