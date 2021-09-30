//
//  FinishScreen.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI

struct FinishScreen: View {
    @EnvironmentObject var viewModel: LogoViewModel
    
    var body: some View {
        VStack{
            Image(systemName: "folder.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                
            Text("\(viewModel.resizedImages.count) images resized").bold()
                .font(.callout)
            
            Spacer()
            
            Button {
                viewModel.resizeImages()
                viewModel.zipImages { url in
                    print("URL of zip:" + "\(String(describing: url))")
                    
                }
            } label: {
                Text("Save")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color("Primary"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
            }
            .padding(.bottom)

        }
    }
}

struct FinishScreen_Previews: PreviewProvider {
    static var previews: some View {
        FinishScreen()
    }
}
