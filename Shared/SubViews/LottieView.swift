//
//  LottieView.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 02.10.21.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    private let animationView = AnimationView()
    
    var fileName: String
    var loopMode: LottieLoopMode = .loop
    
    var startFrame: AnimationFrameTime?
    var endFrame: AnimationFrameTime?
    
    //var isPaused: Bool = false
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        
        let animation = Animation.named(fileName)!
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        
        let markerNames = animation.markerNames
        
        for name in markerNames {
            print("Marker: \(name)")
            print("Frame: \(String(describing: animation.frameTime(forMarker: name)))")
            print("Progress: \(String(describing: animation.progressTime(forMarker: name)))")
            print("")
        }
        if startFrame != nil && endFrame != nil{
            animationView.play(fromFrame: startFrame!, toFrame: endFrame!, loopMode: loopMode)
        }else if endFrame != nil{
            animationView.play(fromFrame: 0, toFrame: endFrame!, loopMode: loopMode)
        }else{
            animationView.play()
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        /*if isPaused {
            context.coordinator.parent.animationView.pause()
        } else {
            context.coordinator.parent.animationView.play()
            
        }*/
        
        //MARK: Uncomment wenn Animation should be able to pause
    }
    
    /*
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ parent: LottieView) {
            self.parent = parent
        }
    }*/
}

struct LottieButton: UIViewRepresentable {
    var fileName: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: UIViewRepresentableContext<LottieButton>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimatedButton()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        
        animationView.setPlayRange(fromMarker: "touchDownStart", toMarker: "touchDownEnd", event: .touchDown)
        animationView.setPlayRange(fromMarker: "touchDownEnd", toMarker: "touchUpCancel", event: .touchUpOutside)
        animationView.setPlayRange(fromMarker: "touchDownEnd", toMarker: "touchUpEnd", event: .touchUpInside)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieButton>) {
        
    }
}
