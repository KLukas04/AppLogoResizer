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
            
            NavigationLink(destination: FinishScreen()) {
                Text("Next")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color("Primary"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .navigationTitle(Text("Sizes"))
    }
}

struct SizeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SizeSelectionView()
    }
}
