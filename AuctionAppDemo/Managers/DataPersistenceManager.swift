//
//  DataPersistenceManager.swift
//  AuctionAppDemo
//
//  Created by student on 5/22/25.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func saveSettings(with newSettings: SettingsData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let settingsToSave = Settings(context: context)
        settingsToSave.showAddress = newSettings.showAddress
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func fetchSettings(completion: @escaping (Result<Settings, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Settings>
        
        request = Settings.fetchRequest()
        
        do {
            let oldSettings = try context.fetch(request)
            completion(.success(oldSettings.last!))
        } catch {
            completion(.failure(error))
        }
    }
}
