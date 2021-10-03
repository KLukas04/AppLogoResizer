//
//  LogoViewModel.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 30.09.21.
//

import Foundation
import SwiftUI

class LogoViewModel: ObservableObject{
    
    @Published var rootIsActive = false
    
    @Published var image: UIImage?
    @Published var logoName = ""
    @Published var width = ""
    @Published var height = ""
    @Published var correctSize = true
    
    @Published var selectedSizes = Set<LogoSize>()
    
    @Published var sizes = [
        LogoSize(key: "16x16", size: 16),
        LogoSize(key: "20x20", size: 20),
        LogoSize(key: "29x29", size: 29),
        LogoSize(key: "32x32", size: 32),
        LogoSize(key: "40x40", size: 40),
        LogoSize(key: "58x58", size: 58),
        LogoSize(key: "60x60", size: 60),
        LogoSize(key: "64x64", size: 64),
        LogoSize(key: "76x76", size: 76),
        LogoSize(key: "80x80", size: 80),
        LogoSize(key: "87x87", size: 87),
        LogoSize(key: "120x120", size: 120),
        LogoSize(key: "128x128", size: 128),
        LogoSize(key: "152x152", size: 152),
        LogoSize(key: "167x167", size: 167),
        LogoSize(key: "180x180", size: 180),
        LogoSize(key: "256x256", size: 256),
        LogoSize(key: "512x512", size: 512),
        LogoSize(key: "1024x1024", size: 1024)
        
    ]
    
    @Published var resizedImages = [String: UIImage]()
    
    var urls = [URL]()
    
    @Published var showThankYouScreen = false
    
    var ulrOfSavedLocation: URL?
    
    @Published var saveTypeMessages = "Name:"
    
    func resizeImages(){
        resizedImages.removeAll()
        
        if let image = image{
            for selectedSize in selectedSizes {
                let resizedImage = image.scale(targetSize: CGSize(width: selectedSize.size/2, height: selectedSize.size/2)) //Durch (4/3) um in points
                resizedImages[selectedSize.key] = resizedImage
            }
            print(resizedImages.count)
        }else{
            print("image not found")
        }
    }
    
    private func createTempDirectory() -> URL? {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dir = documentDirectory.appendingPathComponent("Logos_" + "\(logoName)")
            do {
                try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
            return dir
        } else {
            return nil
        }
    }
    
    private func saveImages() -> URL? {
        guard let directory = createTempDirectory() else { return nil }
        
        print(directory)
        do {
            for image in resizedImages{
                if let imageData = image.value.pngData(){
                    print(image.key)
                    try imageData.write(to: directory.appendingPathComponent(logoName + "_" + image.key + ".png"))
                }else{
                    return nil
                }
            }
            return directory
        } catch {
            return nil
        }
    }
    
    func saveImages(completion: @escaping ((URL?) -> ())) {
        if !resizedImages.isEmpty{
            if logoName.isEmpty{
                logoName = "Logo"
            }
            DispatchQueue.main.async {
                guard let directory = self.saveImages() else {
                    completion(nil)
                    return
                }
                
                //MARK: SHARESHEET
                
                let av = UIActivityViewController(activityItems: [directory], applicationActivities: nil)
                av.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed {
                        print(activityType!)
                        if let aType = activityType{
                            switch aType{
                            case .airDrop:
                                self.saveTypeMessages = "Your resized logos were sent via AirDrop with the name:"
                            case .mail:
                                self.saveTypeMessages = "Your resized logos were sent by email in a folder with the name:"
                            case .copyToPasteboard:
                                self.saveTypeMessages = "Your resized logos have been copied to your clipboard with the name:"
                            case .init(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles"):
                                self.saveTypeMessages = "Your resized logos are saved in the Files-App under the name:"
                            default:
                                self.saveTypeMessages = "Your resized logos have been saved under the name:"
                            }
                        }
                        self.deleteFolder()
                        self.showThankYouScreen = true
                        let path = directory.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                        self.ulrOfSavedLocation = URL(string: path)!
                    }
                 }
                
                // <--->
                
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: {
                    print("Success")
                })
                self.urls.append(directory)
                completion(directory)
                self.rootIsActive = false
            }
        }
    }
    
    func deleteFolder(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        do{
            for url in urls{
                try FileManager.default.removeItem(at: url)
            }
        }catch{
            print("Couldnt delete folder")
        }
    }
}

struct LogoSize: Identifiable, Hashable{
    var id = UUID()
    var key: String
    var size: Double
}

extension UIImage {
    func scale(targetSize: CGSize) -> UIImage {
        let scaledImageSize = CGSize(
            width: targetSize.width,
            height: targetSize.height
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

