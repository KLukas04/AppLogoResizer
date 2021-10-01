//
//  ThankYouScreen.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 01.10.21.
//

import SwiftUI
import ConfettiSwiftUI

struct ThankYouScreen: View {
    @EnvironmentObject var viewModel: LogoViewModel
    @StateObject var purchasesService = PurchasesService()
    
    @State private var counter = 0
    var body: some View {
        VStack{
            Text("Your resized images are saved in the **Files-App** under the Name:")
                .multilineTextAlignment(.center)
                .padding()
            Text("Logos_" + viewModel.logoName)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Image(systemName: "folder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
                .padding()
            Text("You resized your Logo to \(viewModel.selectedSizes.count) images")
                .font(.caption2)
                .italic()
            
            ZStack{
            VStack(alignment: .leading){
                Text("Tips").bold()
                    .padding()
                ForEach(purchasesService.allPackages, id: \.self){ package in
                    
                    Button {
                        purchasesService.purchasesProduct(package: package) { success in
                            //if success{
                                counter += 1
                            //}
                        }
                    } label: {
                        HStack{
                            Text(purchasesService.emoji[package.product.localizedTitle] ?? "🥳")
                            Text(package.product.localizedTitle)
                            Spacer()
                            Text(package.localizedPriceString)
                        }
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                        .padding(.bottom)
                    }

                    
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
            .onAppear(perform: purchasesService.getProducts)
                
                ConfettiCannon(counter: $counter, num: 20, repetitions: 3, repetitionInterval: 0.1)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("Background").ignoresSafeArea())
        .navigationTitle(Text("Success"))
    }
}

struct ThankYouScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ThankYouScreen().environmentObject(LogoViewModel())
        }
    }
}
