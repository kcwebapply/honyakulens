//
//  cameraViewController.swift
//  honyakun
//
//  Created by WKC on 2016/09/04.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class cameraViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    
    //撮影した画像
    var image:UIImage!
    
    // アルバム用
    var PictView:touchPict!
    
    //撮影ボタン
    var circle:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCameraLayer()
        setSubViews()
    }
    
    
    func setSubViews(){
        
        //撮影ボタン
        _ = UIButton(frame:CGRect(x: self.view.frame.size.width/2-20,y: self.view.frame.size.height-25,width: 40,height: 40))
        
        
        let ucircle = UIButton(frame:CGRect(x: self.view.frame.size.width/2-25,y: self.view.frame.size.height-55,width: 50,height: 50))
        ucircle.backgroundColor=UIColorFromRGB(0xFF5BBE)
        ucircle.layer.cornerRadius=26.0
        
        //var circle = UIButton(frame:CGRectMake(widthV/2-25,5,50,50))
        circle = UIButton(frame:CGRect(x: self.view.frame.size.width/2-22.5,y: self.view.frame.size.height-52.5,width: 45,height: 45))
        circle.backgroundColor=UIColorFromRGB(0xFF5BBE)
        circle.layer.cornerRadius=24.0
        circle.layer.borderWidth=2.0
        circle.layer.borderColor = UIColorFromRGB(0xFFFFFF).cgColor
        
        let cameraImage = UIImage(named:"cw.png")
        let resizeSize = CGSize(width: 30, height: 30)
        
        UIGraphicsBeginImageContextWithOptions(resizeSize,false,0.0)
        cameraImage!.draw(in: CGRect(x: 0,y: 0,width: resizeSize.width,height: resizeSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        circle.setImage(resizeImage, for: UIControlState())
        circle.addTarget(self, action: #selector(cameraViewController.camera), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(ucircle)
        self.view.addSubview(circle)
        
        
        //閉じるボタン
        var exit:UIButton!
        exit = UIButton(frame:CGRect(x: self.view.frame.size.width/10,y: self.view.frame.size.height-50,width: self.view.frame.size.width/5,height: 40))
        exit.setTitle("閉じる",for:UIControlState())
        exit.addTarget(self, action: #selector(cameraViewController.disView), for: UIControlEvents.touchUpInside)
        exit.setTitleColor(UIColorFromRGB(0xFF5BBE), for: UIControlState())
        exit.tintColor=UIColorFromRGB(0xFF5BBE)
        self.view.addSubview(exit)
        
        //アルバムボタン
        let siroIm = UIImage(named:"p3.png")
        let size2 = CGSize(width: 32, height: 32)
        UIGraphicsBeginImageContextWithOptions(size2,false,0.0)
        siroIm!.draw(in: CGRect(x: 0, y: 0, width: size2.width, height: size2.height))
        let resizeImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var AlbumButton:UIButton!
        AlbumButton = UIButton(frame:CGRect(x: self.view.frame.size.width*4/5,y: self.view.frame.size.height-46,width: self.view.frame.size.width/10,height: self.view.frame.size.width/10))
        AlbumButton.setImage(resizeImage2, for: UIControlState())
        AlbumButton.addTarget(self, action: #selector(cameraViewController.pickerAlbumView), for: .touchUpInside)
        self.view.addSubview(AlbumButton)
        //AlbumButton.back
        
        self.view.backgroundColor = UIColorFromRGB(0xFFFFF3)
        


    }
    
    func setCameraLayer(){
        mySession = AVCaptureSession()
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices!{
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        var videoInput:AVCaptureDeviceInput
        do{
            videoInput = try AVCaptureDeviceInput(device:myDevice)
            mySession.addInput(videoInput)
            //mySession.addInput(videoInput)
            
            
        }catch{
            
        }
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:mySession) as AVCaptureVideoPreviewLayer
        myVideoLayer.frame = CGRect(x: 0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height-60)
        
        //self.navigationController!.navigationBar.bounds.size.height
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
    }
    
    
    func camera(){
        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            self.image=UIImage(data:myImageData)
            self.PopImage()
            self.circle.isEnabled = false
            
        })
        
    }
    
    
    
    func PopImage(){
        let cont = instantiate(cameraEditController.self,storyboard: "cameraEditController")
        cont.image = self.image
        self.circle.isEnabled = true
        self.navigationController?.pushViewController(cont, animated: true)
    }
    
    
    func pickerAlbumView(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    

    
    
    func disView(){
        self.navigationController?.popViewController(animated: true)
    }

  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
         self.circle.isEnabled = true
    }

    
    
}


extension cameraViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 選択した画像・写真を取得し、imageViewに表示
        if let info = editingInfo, let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.image = editedImage
            self.PopImage()
        }else{
            self.image = image
            self.PopImage()
        }
        
        // フォトライブラリの画像・写真選択画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }
}
