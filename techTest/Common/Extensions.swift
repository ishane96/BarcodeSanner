//
//  AlertProvider.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-02.
//

import UIKit

extension UIViewController {

    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
