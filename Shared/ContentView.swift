//
//  ContentView.swift
//  Shared
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var viewModel: LogoViewModel
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var showingAlert = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                if viewModel.image == nil{
                    VStack{
                        Spacer()
                        Image(systemName: "plus.viewfinder")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                showImagePicker = true
                            }
                        Text("Select a 1024x1024 image")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                        Spacer()
                    }
                }else{
                    VStack{
                        Image(uiImage: viewModel.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 300, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .onTapGesture {
                                showImagePicker = true
                            }
                        Text(viewModel.height + " x " + viewModel.width)
                            .font(.caption2)
                            .foregroundColor(viewModel.correctSize ? .secondary : .red)
                        TextField("Name", text: $viewModel.logoName)
                            .padding()
                            .background(Color.white.cornerRadius(10))
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                            .padding()
                    }
                    .padding(.top)
                    
                }
                
                Spacer()
                
                NavigationLink(destination: SizeSelectionView(), isActive: $viewModel.rootIsActive) {
                    Text("Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(viewModel.image == nil ? .secondary : Color("Primary"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                }
                .disabled(viewModel.image == nil)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color("Background").ignoresSafeArea())
            .navigationTitle(Text("Select your logo"))
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage){
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: .constant(true)){
                ThankYouScreen()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Wrong image size"), message: Text("You can use this image but the quality could be bad!"))
            }
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        
        viewModel.width = String(Int(inputImage.getWidthInPixel))
        viewModel.height = String(Int(inputImage.getHeightInPixel))
        
        viewModel.correctSize = Int(inputImage.getWidthInPixel) == 1024 && Int(inputImage.getHeightInPixel) == 1024
        
        showingAlert = !viewModel.correctSize
        print(inputImage.getWidthInPixel, inputImage.getHeightInPixel)
        viewModel.image = inputImage
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
