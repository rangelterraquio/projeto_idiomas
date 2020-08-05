//
//  CemmentCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 11/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var commentIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var upVoteLabel: UILabel!
    @IBOutlet weak var downVoteLabel: UILabel!
    
    @IBOutlet weak var reactionButton: UIButton!
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    var onReuse: () -> () = {}
    var upvoted: () -> () = {}
    var downVoted: () -> () = {}
    var reportClicked: () -> () = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        reactionButton.setImage(UIImage(named: "likedIcon"), for: .disabled)
        reactionButton.setImage(UIImage(named: "Icon awesome-arrow-alt-circle-up-1"), for: .normal)
        commentIndicator.startAnimating()
        commentIndicator.hidesWhenStopped = true
        imageIndicator.hidesWhenStopped = true
        
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        imageProfile.layer.cornerRadius = 15
        imageProfile.layer.masksToBounds = true
        imageProfile.contentMode = .scaleAspectFill
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAtComment))
        self.addGestureRecognizer(tap)
        self.backgroundCell.addGestureRecognizer(tap)
        self.authorName.addGestureRecognizer(tap)
        self.commentText.addGestureRecognizer(tap)
        self.backgroundView?.addGestureRecognizer(tap)
        
        
    }
    
    @objc func didTapAtComment(sender: Any){
        reportClicked()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func upVote(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        upvoted()
        ///atualizo label dos numeros
        if let tex = upVoteLabel.text, let num = Int32(tex){
            upVoteLabel.text = "\(num + 1)"
        }
        
        reactionButton.isEnabled = false
    }
    
    @IBAction func downVote(_ sender: Any) {
        downVoted()
        ///atualizo label dos numeros
        if let tex = downVoteLabel.text, let num = Int32(tex){
            downVoteLabel.text = "\(num + 1)"
        }
    }
    
    func poulate(from comment: Comment){
        authorName.text = comment.authorName
        commentText.text = comment.commentText
        upVoteLabel.text = "\(comment.upvote)"
        downVoteLabel.text = "\(comment.downvote)"
        commentIndicator.stopAnimating()
        backgroundCell.isHidden = false
        authorName.isHidden = false
        commentText.isHidden = false
        upVoteLabel.isHidden = false
        downVoteLabel.isHidden = false
        commentText.isHidden = false
        noCommentsLabel.isHidden = true
        backgroundCell.isHidden = false
        commentIndicator.stopAnimating()
        
        reactionButton.isEnabled = !comment.isLiked
        
        
        ablityUserInteraction(enable: !comment.isReported)
    }
    func populanteWithNoComments(){
        authorName.isHidden = true
        commentText.isHidden = true
        upVoteLabel.isHidden = true
        downVoteLabel.isHidden = true
        commentText.isHidden = true
        noCommentsLabel.isHidden = false
        backgroundCell.isHidden = true
        commentIndicator.stopAnimating()
     
        ablityUserInteraction(enable: false)
    }
    
    
    func populateImage(image: UIImage){
        DispatchQueue.main.async {
            self.imageProfile.image = image
            self.imageIndicator.stopAnimating()
        }
    }
    
    func ablityUserInteraction(enable: Bool){
        self.backgroundCell.isUserInteractionEnabled = enable
        self.isUserInteractionEnabled = enable
        self.authorName.isUserInteractionEnabled = enable
        self.commentText.isUserInteractionEnabled = enable
        self.backgroundView?.isUserInteractionEnabled = enable
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageProfile.image = nil
        onReuse()
    }
    
}
