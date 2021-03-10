//
//  PhotoListView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2021/3/3.
//

import SwiftUI

struct PhotoListView: View {
    // 图片数据
    @Binding var images: [UIImage]
    
    // 删除图片
    @State private var imageToDelete: UIImage?
    @State private var showDeleteAlert: Bool = false
    // 添加图片
    @State private var showPicker: Bool = false
    @State private var imageToAdd: UIImage?
    // 图片过多
    @State private var showTooMoreAlert: Bool = false
    // 选择图片选取模式
    @State private var showSelector: Bool = false
    @State private var useCamera: Bool = false
    @State private var imageToReplace: UIImage?
    
    var body: some View {
        HStack(alignment: VerticalAlignment.center) {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(5)
                    .onTapGesture {
                        showSelector = true
                        imageToReplace = image
                    }
                    .onLongPressGesture {
                        imageToDelete = image
                        showDeleteAlert = true
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
            // 图片占位符
            if images.count < 3 {
                PhotoPlaceHolderView()
                    .onTapGesture {
                        //                            guard images.count < 3 else {
                        //                                showTooMoreAlert = true
                        //                                return
                        //                            }
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
