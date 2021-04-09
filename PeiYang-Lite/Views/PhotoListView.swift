//
//  PhotoListView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2021/3/3.
//

import SwiftUI
import URLImage

struct PhotoListView: View {
    enum PhotoListViewType {
        case write, read
    }
    
    // 图片数据
    @Binding var images: [UIImage]
    @State var imageURLs: [String] = []
    
    
    // 删除图片
    @State private var imageToDelete: UIImage?
    @State private var showDeleteAlert: Bool = false
    // 添加图片
    @State private var showPicker: Bool = false
    @State private var imageToAdd: UIImage?
    // 选择图片选取模式
    @State private var showSelector: Bool = false
    @State private var useCamera: Bool = false
    @State private var imageToReplace: UIImage?
    // 添加模式or查看模式
    private var mode: PhotoListViewType = .write
    // 看大图
    @State private var showPhotoBrowser: Bool = false
    @State private var seletedIdx: Int = 0
    
    init (images: Binding<[UIImage]>, mode: PhotoListViewType = .write) {
        _images = images
        self.mode = mode
        UIScrollView.appearance().isScrollEnabled = true
    }
    // 只能是只读的
    init (imageURLs: [String]) {
        self._images = .constant([])
        self._imageURLs = State(wrappedValue: imageURLs)
        self.mode = .read
        UIScrollView.appearance().isScrollEnabled = true
    }
    
    var body: some View {
        HStack(alignment: VerticalAlignment.center) {
            if imageURLs.isEmpty {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(5)
                        .onTapGesture {
                            if mode == .write {
                                showSelector = true
                                imageToReplace = image
                            } else {
                                showPhotoBrowser = true
                            }
                        }
                        .onLongPressGesture {
                            if mode == .write {
                                imageToDelete = image
                                showDeleteAlert = true
                            }
                        }
                }
            } else {
                ForEach(imageURLs.indices, id: \.self) { i in
                    URLImage(url: URL(string: imageURLs[i])!, content: { (image) in
                        image
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
//                            .frame(maxWidth: screen.width / (CGFloat(imageURLs.count) + 0.5))
                            .cornerRadius(5)
                    })
                    .onTapGesture {
                        seletedIdx = i
                        showPhotoBrowser = true
                    }
                }
                if imageURLs.count < 3 {
                    Spacer()
                }
            }
            // 图片占位符
            if mode == .write && images.count < 3 {
                PhotoPlaceHolderView()
                    .onTapGesture {
                        showSelector = true
                    }
                    .actionSheet(isPresented: $showSelector, content: {
                        ActionSheet(title: Text("选择来源"), message: nil, buttons: [
                            .default(Text("拍照"), action: {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    useCamera = true
                                    showPicker = true
                                }
                            }),
                            .default(Text("相册"), action: {
                                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                                    useCamera = false
                                    showPicker = true
                                }
                            }),
                            .cancel()
                        ])
                    })
                    .sheet(isPresented: $showPicker, onDismiss: {
                        if let image = imageToAdd {
                            if let replace = imageToReplace {
                                let idx = images.firstIndex(of: replace)
                                images[idx!] = image
                            } else {
                                images.append(image)
                            }
                            imageToAdd = nil
                        }
                    }, content: {
                        ImagePicker(image: $imageToAdd, useCamera: useCamera)
                            .edgesIgnoringSafeArea(.all)
                    })
                Spacer()
            }
            // fullScreenCover得和sheet同级
            EmptyView()
                .fullScreenCover(isPresented: $showPhotoBrowser, content: {
                    SKPhotoView(imageURLs: imageURLs, selectedIdx: seletedIdx)
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                        .edgesIgnoringSafeArea(.bottom)
                })
        }
        // emm竟然只能添加一个alert对一个view
        .alert(isPresented: $showDeleteAlert, content: {
            Alert(title: Text("确定要删除这张图片吗?"),
                  primaryButton: .destructive(Text("删除"), action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        images.remove(atOffsets: IndexSet(integer: images.firstIndex(of: imageToDelete!)!))
                    }
                  }),
                  secondaryButton: .cancel())
        })
        
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PhotoListView(images: .constant([]))
            PhotoListView(imageURLs: ["http://47.94.198.197:10805/storage/thumb_images/2021_03/userId_7_17_05_10_33_413940.jpeg","http://47.94.198.197:10805/storage/thumb_images/2021_03/userId_7_17_05_10_33_443122.jpeg"])
        }
    }
}

struct PhotoPlaceHolderView: View {
    var body: some View {
        VStack {
            Image("add-photo")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .padding()
            Text("添加图片")
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.gray, style: StrokeStyle(dash: [5]))
        )
        .background(Color.background)
    }
}
