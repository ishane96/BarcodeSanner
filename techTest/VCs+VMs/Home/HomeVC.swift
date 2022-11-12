//
//  ViewController.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-10-28.
//

import UIKit
import AVFoundation


class HomeVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var viewCartBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    var captureSes: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var itemCount = 0
    var myCart: [Item] = []
    
    let vm = HomeVM()
    var viewCart = ViewCartVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerView.backgroundColor = UIColor.black
        self.captureSes = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (self.captureSes.canAddInput(videoInput)) {
            self.captureSes.addInput(videoInput)
        } else {
            self.failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.captureSes.canAddOutput(metadataOutput)){
            self.captureSes.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code128]
        } else {
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSes)
        self.previewLayer.frame = self.scannerView.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.scannerView.layer.addSublayer(self.previewLayer)
        
    }
    
    func failed(){
        self.alert(title: "Scanning Not Supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.")
        captureSes = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSes?.isRunning == false) {
            DispatchQueue.global(qos: .background).async {
                self.captureSes.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSes?.isRunning == true) {
            captureSes.stopRunning()
        }
    }
    
    func found(item: Item) {
        self.label.text =  item.itemDescription
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func addToCartBtnActn(_ sender: Any) {
        DispatchQueue.global(qos: .background).async {
            self.captureSes.startRunning()
        }
        if let index = myCart.firstIndex(where: {$0.key == vm.itemObj?.key}) {
            myCart[index].qty += 1
        } else {
            if vm.itemObj != nil {
                myCart.append(vm.itemObj!)
                vm.itemObj = nil
            }
        }
        label.text = nil
        self.scannerView.setNeedsLayout()
    }
    
    @IBAction func viewCartBtnActn(_ sender: Any) {
        if !myCart.isEmpty{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewCartVC") as! ViewCartVC
            vc.myCart = myCart
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeVC: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSes.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            vm.getDataFromFirebase(key: stringValue, completion: { success, message in
                if success {
                    self.found(item: (self.vm.itemObj)!)
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                } else {
                    self.alert(title: "Error", message: message)
                }
            })
        }
        
        dismiss(animated: true)
    }
}
