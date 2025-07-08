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
    
    func saveDownloadedUsers(_ users: [User], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // we need to compare the stored data against the new data, primitively for now
        // if the new list is different (and valid, TODO) overwrite the old data.
        fetchDownloadedUsers { result in
            switch result {
            case .success(let oldUsers):
                if !DataPersistenceManager.compareUserLists(oldUsers, compareTo: users) {
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
    
    func saveCreatedUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        fetchCreatedUsers { Result in
            switch Result {
            case .success(let createdUsers):
                let createdUserEntity = self.castUserEntityToCreatedUserEntity(from: self.wrapUser(from: user, with: context), with: context) 
                createdUserEntity.id = Int64(createdUsers.count)
                do {
                    try context.save()
                    completion(.success(()))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDownloadedUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        var users: [UserEntity] = []
        
        do {
            let userEntities = try context.fetch(request)
            print("\(userEntities.count) users")
            
            for userEntity in userEntities {
                // This is known as overhead! It's a good thing this isn't a performant part of the app
                print("fetched \(userEntity.name ?? "no name")")
                users.append(userEntity)
            }
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchCreatedUsers(completion: @escaping (Result<[CreatedUserEntity], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<CreatedUserEntity> = CreatedUserEntity.fetchRequest()
        var createdUsers: [CreatedUserEntity] = []
        
        do {
            let createdUserEntities = try context.fetch(request)
            print("\(createdUserEntities.count) new users")
            
            for createdUserEntity in createdUserEntities {
                createdUsers.append(createdUserEntity)
            }
            completion(.success(createdUsers))
        } catch {
            print("failed")
            completion(.failure(error))
        }
    }
    
    // The biggest problem with this implementation is that we're repurposing the .id value to refer to a
    // localID. This requires blindly assigning a localID to the .id field when fetching. This also means
    // being carefull to not delete a local user with a fetched user
    
    func deleteCreatedUser(at createdUserID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<CreatedUserEntity> = CreatedUserEntity.fetchRequest()
        
        do {
            let createdUserEntities = try context.fetch(request)
            for createdUserEntity in createdUserEntities {
                if createdUserEntity.id == createdUserID {
                    context.delete(createdUserEntity)
                    try context.save()
                    print("deleted \(createdUserEntity.name ?? "") at \(createdUserID)")
                    completion(.success(()))
                }
            }
            
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
}
    
extension DataPersistenceManager {
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
        
        #if DEBUG
        print("Successfully cast \(entity.name ?? "") from User")
        #endif
        
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
    
    func unwrapCreatedUser(from user: CreatedUserEntity) -> User {
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
    
    func castUserEntityToCreatedUserEntity(from user: UserEntity, with context: NSManagedObjectContext) -> CreatedUserEntity {
        let entity = CreatedUserEntity(context: context)
        entity.address_city = user.address_city
        entity.address_geo_lat = user.address_geo_lat
        entity.address_geo_lng = user.address_geo_lng
        entity.address_street = user.address_street
        entity.address_suite = user.address_suite
        entity.address_zipcode = user.address_zipcode
        entity.company_bs = user.company_bs
        entity.company_catchPhrase = user.company_catchPhrase
        entity.company_name = user.company_name
        entity.email = user.email
        entity.id = Int64(user.id)
        entity.name = user.name
        entity.phone = user.phone
        entity.username = user.username
        entity.website = user.website
        
        #if DEBUG
        print("successfully cast \(entity.name ?? "") from UserEntity")
        #endif
        
        return entity
    }
    
    // Returns true if the lists are equivalent
    static func compareUserLists(_ oldList: [UserEntity], compareTo newList: [User]) -> Bool {
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
    
    static func compareUserLists(_ oldList: [CreatedUserEntity], compareTo newList: [User]) -> Bool {
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
