//
//  ViewPostViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController, ViewPostPresenterToView {
  
    @IBOutlet weak var postNotexistLabel: UILabel!
    
    @IBOutlet weak var textViewCommentBottom: NSLayoutConstraint!
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var bottomButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var textViewHeightComment: NSLayoutConstraint!
    
    var previousRect = CGRect(x: 0, y: 7, width: 0, height: 0)
    
    var post: Post?{
        didSet{
            if let tableView = postTableView{
                presenter?.updateFeed(from: post!, startingBy: 0)
                tableView.reloadData()
                postNotexistLabel.isHidden = true
                commentsLoadIndicator.isHidden = false
                commentsLoadIndicator.startAnimating()
            }
        }
    }
    var comments: [Comment] = [Comment]()
    
    var presenter: ViewPostViewToPresenter? = nil

    var imageAuthor: UIImage?
    
    @IBOutlet weak var commentsLoadIndicator: UIActivityIndicatorView!
    weak var feedVC: FeedViewController? = nil
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
  
    
    var fetchedAll = false
    override func viewWillAppear(_ animated: Bool) {
        postTableView.estimatedRowHeight = 300
        postTableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Post"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
        postTableView.separatorStyle = .none
        
        self.hideKeyboardWhenTappedAround()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postCell = UINib(nibName: "PostCell", bundle: nil)
        
        let commentCell = UINib(nibName: "CommentCell", bundle: nil)
        
        postTableView.register(postCell, forCellReuseIdentifier: "PostCell")
        postTableView.register(commentCell, forCellReuseIdentifier: "CommentCell")
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.allowsSelection = false
        
//        commentTextField.delegate = self
        commentTextView.delegate = self
        commentTextView.layer.cornerRadius = 10
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = CGColor(srgbRed: 29/255, green: 37/255, blue: 110/255, alpha: 1.0)
            
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)
        
        if let post = post{
            presenter?.updateFeed(from: post, startingBy: 0)
            postNotexistLabel.isHidden = true
        }else{
            postNotexistLabel.isHidden = false
            commentButton.isHidden = true
            commentsLoadIndicator.isHidden = true
            commentTextView.isHidden = true
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     //   self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.title = ""
        self.feedVC?.feedTableView.reloadData()
    }
    @IBAction func goBackToFeed(_ sender: Any) {
        presenter?.finishViewPostSession()
    }
    
    @IBAction func sendComment(_ sender: Any) {
        presenter?.validadeComment(text: commentTextView.text ?? nil)
    }
    
    
    func commentValidated(isValid: Bool) {
        if isValid{
            if let post = post{
                presenter?.createComent(comment: commentTextView.text!, post: post)
                commentTextView.text = "Comment"
                commentTextView.textColor = UIColor(red: 0, green:0, blue: 0, alpha: 0.5)
                textViewHeightComment.constant = 36
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
                view.endEditing(true)
                commentTextView.endEditing(true)
            }
        }
       
        //commentButton.isEnabled = isValid
    }
       
    func showAlertError(error msg: String) {
        let alert = UIAlertController(title: "Operation Failed", message: msg, preferredStyle: .alert)
        alert.isSpringLoaded = true
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.show(alert, sender: nil)
    }
    
    func commentCreated(comment: Comment) {
        comments.append(comment)
//        labelNoComments.isHidden = true
        postTableView.reloadData()
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = postTableView.cellForRow(at: indexPath) as? CommentCell{
            cell.noCommentsLabel.isHidden = true
        }
    }
    
    func showComments(comments: [Comment]) {
        if comments.isEmpty{
            commentsLoadIndicator.isHidden = comments.isEmpty
//            labelNoComments.isHidden = false
            let indexPath = IndexPath(row: 1, section: 0)
            if let cell = postTableView.cellForRow(at: indexPath) as? CommentCell{
                cell.noCommentsLabel.isHidden = false
            }
            return
        }
//        labelNoComments.isHidden = true
        self.comments = comments
        postTableView.reloadData()
        commentsLoadIndicator.stopAnimating()
        commentsLoadIndicator.isHidden = !comments.isEmpty
        
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = postTableView.cellForRow(at: indexPath) as? CommentCell{
            cell.noCommentsLabel.isHidden = true
        }
    }
    
    func fetchedAll(_ isFetched: Bool) {
        self.fetchedAll = isFetched
    }
       
    
}


