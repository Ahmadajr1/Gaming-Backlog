//
//  GamesVC.swift
//  Gaming Backlog
//
//  Created by Ahmed Al Ramadhan on 07/12/2021.
//

import UIKit

class GamesVC: UIViewController{
    
    var games:[Game] = []
    
    @IBOutlet weak var gamesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.games = GameStorage.loadGames()
        gamesTableView.dataSource = self
        gamesTableView.delegate = self
        // New game notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.newGameAdded), name: NSNotification.Name(rawValue: "NewGameAdded"), object: nil)
        // Edited game notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.currentGameEdited), name: NSNotification.Name(rawValue: "CurrentGameEdited"), object: nil)
        // Deleted game notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.currentGameDeleted), name: NSNotification.Name(rawValue: "CurrentGameDeleted"), object: nil)
    }
    
    @objc func newGameAdded(notification:Notification){
        if let game = notification.userInfo?["NewGame"] as? Game{
            games.append(game)
            gamesTableView.reloadData()
            GameStorage.storeGame(game: game)
        }
    }
    
    @objc func currentGameEdited(notification:Notification){
        if let game = notification.userInfo?["EditedGame"] as? Game{
            if let index = notification.userInfo?["Index"] as? Int{
                games[index] = game
                gamesTableView.reloadData()
                GameStorage.updateGame(game: game, index: index)
            }
        }
    }
    
    @objc func currentGameDeleted(notification:Notification){
        if let index = notification.userInfo?["Index"] as? Int{
            games.remove(at: index)
            gamesTableView.reloadData()
            GameStorage.deleteGame(index: index)
        }
    }
}

extension GamesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        cell.gameTitleLabel.text = games[indexPath.row].title
        if let image = games[indexPath.row].image{
            cell.gameImageView.image = image
        } else{
            cell.gameImageView.image = UIImage(named: "Default")
        }
        cell.gameImageView.layer.cornerRadius = cell.gameImageView.frame.width/10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameDetailsVC") as? GameDetailsVC{
            vc.game = games[indexPath.row]
            vc.index = indexPath.row
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
