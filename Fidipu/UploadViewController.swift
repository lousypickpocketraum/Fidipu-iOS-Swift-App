//
//  UploadViewController.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 31.05.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var moviesSeriesNameTextField: UITextField!
    @IBOutlet weak var moviesSeriesDirectorTextField: UITextField!
    @IBOutlet weak var moviesSeriesCastsTextField: UITextField!
    @IBOutlet weak var moviesSeriesGenreTextField: UITextField!
    @IBOutlet weak var moviesSeriesReleaseYearTextField: UITextField!
    @IBOutlet weak var moviesSeriesSubjectTextView: UITextView!
    @IBOutlet weak var moviesSeriesTextField: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser!.email! == "admin@fidipu.com" {
            uploadImageView.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            uploadImageView.addGestureRecognizer(gestureRecognizer)
            uploadButton.isHidden = false
        }
        else {
            uploadButton.isHidden = true
        }
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imagesFolder = storageReference.child("images")
        
        if let data = uploadImageView?.image?.jpegData(compressionQuality: 0.5) {
            let imageReference = imagesFolder.child("\(moviesSeriesNameTextField.text!) Poster.jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata")
                    
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //Database
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestoreContent = ["date" : FieldValue.serverTimestamp(), "imageUrl" : imageUrl!, "moviesSeries" : self.moviesSeriesTextField.text!, "moviesSeriesName" : self.moviesSeriesNameTextField.text!, "moviesSeriesDirector" : self.moviesSeriesDirectorTextField.text!,"moviesSeriesCasts" : self.moviesSeriesCastsTextField.text!, "moviesSeriesGenre" : self.moviesSeriesGenreTextField.text!, "moviesSeriesReleaseYear" : self.moviesSeriesReleaseYearTextField.text!, "moviesSeriesSubject" : self.moviesSeriesSubjectTextView.text!,"ratings" : "0.0", "commentCount" : 0, "postedBy" : Auth.auth().currentUser!.email!] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Contents").addDocument(data: firestoreContent, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata")
                                } else {
                                    self.uploadImageView.image = UIImage(named: "ResimYuklama.jpeg" )
                                    self.moviesSeriesTextField.text = ""
                                    self.moviesSeriesNameTextField.text = ""
                                    self.moviesSeriesDirectorTextField.text = ""
                                    self.moviesSeriesGenreTextField.text = ""
                                    self.moviesSeriesReleaseYearTextField.text = ""
                                    self.moviesSeriesCastsTextField.text = ""
                                    self.moviesSeriesSubjectTextView.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
}
