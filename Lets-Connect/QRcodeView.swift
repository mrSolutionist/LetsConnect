//
//  QRcodeView.swift
//  LetsConnect
//
//  Created by HD-045 on 27/04/23.
//

import SwiftUI

import CoreImage
import SwiftUI

struct QRcodeView: View {
    @EnvironmentObject var userViewModel:  UserProfileViewModel

    
    var body: some View {
        
        let data = userViewModel.selectedProfile?.profileURL?.data(using: .ascii) 
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator"),
              let colorFilter = CIFilter(name: "CIFalseColor") else {
            return AnyView(Text("Failed to generate QR code"))
        }
        qrFilter.setValue(data, forKey: "inputMessage")
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.black, forKey: "inputColor0")
        colorFilter.setValue(CIColor.clear, forKey: "inputColor1")
        guard let outputImage = colorFilter.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return AnyView(VStack(alignment: .leading){
             
                Text("No profile Selected")
                Text("Create a profile by clicking on the + button and add a url ")
                Text("example: www.google.com")
                    .fontWeight(.bold)
                Text("Select the profile that u want to share.")
                Text("A QR will appear after selecting a profile")
               
            }.frame(minWidth: 200,minHeight: 200)
                .background(.white))
        }
        let uiImage = UIImage(cgImage: cgImage)
        return AnyView(Image(uiImage: uiImage)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .padding(20))
    }
}




struct QRcodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRcodeView()
            .environmentObject(UserProfileViewModel())
    }
}
