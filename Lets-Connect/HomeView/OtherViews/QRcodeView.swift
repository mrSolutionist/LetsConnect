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
            
            return AnyView(
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 72))
                        .foregroundColor(.gray)
                    
                    Text("No Profile Selected")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Create a profile by clicking on the + button and add a URL.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Example: www.google.com")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Select the profile that you want to share.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("A QR code will appear after selecting a profile.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                }
                .padding(16)
                .background(LinearGradient(gradient: Gradient(colors: [Color.mint, Color.yellow]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.3), radius: 6, x: 0, y: 2)
            )


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
