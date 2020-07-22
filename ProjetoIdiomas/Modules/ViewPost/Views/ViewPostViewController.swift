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
    @IBOutlet weak var sendButtonYAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var post: Post?{
        didSet{
            if let tableView = postTableView{
                presenter?.updateFeed(from: post!, startingBy: 0)
                tableView.reloadData()
                postNotexistLabel.isHidden = true
            }
        }
    }
    var comments: [Comment] = [Comment]()
    
    var presenter: ViewPostViewToPresenter? = nil

    var imageAuthor: UIImage?
    
    weak var feedVC: FeedViewController? = nil
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
         postTableView.estimatedRowHeight = 300
        postTableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Post"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
        postTableView.separatorStyle = .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postCell = UINib(nibName: "PostCell", bundle: nil)
        
        let commentCell = UINib(nibName: "CommentCell", bundle: nil)
        
        postTableView.register(postCell, forCellReuseIdentifier: "PostCell")
        postTableView.register(commentCell, forCellReuseIdentifier: "CommentCell")
        postTableView.delegate = self
        postTableView.dataSource = self
        
        
        commentTextField.delegate = self
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)
        
        if let post = post{
            presenter?.updateFeed(from: post, startingBy: 0)
            postNotexistLabel.isHidden = true
        }else{
            postNotexistLabel.isHidden = false
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
        presenter?.validadeComment(text: commentTextField.text ?? nil)
    }
    
    
    func commentValidated(isValid: Bool) {
        if isValid{
            if let post = post{
                presenter?.createComent(comment: commentTextField.text!, post: post)
                commentTextField.text = ""
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
        postTableView.reloadData()
    }
    
    func showComments(comments: [Comment]) {
        self.comments = comments
        postTableView.reloadData()
        
    }
    
}


extension ViewPostViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = post else{return UITableViewCell()}
        if indexPath.row == 0 {
            if let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
                postCell.populate(post: post, viewSection: feedVC?.section)
                if let image = imageAuthor{
                    postCell.populateImage(image: image)
                }
                postCell.upvoted = { num in
                    self.presenter?.updateVotes(from: "upvote", inDocument: post, with: nil)
                    self.feedVC?.updateVotesView(VoteType.upVote,num)
                }
                postCell.downVoted = { num in
                    self.feedVC?.updateVotesView(VoteType.upVote,num)
                    self.presenter?.updateVotes(from: "downvote", inDocument: post, with: nil)
                }
                return postCell
            }
        }else{
            if let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell{
                let comment = comments[indexPath.row-1]
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
                
                commentCell.upvoted = {self.presenter?.updateVotes(from: "upvote", inDocument: post, with: comment)}
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
//               presenter?.updateFeed(in: [.english], from: comments.last!.publicationDate)
//            guard let num = comments.last?.upvote else{return}
//            presenter?.updateFeed(from: post, startingBy: num)
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
    
    
    
    
}



// MARK: -> TextField

extension ViewPostViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter?.validadeComment(text: textField.text)
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
                self.keyboardHeightLayoutConstraint.constant = 0.0
                self.sendButtonYAnchor.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint.constant = endFrame?.size.height ?? 0.0
                self.sendButtonYAnchor.constant = (endFrame?.size.height ?? 0.0)  * 0.8
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
}




