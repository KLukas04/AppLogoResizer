//
//  SizeSelectionView.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI

struct SizeSelectionView: View {
    @EnvironmentObject var viewModel: LogoViewModel
    
    var body: some View {
        VStack{
            MultiSelectionView(options: $viewModel.sizes, optionToString: {$0.key}, selected: $viewModel.selectedSizes)
            
            Button {
                viewModel.resizeImages()
                viewModel.saveImages { url in
                    print("URL of folder:" + "\(String(describing: url))")
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
            .disabled(viewModel.selectedSizes.isEmpty)
        }
        .navigationTitle(Text("Sizes"))
        .background(Color("Background").ignoresSafeArea())
    }
}

struct SizeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SizeSelectionView()
    }
}
