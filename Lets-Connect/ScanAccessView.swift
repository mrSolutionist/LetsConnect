//
//  ScanAccessView.swift
//  Lets-Connect
//
//  Created by HD-045 on 30/04/23.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit


struct ScannerView: UIViewControllerRepresentable {

    typealias UIViewControllerType = ScannerViewController
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        return ScannerViewController()
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        
    }
}


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ObservableObject {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
       
        DispatchQueue.global(qos: .background).async {
 
            // start running captureSession
            self.captureSession.startRunning()
        }

   
    
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
    }
}




struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScannerView()
                .frame(width: 300, height: 300)
                .background(Color("Black"))
                                    .cornerRadius(16)
            
            
        }
        
    }
}
