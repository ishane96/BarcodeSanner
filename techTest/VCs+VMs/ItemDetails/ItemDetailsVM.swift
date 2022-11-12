//
//  ItemDetailsVM.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-03.
//

import Foundation
import FirebaseStorage

class ItemDetailsVM {
    
    func getImages(image: String,  completion: @escaping Completion){
        let storage = Storage.storage()
        var reference: StorageReference!
        reference = storage.reference(forURL: "gs://the-busy-shop.appspot.com/\(image)")
        reference.downloadURL { (url, error) in
            
            if let error = error {
                completion(false, NSURL(string: "")! as URL,error.localizedDescription)
            } else {
                completion(true,url!, "")
            }
        }
    }
}
