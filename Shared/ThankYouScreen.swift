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
            SavedView()
            Text("You resized your Logo to **\(viewModel.selectedSizes.count)** **images**")
                .font(.caption2)
                .italic()
            Text("Your resized images are saved in the **Files-App** under the Name:")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
            Text("Logos_" + viewModel.logoName)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Button {
                UIApplication.shared.open(viewModel.ulrOfSavedLocation!)
            } label: {
                Text("Open")
                    .padding(6)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color("Primary"))
                    .clipShape(Capsule())
                    .padding()
            }

            ZStack{
                VStack(alignment: .leading){
                    Text("Tips").bold()
                        .padding()
                        .foregroundColor(.black)
                    if purchasesService.allPackages.isEmpty{
                        VStack{
                            AvtivityIndicator()
                        }
                        .frame(height: 50)
                        .padding()
                    }else{
                        ForEach(purchasesService.allPackages, id: \.self){ package in
                            
                            Button {
                                purchasesService.purchasesProduct(package: package) { success in
                                    if success{
                                        counter += 1
                                    }
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
                }
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
                .onAppear(perform: purchasesService.getProducts)
                ConfettiCannon(counter: $counter, num: 30, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 180), radius: 200, repetitions: 3, repetitionInterval: 0.3)
            }
            
            Spacer()
        }
        .foregroundColor(.white)
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