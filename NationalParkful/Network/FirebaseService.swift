//
//  FirebaseService.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation
import FirebaseFirestore

protocol FirebaseSyncable {
    
}

struct FirebaseService: FirebaseSyncable {
    
    let ref = Firestore.firestore()
    
} // End of Struct
