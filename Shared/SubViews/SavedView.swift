//
//  SavedView.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 02.10.21.
//

import SwiftUI

struct SavedView: View {
    var body: some View {
        VStack{
            LottieView(fileName: "saved", loopMode: .playOnce, endFrame: 97)
                .frame(width: 200, height: 200)
        }
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
