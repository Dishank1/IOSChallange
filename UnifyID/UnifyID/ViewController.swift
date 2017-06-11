//
//  ViewController.swift
//  UnifyID
//
//  Created by Dishank Jhaveri on 11/06/17.
//  Copyright © 2017 Dishank Jhaveri. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var myImage: UIImageView!
    let sessionOutput = AVCapturePhotoOutput();
    var previewLayer : AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        let videoDevices = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        do{
            let inputVideoDevice = try AVCaptureDeviceInput(device: videoDevices)
            if captureSession.canAddInput(inputVideoDevice){
                    captureSession.addInput(inputVideoDevice)
                if(captureSession.canAddOutput(sessionOutput)){
                    captureSession.addOutput(sessionOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    
                    captureSession.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        }
        catch{
            print("exception!");
        }
    }
    
    @IBAction func takePhoto(_ sender: Any){
       
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        sessionOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
        }
    
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let delayBy = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        for i in 0 ... 10 {
            DispatchQueue.main.asyncAfter(deadline: delayBy) {
                if let error = error {
                    print("error occure : \(error.localizedDescription)")
                }
                if  let sampleBuffer = photoSampleBuffer,
                    //let previewBuffer = previewPhotoSampleBuffer,
                    let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: nil) {
                    print(UIImage(data: dataImage)?.size as Any)
                    
                    let dataProvider = CGDataProvider(data: dataImage as CFData)
                    let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
                    self.myImage.image = image
                } else {
                    print("some error here")
                }
            }
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

