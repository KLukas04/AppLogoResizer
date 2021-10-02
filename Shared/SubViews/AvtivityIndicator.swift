//
//  AvtivityIndicator.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 02.10.21.
//

import SwiftUI

struct AvtivityIndicator: View {
    
    let style = StrokeStyle(lineWidth: 6, lineCap: .round)
    @State private var animate = false
    let color1 = Color.gray
    let color2 = Color.gray.opacity(0.5)
    
    var body: some View {
        VStack{
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(AngularGradient(gradient: .init(colors: [color1, color2]), center: .center), style: style)
                .rotationEffect(Angle(degrees: animate ? 380 : 0))
                .animation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false))
                .onAppear {
                    animate.toggle()
                }
        }
    }
}

struct AvtivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AvtivityIndicator()
    }
}
