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
    
    @IBOutlet weak var bottoTextPost: NSLayoutConstraint!
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
    
    var constTextViewBottom: CGFloat = 10000
    var isPostValid = false{
        didSet{
            if isPostValid{
                nextButton.style = .done
                nextButton.isEnabled = true
                nextButton.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
            }else{
                 nextButton.isEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Create Post"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
        
//UIResponder.keyboardWillShowNotification
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name(rawValue: UIResponder.keyboardFrameEndUserInfoKey), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: NSNotification.Name(rawValue: UIResponder.keyboardWillShowNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name(rawValue: UIResponder.keyboardWillShowNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name(rawValue: UIResponder.keyboardWillHideNotification.rawValue), object: nil)
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
        
        
//        self.textPost.layoutManager.allowsNonContiguousLayout = false
        
        let cellLanguage = UINib(nibName: "LanguageCell", bundle: nil)
        languagesTableView.register(cellLanguage, forCellReuseIdentifier: "LanguageCell")
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        languagesTableView.separatorStyle = .none
        languagesTableView.backgroundColor = .clear//UIColor(red: 246/255, green: 243/255, blue: 251/255, alpha: 1.0)
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
            let cell = languagesTableView.cellForRow(at: index)
            cell?.backgroundColor = SectionColor.commonAreas.color
        }
        if viewState == .expand{
            animateSelectLanguageView()
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
        
        view.endEditing(true)
        animateSelectLanguageView()
        
    }
    @IBAction func titleDidChange(_ sender: Any) {
        presenter.validatePost(title: postTitle.text ?? "", text: textPost.text, language: languagePost)
    }
    
    @IBAction func didSelect(_ sender: Any) {
        animateSelectLanguageView()
    }
    func updateDoneStatus(isValid: Bool) {
//        nextButton.style = .done
//        nextButton.isEnabled = isValid
//        nextButton.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
        isPostValid = isValid
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
    


    @objc func keyboardWillShow(notification:NSNotification) {
        if bottoTextPost.constant < constTextViewBottom{
            adjustView(show: true, notification: notification)
        }
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        adjustView(show: false, notification: notification)
    }

    func adjustView(show:Bool, notification:NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = show ? (keyboardFrame.size.height/*or any value as per need*/) + 120 : 130
        
        print("Change In height \(changeInHeight)")
        constTextViewBottom = show ? changeInHeight : 10000
        self.bottoTextPost.constant = changeInHeight
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })

    }
    
    
}

//MARK: -> TextView
extension CreatePostViewController: UITextViewDelegate{
    public func textViewDidChange(_ textView: UITextView) {
        presenter.validatePost(title: postTitle.text ?? "", text: textView.text, language: languagePost)
//        textView.scrollRangeToVisible(NSMakeRange(0, 0))
       let bottom = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(bottom)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
////        NSNotification.Name(rawValue: "StartedEditPostText")
//        let keyboardHeight = UIKEyb
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartedEditPostText"), object: nil, userInfo:[UIResponder.keyboardFrameBeginUserInfoKey: frame])
        if viewState == .expand{
            animateSelectLanguageView()
        }
        
        
        if textView.text == "What are you thinking?"{
            textView.text = nil
        }
        textView.textColor = .black
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "What are you thinking?"
            textView.textColor = .lightGray
        }
        presenter.validatePost(title: postTitle.text ?? "", text: textView.text, language: languagePost)

    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        presenter.validatePost(title: postTitle.text ?? "", text: textView.text, language: languagePost)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            presenter.validatePost(title: postTitle.text ?? "", text: textView.text, language: languagePost)
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
         presenter.validatePost(title: postTitle.text ?? "", text: textPost.text, language: languagePost)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        presenter.validatePost(title: postTitle.text ?? "", text: textPost.text, language: languagePost)
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
        cell.backgroundColor = .clear//SectionColor.commonAreas.color
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = Languages.languages[indexPath.row]
        languagePost = language
        selectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = SectionColor.commonAreas.color
        presenter.validatePost(title: postTitle.text ?? "", text: textPost.text, language: languagePost)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear // SectionColor.commonAreas.color//UIColor(red: 246/255, green: 243/255, blue: 251/255, alpha: 1.0)
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
