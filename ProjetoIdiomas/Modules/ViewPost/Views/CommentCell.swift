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
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var upVoteLabel: UILabel!
    @IBOutlet weak var downVoteLabel: UILabel!
    
    var onReuse: () -> () = {}
    var upvoted: () -> () = {}
    var downVoted: () -> () = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func upVote(_ sender: Any) {
        upvoted()
        ///atualizo label dos numeros
        if let tex = upVoteLabel.text, let num = Int16(tex){
            upVoteLabel.text = "\(num + 1)"
        }
    }
    
    @IBAction func downVote(_ sender: Any) {
        downVoted()
        ///atualizo label dos numeros
        if let tex = downVoteLabel.text, let num = Int16(tex){
            downVoteLabel.text = "\(num + 1)"
        }
    }
    
    func poulate(from comment: Comment){
        authorName.text = comment.authorName
        commentText.text = comment.commentText
        upVoteLabel.text = "\(comment.upvote)"
        downVoteLabel.text = "\(comment.downvote)"
    }
    
    
    func populateImage(image: UIImage){
        DispatchQueue.main.async {
            self.imageProfile.image = image
            self.imageIndicator.stopAnimating()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageProfile.image = nil
        onReuse()
    }
    
}
