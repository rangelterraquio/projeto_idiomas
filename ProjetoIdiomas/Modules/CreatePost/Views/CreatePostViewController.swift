//
//  CreatePostViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, CreatePostPresenterToView {
    
    

    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var textPost: UITextView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var selectLanguageButton: UIButton!
    @IBOutlet weak var languageSelectedImage: UIImageView!
    
    lazy var loadingIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .large)
    lazy var blurEffectView: UIVisualEffectView? = UIVisualEffectView()
    var presenter: CreatePostViewToPresenter!
    
    let languages: [Languages] = [.english,.french,.portuguese,.spanish,.chinese]
    var languagePost: Languages? = nil{
        didSet{
            languageSelectedImage.image = UIImage(named: languagePost!.name)
            presenter.validatePost(title: postTitle.text ?? "", text: textPost.text, language: languagePost)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textPost.delegate = self
        postTitle.delegate = self
    }

    @IBAction func createPost(_ sender: Any) {
        
        addBlurLoading()
        presenter.createPost(title: postTitle.text!, text: textPost.text, language: languagePost)
    }
    
    @IBAction func cancel(_ sender: Any) {
        //router vai entrar aqui
    }
    
    @IBAction func selectLanguage(_ sender: Any) {
        //Configure the presentation controller
        let popoverContentController = LanguagePopoverController(nibName: "LanguagePopoverController", bundle: nil)
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.languages = languages
        popoverContentController.delegate = self
        /* 3 */
        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect =  CGRect(origin: selectLanguageButton.frame.origin, size: (sender as! UIView).bounds.size)
            popoverPresentationController.delegate = self
            
            

            present(popoverContentController, animated: true, completion: nil)
            
        
        }
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
        self.view.addSubview(blurEffectView!)
        self.view.addSubview(loadingIndicator!)
        loadingIndicator!.center = self.view.center
        loadingIndicator!.startAnimating()
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
        textField.becomeFirstResponder()
    }
}



