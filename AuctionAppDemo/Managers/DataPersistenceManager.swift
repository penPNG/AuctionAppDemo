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
    
    // Good news! UserDefaults has rendered most of this... Redundant!
    
    func saveUsers(_ users: [User], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        users.forEach { user in
            let savedUser = UserEntity(context: context)
            savedUser.address?.city = user.address?.city
            savedUser.address?.geo?.lat = user.address?.geo?.lat
            savedUser.address?.geo?.lng = user.address?.geo?.lng
            savedUser.address?.street = user.address?.street
            savedUser.address?.suite = user.address?.suite
            savedUser.address?.zipcode = user.address?.zipcode
            savedUser.company?.bs = user.company?.bs
            savedUser.company?.catchPhrase = user.company?.catchPhrase
            savedUser.company?.name = user.company?.name
            savedUser.email = user.email
            savedUser.id = Int64(user.id)
            savedUser.name = user.name
            savedUser.phone = user.phone
            savedUser.website = user.website
            
            do {
                
            }
        }
    }
    
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
    
    // Reference for data saving
    
//        let settingsData: SettingsData = .init(showAddress: sender.isOn)
//        DataPersistenceManager.shared.saveSettings(with: settingsData) { result in
//            switch result {
//            case .success(()):
//                #if DEBUG
//                print("Settings saved successfully")
//                #endif
//            case .failure(let error):
//                print("Error saving settings: \(error)")
//            }
//        }
    
    func fetchSettings(completion: @escaping (Result<Settings, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Settings>
        
        request = Settings.fetchRequest()
        
        do {
            let oldSettings = try context.fetch(request) // return default if zero
            if oldSettings.isEmpty {
                completion(.success(defaultSettings(with: context)))
                return
            }
            completion(.success(oldSettings.last!))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Reference for data fetching
    
//    DataPersistenceManager.shared.fetchSettings { result in
//        switch result {
//        case .success(let settings):
//            if settings.showAddress {
//                show = true
//            }
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
    
    private func defaultSettings(with context: NSManagedObjectContext) -> Settings {
        let newSave = Settings.init(context: context)
        newSave.showAddress = true
        return newSave
    }
}
