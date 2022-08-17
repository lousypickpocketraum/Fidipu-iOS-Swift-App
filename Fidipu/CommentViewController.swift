//
//  CommentViewController.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 3.06.2022.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var commentTableView: UITableView!
    
    var userCommentDocumentIDArray = [String]()
    var userMailArray = [String]()
    var userScoreArray = [Int]()
    var userCommentViewArray = [String]()
    var choosenCommentsDocumentId = ""
    var scoreCount = 0
    var totalScore = 0.0
    var rating = Float()
    var ratingString = String()
    var commentCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Scores").order(by: "date", descending: true).addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.userMailArray.removeAll(keepingCapacity: false)
                    self.userScoreArray.removeAll(keepingCapacity: false)
                    self.userCommentViewArray.removeAll(keepingCapacity: false)
                    self.userCommentDocumentIDArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        let scoredDocumentId = document.get("scoredMoviesSeriesDocumentId")
                        
                        if self.choosenCommentsDocumentId == scoredDocumentId as! String {
                            self.userCommentDocumentIDArray.append(documentID)
                            if let userMail = document.get("postedBy") as? String{
                                self.userMailArray.append(userMail)
                            }
                            if let userComment = document.get("comment") as? String{
                                self.userCommentViewArray.append(userComment)
                            }
                            if let userScore = document.get("score") as? Int{
                                self.userScoreArray.append(userScore)
                            }
                        }
                    }
                    print(self.userScoreArray.count)
                    if self.userScoreArray.count != 0 {
                        self.totalScore = Double(self.userScoreArray.reduce(0, { x, y in
                            x + y
                        }))
                        self.scoreCount = self.userScoreArray.count
                        rating = Float(self.totalScore/Double(self.scoreCount))
                        self.ratingString = String(format: "%.1f", rating)
                        commentCount = self.scoreCount
                        
                    }
                    firestoreDatabase.collection("Contents").document(choosenCommentsDocumentId).updateData([
                        "ratings" : ratingString,
                        "commentCount" : commentCount
                    ])
                    
                    self.commentTableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.userMailLabel.text = userMailArray[indexPath.row]
        cell.userScoreLabel.text = String(userScoreArray[indexPath.row])
        cell.userCommentTextView.text = userCommentViewArray[indexPath.row]
        cell.userCommentDocumentIdLabel.text = userCommentDocumentIDArray[indexPath.row]
        return cell
    }
    

}
