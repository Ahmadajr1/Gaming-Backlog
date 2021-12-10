//
//  GameDetailsVC.swift
//  Gaming Backlog
//
//  Created by Ahmed Al Ramadhan on 07/12/2021.
//

import UIKit

class GameDetailsVC: UIViewController {
    
    var game: Game!
    var index: Int!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var lastSessionNote: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.currentGameEdited), name: NSNotification.Name(rawValue: "CurrentGameEdited"), object: nil)
    }
    
    // To update game details after editing
    @objc func currentGameEdited(notification:Notification){
        if let game = notification.userInfo?["EditedGame"] as? Game{
            self.game = game
            setupUI()
        }
    }
    
    func setupUI(){
        gameTitleLabel.text = game.title
        lastSessionNote.text = game.lastSessionNote
        if game.image != nil{
            gameImageView.image = game.image
        } else{
            gameImageView.image = UIImage(named: "Default")
        }
    }
    
    @IBAction func editGameButtonClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewGameVC") as? NewGameVC{
            vc.isCreation = false
            vc.editedGame = game
            vc.editedGameIndex = index
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        // To show a waring when delete button is pressed
        let warningAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this game?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "close", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "Confirm", style: .destructive, handler: {_ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentGameDeleted"), object: nil,userInfo: ["Index":self.index!])
            let alert = UIAlertController(title: "Done!", message: "Game has been deleted successfully", preferredStyle: .alert)
            let done = UIAlertAction(title: "Done", style: .default, handler: {_ in
                    self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(done)
            self.present(alert, animated: true,completion: nil)
        })
        warningAlert.addAction(cancel)
        warningAlert.addAction(confirm)
        present(warningAlert, animated: true,completion: nil)
    }
}
