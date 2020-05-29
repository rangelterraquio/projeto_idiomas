//
//  ViewPostViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController, ViewPostPresenterToView {
    
    
   
    

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var post: Post!
    var comments: [Comment]!
    
    var presenter: ViewPostViewToPresenter? = nil

    var imageAuthor: UIImage?
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
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
    
    }
    @IBAction func goBackToFeed(_ sender: Any) {
        
    }
    
    @IBAction func sendComment(_ sender: Any) {
        presenter?.createComent(comment: commentTextField.text!, postID: post.id)
    }
    
    
    func commentValidated(isValid: Bool) {
        commentButton.isEnabled = isValid
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
    
}


extension ViewPostViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
                postCell.populate(post: post)
                if let image = imageAuthor{
                    postCell.populateImage(image: image)
                }
                postCell.upvoted = {self.presenter?.updateVotes(from: "upvote", inDocument: self.post)}
                postCell.downVoted = {self.presenter?.updateVotes(from: "downvote", inDocument: self.post)}
                return postCell
            }
        }else{
            if let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell{
                let comment = comments[indexPath.row-1]
                commentCell.poulate(from: comment)
                if let url = comment.authorPhotoURL{
                    
                    let uuid = presenter?.requestProfileImage(from: url, completion: { result in
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
                }
                commentCell.upvoted = {self.presenter?.updateVotes(from: "upvote", inDocument: comment)}
                commentCell.downVoted = {self.presenter?.updateVotes(from: "downvote", inDocument: comment)}
                return commentCell
            
            }
        }
        return UITableViewCell()
    }
    
    
    
    
    
    
    private func setupCommentCell(with comment:String) {
        
        
        
        
    }
    
    
    
    
}



// MARK: -> TextField

extension ViewPostViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter?.validadeComment(text: textField.text)
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
            } else {
                self.keyboardHeightLayoutConstraint.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
}
