//
//  NewGameVC.swift
//  Gaming Backlog
//
//  Created by Ahmed Al Ramadhan on 08/12/2021.
//

import UIKit

class NewGameVC: UIViewController {
    
    var isCreation = true
    var editedGame: Game?
    var editedGameIndex: Int?
    var activeTextView : UITextView? = nil
    var keyboardSize: CGRect?
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var lastSessionNotesTextView: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill up the title, notes and image of the game to be edited.
        if !isCreation{
            mainButton.setTitle("Finish Editing", for: .normal)
            navigationItem.title = "Edit Game"
            if let game = editedGame{
                titleTextField.text = game.title
                lastSessionNotesTextView.text = game.lastSessionNote
                if game.image != nil{
                    gameImageView.image = game.image
                } else{
                    gameImageView.image = UIImage(named: "Default")
                }
            }
        } else{
            gameImageView.image = UIImage(named: "Default")
        }
        
        // Add "done" button to the software keyboard to dismiss the keyboard when user has done adding his notes
        lastSessionNotesTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        titleTextField.delegate = self
        
        // This will be called anytime a keyboard will be shown, this is done in order to raise the whole view up toprevent the keyboard from covering the textView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Use the height of the keyboard to raise the whole view up accordingly
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            navigationController?.navigationBar.isHidden = true
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    
    @objc func tapDone(sender: Any) {
        // To hide the keyboard.
        self.view.endEditing(true)
        navigationController?.navigationBar.isHidden = false
        self.view.frame.origin.y = 0
    }
    
    @IBAction func changeImageButtonClicked(_ sender: Any) {
        // To call imagePicker to choose an image from the users' albums.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func mainButtonClicked(_ sender: UIButton) {
        let game = Game(title: titleTextField.text!, image: gameImageView.image, lastPlayed: nil, lastSessionNote: lastSessionNotesTextView.text)
        if isCreation{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewGameAdded"), object: nil,userInfo: ["NewGame":game])
            presentAlert(message: "Game has been added successfully", isCreation: true)
        } else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"CurrentGameEdited"), object: nil, userInfo: ["EditedGame":game, "Index":editedGameIndex!])
            presentAlert(message: "Game has been edited successfully", isCreation: false)
        }
    }
    
    func clearViews(){
        titleTextField.text = ""
        lastSessionNotesTextView.text = ""
        gameImageView.image = UIImage(named: "Default")
        navigationController?.navigationBar.isHidden = false
    }
    
    func presentAlert(message:String, isCreation:Bool){
        let alert = UIAlertController(title: "Done!", message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "Close", style: .default, handler: {_ in
            self.clearViews()
            if isCreation{
                self.tabBarController?.selectedIndex = 0
            } else{
                self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(closeButton)
        present(alert, animated: true,completion: nil)
    }
}

extension NewGameVC: UINavigationControllerDelegate & UIImagePickerControllerDelegate & UITextFieldDelegate{
    
    // To identify the image selected by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
        gameImageView.image = image
    }
    
    // to dismiss the keyboard when Return is pressed (for textField only)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return true
    }
}

