//
//  FeedViewController.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 31.05.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var feedTableView: UITableView!
    var moviesSeriesDocumentIdArray = [String]()
    var moviesSeriesNameArray = [String]()
    var moviesSeriesArray = [String]()
    var moviesSeriesDirectorArray = [String]()
    var moviesSeriesReleaseYearArray = [String]()
    var moviesSeriesGenreArray = [String]()
    var moviesSeriesSubjectArray = [String]()
    var moviesSeriesCastsArray = [String]()
    var moviesSeriesRatingsArray = [String]()
    var moviesSeriesCommentCountArray = [Int]()
    var imageUrlArray = [String]()
    var buttonClickArray = [Int]()
    var selectedDocumentId = ""
    var selectedMoviesSeries = ""
    var selectedMoviesSeriesName = ""
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Contents").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.moviesSeriesDocumentIdArray.removeAll(keepingCapacity: false)
                    self.imageUrlArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesNameArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesGenreArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesDirectorArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesReleaseYearArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesSubjectArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesRatingsArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesCastsArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesRatingsArray.removeAll(keepingCapacity: false)
                    self.moviesSeriesCommentCountArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.moviesSeriesDocumentIdArray.append(documentID)
                        self.buttonClickArray.append(self.count)
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.imageUrlArray.append(imageUrl)
                        }
                        if let moviesSeriesName = document.get("moviesSeriesName") as? String{
                            self.moviesSeriesNameArray.append(moviesSeriesName)
                        }
                        if let moviesSeries = document.get("moviesSeries") as? String{
                            self.moviesSeriesArray.append(moviesSeries)
                        }
                        if let moviesSeriesDirector = document.get("moviesSeriesDirector") as? String{
                            self.moviesSeriesDirectorArray.append(moviesSeriesDirector)
                        }
                        if let moviesSeriesGenre = document.get("moviesSeriesGenre") as? String{
                            self.moviesSeriesGenreArray.append(moviesSeriesGenre)
                        }
                        if let moviesSeriesReleaseYear = document.get("moviesSeriesReleaseYear") as? String{
                            self.moviesSeriesReleaseYearArray.append(moviesSeriesReleaseYear)
                        }
                        if let moviesSeriesSubject = document.get("moviesSeriesSubject") as? String{
                            self.moviesSeriesSubjectArray.append(moviesSeriesSubject)
                        }
                        if let moviesSeriesCasts = document.get("moviesSeriesCasts") as? String{
                            self.moviesSeriesCastsArray.append(moviesSeriesCasts)
                        }
                        if let moviesSeriesRatings = document.get("ratings") as? String{
                            self.moviesSeriesRatingsArray.append(moviesSeriesRatings)
                        }
                        if let moviesSeriesCommentCount = document.get("commentCount") as? Int{
                            self.moviesSeriesCommentCountArray.append(moviesSeriesCommentCount)
                        }
                        
                        self.count += 1
                        
                    }
                    self.feedTableView.reloadData()
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ScoringViewController") as? ScoringViewController{
            vc.choosenDocumentId = moviesSeriesDocumentIdArray[indexPath.row]
            vc.choosenMoviesSeries = moviesSeriesArray[indexPath.row]
            vc.choosenMoviesSeriesName = moviesSeriesNameArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSeriesNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        if moviesSeriesDocumentIdArray.isEmpty != true {
            cell.moviesSeriesDocumentIdLabel.text = moviesSeriesDocumentIdArray[indexPath.row]
            cell.moviesSeriesNameLabel.text = moviesSeriesNameArray[indexPath.row]
            cell.moviesSeriesLabel.text = moviesSeriesArray[indexPath.row]
            cell.moviesSeriesDirectorLabel.text = moviesSeriesDirectorArray[indexPath.row]
            cell.moviesSeriesGenreLabel.text = moviesSeriesGenreArray[indexPath.row]
            cell.moviesSeriesReleaseYearLabel.text = moviesSeriesReleaseYearArray[indexPath.row]
            cell.moviesSeriesSubjectTextView.text = moviesSeriesSubjectArray[indexPath.row]
            cell.moviesSeriesCastsLabel.text = moviesSeriesCastsArray[indexPath.row]
            cell.ratingsLabel.text = moviesSeriesRatingsArray[indexPath.row]
            cell.commentCountLabel.text = "Yorum Sayısı: \(String(moviesSeriesCommentCountArray[indexPath.row]))"
            cell.moviesSeriesImageView.sd_setImage(with: URL(string: self.imageUrlArray[indexPath.row]))
            return cell
        } else {
            cell.moviesSeriesDocumentIdLabel.text = ""
            cell.moviesSeriesNameLabel.text = ""
            cell.moviesSeriesLabel.text = ""
            cell.moviesSeriesDirectorLabel.text = ""
            cell.moviesSeriesGenreLabel.text = ""
            cell.moviesSeriesReleaseYearLabel.text = ""
            cell.moviesSeriesSubjectTextView.text = ""
            cell.moviesSeriesCastsLabel.text = ""
            cell.ratingsLabel.text = ""
           return cell
        }
        
    }
    
    
    

    

}
