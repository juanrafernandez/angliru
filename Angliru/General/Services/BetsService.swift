//
//  BetsService.swift
//  Angliru
//
//  Created by Juanra Fernández on 10/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import Firebase

class BetsService: NSObject {
    
    func saveBet(raceName: String, riderName: String, season: String, typeBet: String, success successBlock: @escaping (() -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        
        let db = Firestore.firestore()
        let uid = UserDefaults.standard.string(forKey: CURRENT_UID)
        db.collection("users").document(uid!).collection("bets").document(season).collection(raceName).document(typeBet).setData([
            "raceName" : raceName,
            "rider" : riderName,
            "type" : typeBet,
            "points" : 0
            ], merge: true, completion: { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                    failureBlock(err)
                } else {
                    print("Document added")
                    successBlock()
                }
        })
    }
}
