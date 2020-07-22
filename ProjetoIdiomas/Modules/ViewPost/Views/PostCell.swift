//
//  PostCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 11/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downVoteLabel: UILabel!
    @IBOutlet weak var upVoteLabel: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var backgroundCell: UIView!
    
    var onReuse: () -> () = {}
    var upvoted: (Int32) -> () = {_ in}
    var downVoted: (Int32) -> () = {_ in}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Initialization code
        imageLoadIndicator.startAnimating()
        postLoadIndicator.startAnimating()
        postLoadIndicator.hidesWhenStopped = true
        imageLoadIndicator.hidesWhenStopped = true
        
        
        ///setup profile image view
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 24
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func downVote(_ sender: Any) {
        
        ///atualizo label dos numeros
        if let tex = downVoteLabel.text, let num = Int32(tex){
            downVoteLabel.text = "\(num + 1)"
            downVoted(num + 1)
        }
    }
    @IBAction func upVote(_ sender: Any) {
       
        ///atualizo label dos numeros
        if let tex = upVoteLabel.text, let num = Int32(tex){
            upVoteLabel.text = "\(num + 1)"
             upvoted(num + 1)
        }
    }
    
    
    
    func populate(post: Post, viewSection: SectionSelected?){
            self.postText.text = post.message
            self.authorName.text = post.author.name
            self.postTitle.text = post.title
            self.downVoteLabel.text = "\(post.downvote)"
            self.upVoteLabel.text = "\(post.upvote)"
            self.postLoadIndicator.stopAnimating()
        
            guard let section = viewSection else {return}
            
            self.backgroundCell.backgroundColor = section == SectionSelected.learningSection ? SectionColor.learning.color : SectionColor.teaching.color 
        
    }
    
    func populateImage(image: UIImage){
        DispatchQueue.main.async {
            self.profileImageView.image = image
            self.imageLoadIndicator.stopAnimating()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        onReuse()
    }
}
