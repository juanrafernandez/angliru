//
//  RaceService.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import Firebase

class RacesService: NSObject {
    
    func getCalendarInfo(season : String, success successBlock: @escaping ((Array<Race>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var races = Array<Race>()
        
        let docRef = db.collection("calendar").document(season).collection(CATEGORY_WORLDTOUR)
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
               
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    var raceCalendar = Race()
                    raceCalendar.position = document.data()["position"] as! Int
                    raceCalendar.name = document.data()["name"] as! String
                    raceCalendar.date = document.data()["date"] as! String
                    raceCalendar.dateStart = document.data()["dateStart"] as! String
                    raceCalendar.dateEnd = document.data()["dateEnd"] as! String
                    raceCalendar.country = document.data()["country"] as! String
                    raceCalendar.distance = document.data()["distance"] as? Double ?? 0
                    raceCalendar.web = document.data()["web"] as? String ?? ""
                    raceCalendar.twitter = document.data()["twitter"] as? String ?? ""
                    raceCalendar.altimetry = document.data()["altimetry"] as? Double ?? 0.0
                    raceCalendar.profileImage = document.data()["profileImage"] as? String ?? ""

                    self.getStages(raceName: document.documentID, success: { (result: Array<Stage>) in
                        raceCalendar.stages = result
                        //races.append(raceCalendar)
                        
                            //successBlock(races)
                            self.getTeamsByRace(raceName: document.documentID, season: season, success: { (result) in
                                raceCalendar.teams = result
                                races.append(raceCalendar)
                                if races.count >= querySnapshot!.documents.count {
                                    successBlock(races)
                                }
                            }, failure: { (err) in
                                failureBlock(err)
                            })
                        
                    }, failure: { (err) in
                        failureBlock(err)
                    })
                    
                }
                //successBlock(races)
            }
        }
    }
    
    func getStages(raceName : String, success successBlock: @escaping ((Array<Stage>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var stages = Array<Stage>()
        
        let docRef = db.collection("races").document(raceName).collection("2019").document("stages").collection("routes").order(by: "position")
        
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                   // let stage = document.documentID
                    var stage = Stage()
                    stage.name = document.data()["name"] as? String ?? ""
                    if stage.name == "" {
                        stage.name = document.documentID
                    }
                    stage.date = document.data()["date"] as? String ?? ""
                    stage.month = document.data()["month"] as? String ?? ""
                    stage.day = document.data()["day"] as? String ?? ""
                    stage.year = document.data()["year"] as? String ?? ""
                    stage.destiny = document.data()["destiny"] as? String ?? ""
                    stage.type = document.data()["type"] as? String ?? ""
                    stage.distance = document.data()["distance"] as? String ?? ""
                    stage.origin = document.data()["origin"] as? String ?? ""
                    stage.position = document.data()["position"] as? Int ?? -1
                    
                    if (document.data().keys.contains("profileImage")) {
                        stage.profileImage = document.data()["profileImage"] as? String ?? ""
                    }
                    if (document.data().keys.contains("altimetry")) {
                        stage.altimetry = document.data()["altimetry"] as? String ?? ""
                    }
                    //successBlock(stage)
                    
//                    var results = Array<Classification>()
//                    let docRefs = db.collection("races").document(raceName).collection("2019").document("stages").collection("routes").document(document.documentID).collection("result").order(by: "position")
//
//                    docRefs.getDocuments() { (querySnapshot, err) in
//                        if let err = err {
//                            print("Error getting documents: \(err)")
//                            failureBlock(err)
//                        } else {
//                            for document in querySnapshot!.documents {
//                                print("\(document.documentID) => \(document.data())")
//                                var result = Classification()
//                                result.country = document.data()["country"] as? String ?? ""
//                                result.name = document.data()["name"] as? String ?? ""
//                                result.points = document.data()["points"] as? String ?? ""
//                                result.team = document.data()["team"] as? String ?? ""
//                                result.teamAbreviation = document.data()["nameAbreviation"] as? String ?? ""
//                                result.time = document.data()["time"] as? String ?? ""
//                                results.append(result)
//                            }
//                            stage.result = results
//                            successBlock(stage)
//                        }
//                    }
                
                    stages.append(stage)
                }
                successBlock(stages)
            }
        }
    }
    
    func getStageInfo(raceName : String, stageName: String, season: String,success successBlock: @escaping ((Stage) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var stage = Stage()
        
        let docRef = db.collection("races").document(raceName).collection(season).document("stages").collection("routes").document(stageName)
        
        docRef.getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                print(querySnapshot!.documentID)
                stage.name = querySnapshot!.documentID
                stage.date = querySnapshot!.data()!["date"] as! String
                stage.month = querySnapshot!.data()!["month"] as! String
                stage.day = querySnapshot!.data()!["day"] as! String
                stage.year = querySnapshot!.data()!["year"] as! String
                stage.destiny = querySnapshot!.data()!["destiny"] as! String
                stage.type = querySnapshot!.data()!["type"] as? String ?? ""
                stage.distance = querySnapshot!.data()!["distance"] as! String
                stage.origin = querySnapshot!.data()!["origin"] as! String
                stage.position = querySnapshot!.data()!["position"] as! Int
                
                if (querySnapshot?.data()?.keys.contains("profileImage"))! {
                    stage.profileImage = querySnapshot!.data()!["profileImage"] as! String
                }
                if (querySnapshot?.data()?.keys.contains("altimetry"))! {
                    stage.altimetry = querySnapshot!.data()!["altimetry"] as! String
                }
                var results = Array<Classification>()
                let docRefs = db.collection("races").document(raceName).collection(Utils.getCurrentYear ()).document("stages").collection("routes").document(stageName).collection("result").order(by: "position")
                
                docRefs.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        failureBlock(err)
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            var result = Classification()
                            result.country = document.data()["country"] as! String
                            result.name = document.data()["name"] as! String
                            result.points = document.data()["points"] as? String ?? ""
                            result.team = document.data()["team"] as! String
                            result.teamAbreviation = document.data()["nameAbreviation"] as? String ?? ""
                            result.time = document.data()["time"] as? String ?? ""
                            results.append(result)
                        }
                        stage.result = results
                        successBlock(stage)
                    }
                }
            }
        }
    }
    
    func getTeamsByRace(raceName : String, season : String, success successBlock: @escaping ((Array<String>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        var teams = Array<String>()
        
        let docRef = db.collection("races").document(raceName).collection(season).document("classifications").collection(CLASSIFICATION_GENERAL)
        
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let team = document.data()["team"] as? String ?? ""
                    if !teams.contains(team) {
                        teams.append(team)
                    }
                }
                successBlock(teams)
            }
        }
    }
    
    func getClassificationByType(raceName: String, season: String, type: String, success successBlock: @escaping ((Array<Classification>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        
        var results = Array<Classification>()
        let docRefs = db.collection("races").document(raceName).collection(season).document("classifications").collection(type).order(by: "position")
        
        docRefs.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var result = Classification()
                    result.country = document.data()["country"] as! String
                    result.name = document.data()["name"] as! String
                    result.points = document.data()["points"] as! String
                    result.team = document.data()["team"] as! String
                    result.teamAbreviation = document.data()["teamAbreviation"] as! String
                    result.time = document.data()["time"] as! String
                    results.append(result)
                }
                successBlock(results)
            }
        }
    }
    
    func getTeamRidersByRace(season: String, teamName: String, raceName: String, success successBlock: @escaping ((Array<Classification>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        let db = Firestore.firestore()
        
        var results = Array<Classification>()
        let docRefs = db.collection("races").document(raceName).collection(season).document("classifications").collection("GC")
        
        docRefs.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                failureBlock(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let team = document.data()["team"] as! String
                    if team == teamName {
                        var result = Classification()
                        result.country = document.data()["country"] as! String
                        result.name = document.data()["name"] as! String
                        result.points = document.data()["points"] as! String
                        result.team = document.data()["team"] as! String
                        result.teamAbreviation = document.data()["teamAbreviation"] as! String
                        result.time = document.data()["time"] as! String
                        results.append(result)
                    }
                }
                successBlock(results)
            }
        }
    }
    
    func downloadProfileImage(imageUrl:String, success successBlock: @escaping ((UIImage) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        let storageRef = Storage.storage().reference().child(imageUrl)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                failureBlock(error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                successBlock(image!)
            }
        }
    }
}
