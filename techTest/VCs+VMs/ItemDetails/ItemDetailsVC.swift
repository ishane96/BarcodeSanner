//
//  ItemDetailsVC.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-03.
//

import UIKit
import FirebaseStorage

class ItemDetailsVC: UIViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var item: Item?
    let vm = ItemDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        itemNameLbl.text = item?.itemDescription
        priceLbl.text = "$\(item?.price ?? 0)"
        getImage()
    }
    
    func getImage(){
        activityIndicator.startAnimating()
        vm.getImages(image: (item?.image)!) {[weak self] success, url, message in
            guard let strongSelf = self else {return}
            strongSelf.activityIndicator.stopAnimating()
            if success {
                let imagedData = NSData(contentsOf: (url))!
                strongSelf.imageView?.image = UIImage(data: imagedData as Data)
            } else {
                strongSelf.alert(title: "Error", message: message)
            }
        }
    }
    
}
