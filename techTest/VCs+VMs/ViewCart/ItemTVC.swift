//
//  ItemTVC.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-10-29.
//

import UIKit

class ItemTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(item: Item) {
        nameLbl.text = item.itemDescription
        qtyLbl.text = "\(item.qty)"
        
        let price = Double(item.qty) * item.price!
        priceLbl.text = "$\(String(describing: price))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
