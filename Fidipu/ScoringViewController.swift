//
//  ScoringViewController.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 3.06.2022.
//

import UIKit
import Firebase

class ScoringViewController: UIViewController {
    @IBOutlet weak var scoredMoSeDocumentIdLabel: UILabel!
    @IBOutlet weak var scoredMoSeNameLabel: UILabel!
    @IBOutlet weak var scoredMoSeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    var score = Int()
    
    var choosenDocumentId = ""
    var choosenMoviesSeries = ""
    var choosenMoviesSeriesName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Puan:1"
        scoredMoSeDocumentIdLabel.text = choosenDocumentId
        scoredMoSeLabel.text = choosenMoviesSeries
        scoredMoSeNameLabel.text = choosenMoviesSeriesName
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func scoreSlider(_ sender: UISlider) {
        score = Int(sender.value)
        scoreLabel.text=String(format: "Puan:%i",Int(sender.value))
    }
    @IBAction func gonderButton(_ sender: Any) {
        
        //Database
        let firestoreDatabase = Firestore.firestore()
        var firestoreReference : DocumentReference? = nil
        let firestoreContent = ["date" : FieldValue.serverTimestamp(),
                                "scoredMoviesSeriesDocumentId" : scoredMoSeDocumentIdLabel.text!,
                                "scoredMoviesSeriesName" : self.scoredMoSeNameLabel.text!,
                                "scoredMoviesSeries" : scoredMoSeLabel.text!,
                                "score" : score,
                                "comment" : commentTextView.text!,
                                "postedBy" : Auth.auth().currentUser!.email!] as [String : Any]
        
        firestoreReference = firestoreDatabase.collection("Scores").addDocument(data: firestoreContent, completion: { (error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata")
            } else {
                
            }
        })
        performSegue(withIdentifier: "toCommentVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentVC" {
            let destinationVC = segue.destination as! CommentViewController
            destinationVC.choosenCommentsDocumentId = choosenDocumentId
        }
    }
    @IBAction func yorumlariGosterButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toCommentVC", sender: nil)
    }
    
}
