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
    
    func getBetsOpen(season:String, raceName:String, success successBlock: @escaping ((Bool) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        
        let db = Firestore.firestore()
        let docRef = db.collection("races").document(raceName).collection(season).document("bets")
        
        docRef.getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                print(querySnapshot!.documentID)
                var result = false
                if querySnapshot!.data() != nil {
                    result = querySnapshot?.data()!["open"] as? Bool ?? false
                }
                successBlock(result)
            }
        }
    }
}
