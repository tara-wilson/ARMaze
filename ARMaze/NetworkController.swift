//
//  NetworkController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/16/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase

class NetworkController: NSObject {
    
    let ref = Database.database().reference()
    
    func getRadius(completion: @escaping((Int?) -> Void)) {
        let string = "radius"
        let query = ref.child(string)
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? Int {
                self.saveRadius(radius: dict)
                completion(dict)
            }
            else {
                completion(nil)
            }
        }, withCancel: {
            (error) in
            completion(nil)
        })

    }
    
    func saveRadius(radius: Int) {
        UserDefaults.standard.set(radius, forKey: "radius")
    }
    
    func saveLatLongs(items: [String: CLLocation]) {
        let defaults = UserDefaults.standard
        let dict: NSDictionary = items as NSDictionary
        for key in dict.allKeys as! [String] {
            let item = dict[key] as! CLLocation
            defaults.set(CGFloat(item.coordinate.latitude), forKey: "\(key)_lat")
            defaults.set(CGFloat(item.coordinate.longitude), forKey: "\(key)_long")
        }
    }
    
    func getLatLong(completion: @escaping(([String: CLLocation]?) -> Void)) {
        let string = "easyCoordinates"
        let query = ref.child(string)
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            var allcoords = [String: CLLocation]()
            if let dict = snapshot.value {
                if let dictArr = dict as? NSDictionary {
                    for item in (dictArr.allKeys as? [String])! {
                        if let coords = dictArr[item] as? NSDictionary {
                            if let lat = coords["lat"] as? Float, let long = coords["long"] as? Float {
                                let coord = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                                allcoords[item] = coord
                            }
                        }
                    }
                    self.saveLatLongs(items: allcoords)
                    completion(allcoords)
                }
            }
            else {
                completion(nil)
            }
        }, withCancel: {
            (error) in
            completion(nil)
        })
    }
    
    func verifyName(name: String, completion: @escaping((Bool) -> Void)) {
        let string = "users/\(name)/score"
        let query = ref.child(string)
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? Int {
                print(dict)
                completion(false)
            } else {
                self.saveName(name: name, completion: {
                    success in
                    completion(true)
                })
            }
        }, withCancel: {
            (error) in
            completion(false)
        })


    }
    
    func saveName(name: String, completion: @escaping((Bool) -> Void)) {
        let newRef = ref
            .child("users/\(name)")
        newRef.setValue(["score":0, "time":0], withCompletionBlock: {
            comp in
            completion(true)
        })
    }
    
    func getName() -> String? {
        return UserDefaults.standard.string(forKey: "username")
    }
    
    func getScore(completion: @escaping((Score?) -> Void)) {
        if let name = getName() {
            let string = "users/\(name)"
            let query = ref.child(string)
            query.observeSingleEvent(of: .value, with: {
                snapshot in
                let val = snapshot.value
                if let dict = val as? NSDictionary {
                    if let score = dict["score"] as? Int, let time = dict["time"] as? Int {
                        let newscore = Score()
                        newscore.points = score
                        newscore.time = time
                        completion(newscore)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }, withCancel: {
                (error) in
                completion(nil)
            })
        }
    }
    
    func sendScore(score: Score, completion: @escaping((Int) -> Void)) {
        if let name = getName() {
            let newRef = ref
                .child("users/\(name)/score")
            newRef.setValue(score.points)
            completion(score.points)
        }
    }
    
    func sendTime(time: Int) {
        if let name = getName() {
            let string = "users/\(name)/time"
            let query = ref.child(string)
            query.observeSingleEvent(of: .value, with: {
                snapshot in
                if let val = snapshot.value as? Int {
                    if time >= val {
                        self.ref.child("users/\(name)/time").setValue(time)
                    }
                } else {
                    self.ref.child("users/\(name)/time").setValue(time)
                }
            }, withCancel: {
                (error) in
            })
        }
    }
    
    func getLeaderBoard(completion: @escaping(([String: Score]?) -> Void)) {
        let string = "users"
        let query = ref.child(string).queryOrdered(byChild: "score")
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            let snap = snapshot.value
            var leaderboard = [String: Score]()
            if let dict = snap as? NSDictionary {
                let allusers = dict.allKeys as! [String]
                for key in allusers {
                    if let scoreandpoints = dict[key] as? NSDictionary {
                        if let score = scoreandpoints["score"] as? Int {
                            if let time = scoreandpoints["time"] as? Int {
                                let newscore = Score()
                                newscore.points = score
                                newscore.time = time
                                leaderboard[key] = newscore
                            }
                        }
                    }
                }
                completion(leaderboard)
            }
            else {
                completion(nil)
            }
        }, withCancel: {
            (error) in
            completion(nil)
        })
    }
    
}
