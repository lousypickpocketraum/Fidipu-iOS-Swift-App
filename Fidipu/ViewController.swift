//
//  ViewController.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 29.05.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var epostaText: UITextField!
    @IBOutlet weak var sifreText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func girisButton(_ sender: Any) {
        if epostaText.text != "" && sifreText.text != "" {
            Auth.auth().signIn(withEmail: epostaText.text!,password: sifreText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Kullanıcı Adı/Şifre")
        }
    }
    @IBAction func uyeOlButton(_ sender: Any) {
        if epostaText.text != "" && sifreText.text != "" {
            Auth.auth().createUser(withEmail: epostaText.text!, password: sifreText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Hata!", messageInput: "Kullanıcı Adı/Şifre?")
        }
    }
    func makeAlert(titleInput: String, messageInput: String){
        
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        
    }
}

