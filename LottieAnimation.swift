//
//  LottieAnimation.swift
//  Lets-Connect
//
//  Created by HD-045 on 03/06/23.
//

import Foundation
import SwiftUI
import Lottie


struct AnimationViewLottie: UIViewRepresentable {
    
    let lottiefile: String

        
        func makeUIView(context: UIViewRepresentableContext<AnimationViewLottie>) -> UIView {
        
            
            let view = UIView(frame: .zero)
            let animationView = LottieAnimationView()
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            let animation = LottieAnimation.named(lottiefile)
            animationView.animation = animation
            animationView.play()
            view.addSubview(animationView)
            animationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                        animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
                        animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
                    ])
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            // Update any necessary configurations or animations here
        }
}
