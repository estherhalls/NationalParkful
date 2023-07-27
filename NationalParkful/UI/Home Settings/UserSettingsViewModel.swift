//
//  UserSettingsViewModel.swift
//  NationalParkful
//
//  Created by Esther on 12/8/22.
//

import Foundation

struct UserSettingsViewModel {
    
    
    // access model data
    var user: AppUser?
    private let firebaseService: FirebaseSyncable
    
    
    // Dependency Injection for detail view controller
    /// We need to have the save app user function from the firebase service in order for data to exist on our database via the view model
    /// User object is optional because they may be creating a new user from scratch or updating an existing
    init(user: AppUser? = nil, firebaseService: FirebaseSyncable = FirebaseService()) {
        self.user = user
        self.firebaseService = firebaseService
    }
    
    /// Properties in function are only the ones from the model that we want user to be able to input
    func saveUser(email: String){
        if user != nil {
            updateUser()
        }else{
            let newUser = AppUser(email: email)
            
            firebaseService.saveUser(newUser)
        }
    }
    /// Called in saveUser function above
    func updateUser() {
        guard let user = user else {return}
        firebaseService.saveUser(user)
    }
    
}
