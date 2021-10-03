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
    
    @State private var logoWidth: CGFloat = 300
    @State private var logoHeight: CGFloat = 300
    @State private var changeValue = true
    var body: some View {
        NavigationView{
            VStack{
                if viewModel.image == nil{
                    VStack{
                        Spacer()
                        LottieView(fileName: "add", loopMode: .loop, startFrame: 5.0, endFrame: 70.0)
                            .onTapGesture {
                                showImagePicker = true
                            }
                        Text("Select a 1024x1024 image")
                            .font(.caption2)
                            .foregroundColor(Color("Secondary"))
                            .padding(.top, 8)
                        Spacer()
                    }
                }else{
                    VStack{
                        Image(uiImage: viewModel.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: logoWidth, height: logoHeight, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .onTapGesture {
                                showImagePicker = true
                            }
                        Text(viewModel.height + " x " + viewModel.width)
                            .font(.caption2)
                            .foregroundColor(viewModel.correctSize ? .secondary : .red)
                        TextField("", text: $viewModel.logoName, onEditingChanged: { _ in
                            withAnimation(.easeIn){
                                if changeValue{
                                    logoWidth = 150
                                    logoHeight = 150
                                }else{
                                    changeValue = true
                                }
                            }
                        }, onCommit: {
                            withAnimation(.easeOut){
                                changeValue = false
                                logoWidth = 300
                                logoHeight = 300
                            }
                        })
                            .foregroundColor(.black)
                            .placeholder(when: viewModel.logoName.isEmpty) {
                                    Text("Logo-Name").foregroundColor(.gray)
                            }
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
                        .background(viewModel.image == nil ? Color("Secondary") : Color("Primary"))
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
            .sheet(isPresented: $viewModel.showThankYouScreen){
                ThankYouScreen()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Wrong image size"), message: Text("You can use this image but the quality could be bad!"))
            }
            .onDisappear{
                logoWidth = 300
                logoHeight = 300
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

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
