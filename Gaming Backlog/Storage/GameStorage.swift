//
//  GameStorage.swift
//  Gaming Backlog
//
//  Created by Ahmed Al Ramadhan on 10/12/2021.
//

import UIKit
import CoreData

class GameStorage{
    
    static func storeGame(game: Game){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appdelegate.persistentContainer.viewContext
        guard let gameEntity = NSEntityDescription.entity(forEntityName: "Game", in: managedContext) else {return}
        let gameObject = NSManagedObject.init(entity: gameEntity, insertInto: managedContext)
        gameObject.setValue(game.title, forKey: "title")
        gameObject.setValue(game.lastSessionNote, forKey: "lastSessionNote")
        if let image = game.image{
            print("\(game.title) has an image")
            let imageData = image.jpegData(compressionQuality: 1.0)
            gameObject.setValue(imageData, forKey: "image")
        }
        do{
            try managedContext.save()
        } catch{
            print("********** Error occured while saving game **********")
        }
    }
    
    static func updateGame(game: Game, index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(game.title, forKey: "title")
            result[index].setValue(game.lastSessionNote, forKey: "lastSessionNote")
            if let image = game.image{
                let imageData = image.jpegData(compressionQuality: 1.0)
                result[index].setValue(imageData, forKey: "image")
            }
            try context.save()
        } catch{
            print("********** Error occured while updating game **********")
        }
    }
    
    static func deleteGame(index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let gameToBeDeleted = result[index]
            context.delete(gameToBeDeleted)
            try context.save()
        } catch{
            print("********** Error occured while updating game **********")
        }
    }
    
    static func loadGames() -> [Game]{
        var games: [Game] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedGame in result{
                let title = managedGame.value(forKey: "title") as? String
                let details = managedGame.value(forKey: "lastSessionNote") as? String
                var gameImage:UIImage? = nil
                if let imageData = managedGame.value(forKey: "image") as? Data{
                    print("\(title) has an image")
                    gameImage = UIImage(data: imageData)
                }
                let game = Game(title: title ?? "", image: gameImage, lastPlayed: nil, lastSessionNote: details ?? "")
                games.append(game)
            }
        } catch{
            print("********** Error occured while loading games **********")
        }
        
        return games
    }
}