extension ViewPostViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.isEmpty ? 2 : 1 + comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var post = post else{return UITableViewCell()}
         post.isLiked = verifyLikedDocument(id: post.id)
        if indexPath.row == 0 {
            if let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
                postCell.populate(post: post, viewSection: feedVC?.section)
                if let image = imageAuthor{
                    postCell.populateImage(image: image)
                }
                postCell.upvoted = { num in
                    FeedViewController.user.postsLiked.append(post.id)
                    self.presenter?.updateVotes(from: "upvote", inDocument: post, with: nil)
                    self.feedVC?.updateVotesView(VoteType.upVote,num)
                    self.post?.upvote += 1
                }
                postCell.downVoted = { num in
                    self.feedVC?.updateVotesView(VoteType.upVote,num)
                    self.presenter?.updateVotes(from: "downvote", inDocument: post, with: nil)
                }
                return postCell
            }
        }else{
            if let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell{
                
                if comments.isEmpty {
                    commentCell.populanteWithNoComments()
                    return commentCell
                }
                var comment = comments[indexPath.row-1]
                 comment.isLiked = verifyLikedDocument(id: comment.id)
                commentCell.poulate(from: comment)
                    
                let uuid = presenter?.requestProfileImage(from: comment.authorPhotoURL, completion: { result in
                    do{
                        let image = try result.get()
                        commentCell.populateImage(image: image)
                    }catch{
                        commentCell.populateImage(image: UIImage(named: "blankProfile")!)
                        print(error as Any)
                    }
                })
                commentCell.onReuse = {
                    if let uuid = uuid{
                        self.presenter?.cancelImageRequest(uuid: uuid)
                    }
                }
                
                commentCell.upvoted = {
                    self.presenter?.updateVotes(from: "upvote", inDocument: post, with: comment)
                    FeedViewController.user.postsLiked.append(comment.id)
                    self.comments[indexPath.row-1].upvote += 1
                }
                commentCell.downVoted = {self.presenter?.updateVotes(from: "downvote", inDocument: post, with: comment)}
                return commentCell
            
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastVisibleIndexPath = tableView.numberOfRows(inSection: 0)
        print(lastVisibleIndexPath)
        
        ///aqui eu faço a requisição de mais posts, tenho que testar dps
        if indexPath.row == lastVisibleIndexPath-1, !comments.isEmpty {
            if !fetchedAll{
                guard let num = comments.last?.upvote else{return}
                print("krai krai")
                presenter?.updateFeed(from: post!, startingBy: num)
            }
        }
        
       }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return 300
//        }else{
//            return 200
//        }
        return UITableView.automaticDimension
    }
    
    private func setupCommentCell(with comment:String) {
        
        
        
        
    }
    
    func verifyLikedDocument(id: String)->Bool{
        return FeedViewController.user.postsLiked.contains(id)
    }
    
    
    
    
}



// MARK: -> TextField

extension ViewPostViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter?.validadeComment(text: textField.text)
//        self.labelNoComments.isHidden = true
    }
    
    
    func textFieldTextDidChange(textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.sizeToFit()
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
    }
    
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
//                self.keyboardHeightLayoutConstraint.constant = 0.0
//                self.sendButtonYAnchor.constant = 0.0
                self.textViewCommentBottom.constant = 10.0
                self.bottomButtonContraint.constant = 11
                self.textViewHeightComment.constant = 36
            } else {
//                self.keyboardHeightLayoutConstraint.constant = endFrame?.size.height ?? 0.0
//                self.sendButtonYAnchor.constant = (endFrame?.size.height ?? 0.0)  * 0.9
//                self.textViewHeightComment.constant = 2
                self.textViewCommentBottom.constant = 10 + (endFrame?.size.height ?? 0.0) * 0.8
                 self.bottomButtonContraint.constant = 11 + (endFrame?.size.height ?? 0.0) * 0.8
            }
            
//            self.textViewCommentBottom.constant = (endFrame?.size.height ?? 0.0)
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
}




extension ViewPostViewController: UITextViewDelegate{
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        textView.text = ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
     
        let pos = textView.endOfDocument
        let currentRect =  textView.caretRect(for: pos)
        if(currentRect.origin.y > previousRect.origin.y){
            if self.textViewHeightComment.constant > (36*2){return}
            self.textViewHeightComment.constant += 15
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }


        }
        previousRect = currentRect
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && (textView.text.isEmpty || textView.text == "Comment"){
            textView.resignFirstResponder()
            commentTextView.text = "Comment"
            commentTextView.textColor = UIColor(red: 0, green:0, blue: 0, alpha: 0.5)
            return false
        }
        
        let pos = textView.endOfDocument
        let currentRect =  textView.caretRect(for: pos)
        
        print("Current \(currentRect.origin.y )")
        print("Previous \( previousRect.origin.y)")
        if(currentRect.origin.y > previousRect.origin.y){
            if self.textViewHeightComment.constant > (36*2){return true}
            self.textViewHeightComment.constant += 15
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }


        }
        previousRect = currentRect
        return true
    }
}


//MARK: -> Dismiss Keyboard

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
