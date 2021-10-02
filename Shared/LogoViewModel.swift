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
        LogoSize(key: "16x16", size: 12),
        LogoSize(key: "20x20", size: 15),
        LogoSize(key: "29x29", size: 22),
        LogoSize(key: "32x32", size: 24),
        LogoSize(key: "40x40", size: 30),
        LogoSize(key: "58x58", size: 44),
        LogoSize(key: "60x60", size: 45),
        LogoSize(key: "64x64", size: 48),
        LogoSize(key: "80x80", size: 60),
        LogoSize(key: "87x87", size: 65),
        LogoSize(key: "120x120", size: 90),
        LogoSize(key: "128x128", size: 96),
        LogoSize(key: "152x152", size: 114),
        LogoSize(key: "167x167", size: 125),
        LogoSize(key: "180x180", size: 135),
        LogoSize(key: "256x256", size: 192),
        LogoSize(key: "512x512", size: 384),
        LogoSize(key: "1024x1024", size: 768)
        
    ]
    
    @Published var resizedImages = [String: UIImage]()
    
    var urls = [URL]()
    
    @Published var showThankYouScreen = false
    
    var ulrOfSavedLocation: URL?
    
    func resizeImages(){
        resizedImages.removeAll()
        
        if let image = image{
            for selectedSize in selectedSizes {
                let resizedImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: selectedSize.size, height: selectedSize.size))
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
                    if logoName.isEmpty{
                        logoName = "Logo"
                    }
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
            DispatchQueue.main.async {
                guard let directory = self.saveImages() else {
                    completion(nil)
                    return
                }
                
                let av = UIActivityViewController(activityItems: [directory], applicationActivities: nil)
                av.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed {
                        self.deleteFolder()
                        self.showThankYouScreen = true
                        let path = directory.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                        self.ulrOfSavedLocation = URL(string: path)!
                    }
                 }
                
                
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
    var size: Int
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
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
