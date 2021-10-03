//
//  SizeSelectionView.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI

struct SizeSelectionView: View {
    @EnvironmentObject var viewModel: LogoViewModel
    @State private var processing = false
    
    var body: some View {
        ZStack{
            VStack{
                MultiSelectionView(options: $viewModel.sizes, optionToString: {$0.key}, selected: $viewModel.selectedSizes)
                    .disabled(processing)
                Button {
                    processing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
                        viewModel.resizeImages()
                        viewModel.saveImages { url in
                            print("URL of folder:" + "\(String(describing: url))")
                        }
                    }
                } label: {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(viewModel.selectedSizes.isEmpty ? Color("Secondary") : Color("Primary"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                }
                .padding(.bottom)
                .disabled(viewModel.selectedSizes.isEmpty || processing)
            }
            .blur(radius: processing ? 10 : 0)
            
            if processing{
                ProgressView()
            }
        }
        .navigationBarHidden(processing)
        .navigationTitle(Text("Sizes"))
        .background(Color("Background").ignoresSafeArea())
    }
}

struct SizeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SizeSelectionView()
    }
}
