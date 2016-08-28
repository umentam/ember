//
//  EmberUser.swift
//  bounceapp
//
//  Created by Gabriel Wamunyu on 8/7/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import Foundation
import FirebaseAuth

class EmberUser : NSObject{
    
    var signedIn = false
    let debug = false
    
    var userPreferences = NSArray()
    
    let ref = FIRDatabase.database().referenceWithPath(BounceConstants.firebaseSchoolRoot())
    
  
    func isSignedIn(completionHandler: (Bool) ->()) {
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if  (user != nil) {
                // User is signed in.
                completionHandler(true)
            } else {
                // No user is signed in.
                completionHandler(false)
            }
        }

       
    }
    
    func loadPreferences(completion : (NSDictionary)->()){
        
        if let userID = FIRAuth.auth()?.currentUser?.uid{
            
            ref.child("users").child(userID).child("preferences").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let snap = snapshot.value as? NSDictionary{ // making sure org tags list exists
                    self.userPreferences = Array(snap.allKeys)
                    //                print(snap)
                    completion(snap)
                }
                
            }) { (error) in
                print("error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func matchesUserPreferences(orgPreferences : NSArray)->Bool{
//        print("user prefs: \(self.userPreferences)")
//        print("org prefs: \(orgPreferences)")
        
        let orgArray = orgPreferences
        
        let boolArray = self.userPreferences.map { (element) -> Bool in
//            print(element)
            return orgArray.containsObject(element)
        }
//        print(boolArray)
        if(boolArray).contains(true){
            return true
        }
        return false
        
    }
    
    func isUserPost(snap : FIRDataSnapshot)->Bool{
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        let bounceSnap = EmberSnapShot(snapShot: snap)
        
        let postDetails = bounceSnap.getPostDetails() as NSDictionary
        
        if((postDetails.objectForKey(BounceConstants.firebaseHomefeedEventPosterLink())) == nil){
            
            if(postDetails.objectForKey(BounceConstants.firebaseHomefeedMediaInfo())!.isKindOfClass(NSDictionary)){
                
                let values = (postDetails.objectForKey(BounceConstants.firebaseHomefeedMediaInfo())!.allValues) as NSArray
                
                for i in 0 ..< values.count  {
                    
                    let first = values.objectAtIndex(i) as! NSDictionary
                    let uid = first.objectForKey("userID") as! NSString
                    
                    if(uid == userID){
                        return true
                    }
                    
                }
                
            }else{
                
                let values = postDetails.objectForKey(BounceConstants.firebaseHomefeedMediaInfo()) as! NSArray
                for i in 0 ..< values.count  {
                    
                    let first = values.objectAtIndex(i) as! NSDictionary
                    let uid = first.objectForKey("userID") as! NSString
                    
                    if(uid == userID){
                        return true
                    }
                    
                }
            }
        }
        return false
    }
    
    func userFollowsOrg(key : NSString)->Bool{
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if((userDefaults.objectForKey(key as String)) != nil){
            return true
        }
        return false
    }
    
    func getUser(userObject: (FIRUser)->()){
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                userObject(user)
            }
        }
    }
    
    func isAdminOf(orgID : NSString, completionHandler : (Bool) ->()){
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        if(debug){
            print("orgId: \(orgID)")
//            let userID = "5P242MmuhRTgbqZkaieBxNWdhpp1" // Anthony
//            let userID = "11l144reIqdTmYX4bOQqL2SfEQ52" // Michael
        }
        

        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value

            if(self.debug){
                print("snapshot: \(snapshot)")
            }
            
            if var snap = snapshot.value!["adminOf"]!{ // making sure admin list exists for user
                
                snap = snapshot.value!["adminOf"] as! NSArray
                
                if(snap.containsObject(orgID)){
                    
                    if(self.debug){
                        print("found")
                    }
                    
                    completionHandler(true)
                }else{
                    if(self.debug){
                        print("NOT found")
                    }
                    completionHandler(false)
                }
                
            } else {
                 completionHandler(false)
            }
        
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
}