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
    @State var mode: PhotoListViewType = .read
    
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
    
    init (images: Binding<[UIImage]>, mode: PhotoListViewType = .read) {
        _images = images
        self.mode = mode
    }
    // 只能是只读的
    init (imageURLs: [String]) {
        self._images = .constant([])
        self.imageURLs = imageURLs
        self.mode = .read
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
                                // 看大图
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
                            .cornerRadius(5)
                    })
                    .onTapGesture {
                        // 看大图
                    }
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
                                useCamera = true
                                showPicker = true
                            }),
                            .default(Text("相册"), action: {
                                useCamera = false
                                showPicker = true
                            }),
                            .cancel()
                        ])
                    })
                    .sheet(isPresented: $showPicker, content: {
                        ImagePicker(image: $imageToAdd, useCamera: useCamera)
                            .onDisappear(perform: {
                                if let image = imageToAdd {
                                    if let replace = imageToReplace {
                                        let idx = images.firstIndex(of: replace)
                                        images[idx!] = image
                                    } else {
                                        images.append(image)
                                    }
                                    imageToAdd = nil
                                }
                            })
                            .edgesIgnoringSafeArea(.all)
                    })
                Spacer()
            }
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
        PhotoListView(images: .constant([]))
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
