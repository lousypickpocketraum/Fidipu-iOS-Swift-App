//
//  CommentTableViewCell.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 3.06.2022.
//

import UIKit
import Firebase

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userMailLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userCommentTextView: UITextView!
    @IBOutlet weak var userCommentDocumentIdLabel: UILabel!
    @IBOutlet weak var kaldirButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func checkUser() {
        if (Auth.auth().currentUser!.email! == userMailLabel.text!) || (Auth.auth().currentUser!.email! == "admin@fidipu.com")  {
            kaldirButton.isHidden = false
        } else {
            kaldirButton.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkUser()
        // Configure the view for the selected state
    }
    @IBAction func kaldirButton(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Scores").document(userCommentDocumentIdLabel.text!).delete()
    }
    
}
