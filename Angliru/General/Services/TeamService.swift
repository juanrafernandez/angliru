//
//  TeamService.swift
//  Angliru
//
//  Created by Juanra Fernández on 05/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import Firebase

class TeamsService: NSObject {

    func getTeams(season : String, category: String, success successBlock: @escaping ((Array<Team>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var teams = Array<Team>()
        
        let docRef = db.collection("teams").document(season).collection(category)
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var team = Team()
                    team.name = document.data()["name"] as! String
                    team.category = category
                    team.country = document.data()["country"] as! String
                    if document.data().keys.contains("teamImage") {
                        team.teamImage = document.data()["teamImage"] as! String
                        team.maillotImage = document.data()["maillotImage"] as! String
                        team.maillotBrand = document.data()["maillot"] as! String
                        team.bikeImage = document.data()["bikesImage"] as! String
                        team.bikeBrand = document.data()["bikes"] as! String
                        team.nameAbreviation = document.data()["nameAbreviation"] as! String
                        team.officialWeb = document.data()["officialWeb"] as! String
                        team.twitter = document.data()["twitter"] as! String
                        team.managerName = document.data()["managerName"] as? String ?? ""
                    }
                    teams.append(team)
                }
                successBlock(teams)
            }
        }
    }
    
    func getTeamRiders(season : String, team: Team, success successBlock: @escaping ((Array<Rider>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var riders = Array<Rider>()
        
        let docRef = db.collection("teams").document(season).collection(team.category).document(team.name).collection("plantilla")
        
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var rider = Rider()
                    rider.name = document.data()["name"] as! String
                    rider.country = document.data()["country"] as! String
                    rider.age = document.data()["age"] as! String
                    riders.append(rider)
                }
                successBlock(riders)
            }
        }
    }
}
