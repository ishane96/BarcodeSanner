//
//  LoginVC.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-03.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    
    let vm = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginApiCall()
    }
    
    @objc func loginBtnActn(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginApiCall(){
        vm.login(completion: { [weak self] success, message in
            guard let strongSelf = self else {return}
            if success {
                strongSelf.loginBtn.addTarget(self, action: #selector(strongSelf.loginBtnActn), for: .touchUpInside)
            } else {
                strongSelf.alert(title: "Error", message: message)
            }
        })
    }
}
