//
//  ViewCartVC.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-10-29.
//

import UIKit
import SnapshotKit

class ViewCartVC: UIViewController {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet var mainUIView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subView: UIView!
    
    var myCart = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.navigationItem.title = "My Cart"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        let current_time = dateFormatter.string(from: date)
        timeLbl.text = current_time
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let current_date = dateFormatter.string(from: date)
        dateLbl.text = current_date
        
        tableView.reloadData()
        tableView.register(UINib(nibName: "ItemTVC", bundle: nil), forCellReuseIdentifier: "itemTVC")
    }
    
    func calculateTotal() -> Double{
        var total: Double = 0
        myCart.forEach { item in
            total = total + (item.price! * Double(item.qty))
        }
        return total
    }
    
    @IBAction func printBtnActn(_ sender: Any) {
        
        let ss = printReceipt()
        let imageToShare = [ ss ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func printReceipt() -> UIImage {
        
        var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, false, UIScreen.main.scale)
        
        let savedContentOffset = self.tableView.contentOffset;
        let savedFrame = self.tableView.frame;
        let savedBackgroundColor = self.tableView.backgroundColor
        
        self.tableView.contentOffset = CGPoint(x: 0, y: 0);
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height);
        self.tableView.backgroundColor = self.tableView.backgroundColor;
        
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height));
        
        let tempSuperView = self.tableView.superview
        
        guard let superView = self.tableView.superview else {
            return UIImage();
        }
        
        var oldConstraints: [NSLayoutConstraint] = []
        for constraint in superView.constraints {
            if constraint.firstItem as? NSObject == self.tableView || constraint.secondItem as? NSObject == self.tableView{
                oldConstraints.append(constraint)
            }
        }
        
        self.tableView.removeFromSuperview()
        tempView.addSubview(self.tableView)
        
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.tableView)
        
        NSLayoutConstraint.activate(oldConstraints)
        
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
        self.tableView.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext();
        
        return image
    }
}
extension ViewCartVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTVC", for: indexPath) as! ItemTVC
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.setupCell(item: myCart[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ItemDetailsVC") as! ItemDetailsVC
        vc.modalPresentationStyle = .popover
        vc.item = myCart[indexPath.row]
        present(vc, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        let totalLbl = UILabel(frame: CGRect(x:view.frame.midX - 10,y: 5 ,width:350,height:150))
        totalLbl.numberOfLines = 0;
        totalLbl.lineBreakMode = .byWordWrapping
        totalLbl.backgroundColor = UIColor.clear
        totalLbl.text  = "Total"
        vw.addSubview(totalLbl)
        
        let priceLbl = UILabel(frame: CGRect(x:view.frame.maxX - 60,y: 5 ,width:100,height:150))
//        priceLbl.numberOfLines = 0;
//        priceLbl.lineBreakMode = .byWordWrapping
//        priceLbl.backgroundColor = UIColor.clear
        priceLbl.text  = "$\(calculateTotal())"
        vw.addSubview(priceLbl)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
}
