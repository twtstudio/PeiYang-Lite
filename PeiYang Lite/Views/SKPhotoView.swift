//
//  SKPhotoView.swift
//  Test
//
//  Created by Zr埋 on 2021/3/18.
//

import SwiftUI
import SKPhotoBrowser

struct SKPhotoView: UIViewControllerRepresentable {
    var imageURLs: [String] = []
    var selectedIdx: Int = 0
    
    func makeUIViewController(context: Context) -> SKPhotoBrowser {
        var images = [SKPhoto]()
        for url in imageURLs {
            images.append(SKPhoto.photoWithImageURL(url))
        }
        
        let browser = SKPhotoBrowser(photos: images)
        SKPhotoBrowserOptions.displayAction = false
        browser.initializePageIndex(selectedIdx)
        return browser
    }
    
    func updateUIViewController(_ uiViewController: SKPhotoBrowser, context: Context) {
        
    }
}
