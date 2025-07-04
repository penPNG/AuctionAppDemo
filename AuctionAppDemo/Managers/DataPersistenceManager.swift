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
    
    func saveUsers(_ users: [User], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // we need to compare the stored data against the new data, primitively for now
        // if the new list is different (and valid, TODO) overwrite the old data.
        fetchUsers { result in
            switch result {
            case .success(let oldUsers):
                if !self.compareUserLists(oldUsers, compareTo: users) {
                    for user in oldUsers {
                        context.delete(user)
                    }
                    
                    users.forEach { user in
                        _ = self.wrapUser(from: user, with: context)
                        do {
                            try context.save()
                            completion(.success(()))
                        } catch {
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        var users: [UserEntity] = []
        
        do {
            let userEntities = try context.fetch(request)
            print(userEntities.count)
            
            for userEntity in userEntities {
                // This is known as overhead! It's a good thing this isn't a performant part of the app
                users.append(userEntity)
            }
            completion(.success(users))
        } catch {
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
    
    // entity casting
    private func wrapUser(from user: User, with context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)
        entity.address_city = user.address?.city
        entity.address_geo_lat = user.address?.geo?.lat
        entity.address_geo_lng = user.address?.geo?.lng
        entity.address_street = user.address?.street
        entity.address_suite = user.address?.suite
        entity.address_zipcode = user.address?.zipcode
        entity.company_bs = user.company?.bs
        entity.company_catchPhrase = user.company?.catchPhrase
        entity.company_name = user.company?.name
        entity.email = user.email
        entity.id = Int64(user.id)
        entity.name = user.name
        entity.phone = user.phone
        entity.username = user.username
        entity.website = user.website
        
        return entity
    }
    
    func unwrapUser(from user: UserEntity) -> User {
        let newUser = User(address: Address(city: user.address_city,
                                            geo: Geo(lat: user.address_geo_lat, lng: user.address_geo_lng),
                                            street: user.address_street, suite: user.address_suite,
                                            zipcode: user.address_zipcode),
                           company: Company(bs: user.company_bs, catchPhrase: user.company_catchPhrase,
                                            name: user.company_name),
                           email: user.email, id: Int(user.id), name: user.name, phone: user.phone,
                           username: user.username, website: user.website)
        return newUser
    }
    
    // Returns true if the lists are equivalent
    private func compareUserLists(_ oldList: [UserEntity], compareTo newList: [User]) -> Bool {
        var isEqual = true
        
        if oldList.count != newList.count {
            isEqual = false
        } else {
            for (index, user) in oldList.enumerated() {
                if user.id != newList[index].id {
                    isEqual = false
                    break
                }
            }
        }
        
        return isEqual
    }
}
