//
//  RidersService.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import Firebase

class RidersService: NSObject {
    
    func checkRidersUpdates(season: String, success successBlock: @escaping ((String) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        let docRef = db.collection("riders").document(season).collection("update").document("lastUpdate")
        
        docRef.getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                
                print(querySnapshot!.documentID)
                var result = ""
                if (querySnapshot?.data() != nil) {
                    if (querySnapshot?.data()?.keys.contains("lastUpdate"))! {
                        result = querySnapshot!.data()!["lastUpdate"] as? String ?? ""
                    }
                }
                successBlock(result)
            }
        }
    }
    
    func getRiderInfo(riderName : String, success successBlock: @escaping ((Rider) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var rider = Rider()
        
        let docRef = db.collection("riders").document(riderName)
        
        
        docRef.getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                print(querySnapshot!.documentID)
                rider.name = querySnapshot!.documentID
                rider.age = querySnapshot!.data()!["age"] as! String
                rider.birthPlace = querySnapshot!.data()!["birthPlace"] as! String
                rider.country = querySnapshot!.data()!["country"] as! String
                rider.dayOfBirth = querySnapshot!.data()!["dayOfBirth"] as! String
                rider.monthOfBirth = querySnapshot!.data()!["monthOfBirth"] as! String
                rider.yearOfBirth = querySnapshot!.data()!["yearOfBirth"] as! String
                rider.height = querySnapshot!.data()!["height"] as! String
                rider.weight = querySnapshot!.data()!["weight"] as! String
                rider.team = querySnapshot!.data()!["team"] as! String
                rider.category = querySnapshot!.data()!["category"] as! String
                rider.uci = querySnapshot!.data()!["uci"] as! String
                rider.photo = querySnapshot!.data()!["photo"] as! String
                rider.strava = querySnapshot!.data()!["strava"] as! String
                rider.twitter = querySnapshot!.data()!["twitter"] as! String
                successBlock(rider)
            }
        }
    }
    
    func getAllRiders(category : String, season : String, success successBlock: @escaping ((Array<Rider>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var riders = Array<Rider>()
        
        let docRef = db.collection("riders").document(season).collection(category)
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var rider = Rider()
                    rider.id = document.documentID
                    rider.name = document.data()["name"] as? String ?? ""
                    rider.age = document.data()["age"] as? String ?? ""
                    rider.birthPlace = document.data()["birthPlace"] as? String ?? ""
                    rider.country = document.data()["country"] as? String ?? ""
                    rider.dayOfBirth = document.data()["dayOfBirth"] as? String ?? ""
                    rider.monthOfBirth = document.data()["monthOfBirth"] as? String ?? ""
                    rider.yearOfBirth = document.data()["yearOfBirth"] as? String ?? ""
                    rider.height = document.data()["height"] as? String ?? ""
                    rider.weight = document.data()["weight"] as? String ?? ""
                    rider.team = document.data()["team"] as? String ?? ""
                    rider.category = document.data()["category"] as? String ?? ""
                    rider.uci = document.data()["uci"] as? String ?? ""
                    rider.photo = document.data()["photo"] as? String ?? ""
                    rider.strava = document.data()["strava"] as? String ?? ""
                    rider.twitter = document.data()["twitter"] as? String ?? ""
                    riders.append(rider)
                }
                successBlock(riders)
            }
        }
    }
}
