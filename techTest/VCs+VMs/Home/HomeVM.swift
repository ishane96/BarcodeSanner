//
//  HomeVM.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-02.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore


class HomeVM {
    
    var ref: DatabaseReference!
    
    var itemObj: Item?
    
    func getDataFromFirebase(key: String, completion: @escaping CompletionHandler){
        ref = Database.database().reference()

        ref.child(key).getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false, error!.localizedDescription)
                return
            }

            let value = snapshot?.value as? NSDictionary
            let description = value?["description"] as? String ?? ""
            let image = value?["image"] as? String ?? ""
            let price = value?["price"] as? Double ?? 0

            self.itemObj = Item(key: snapshot?.key,itemDescription: description, image: image, price: price)

            completion(true, "")
        }
    }

}
