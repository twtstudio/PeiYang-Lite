//
//  SchRecvMessageView.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/5.
//

import SwiftUI
import URLImage

struct SchRecvMessageView: View {
    @State private var pageIndex = 0
    private var pageNames = ["点赞", "评论", "官方回复"]
    @State private var thumbedMessage: [SchMessageModel] = []
    @State private var commentMessage: [SchMessageModel] = []
    @State private var replyMessage: [SchMessageModel] = []
    
    @State private var questionNavigateTo = SchQuestionModel()
    @State private var navigateToQuestionView: Bool = false
    
    var body: some View {
        VStack {
            NavigationBar(center: {
                Text("校务消息")
                    .font(.title2)
                    .foregroundColor(Color(#colorLiteral(red: 0.1882352941, green: 0.2352941176, blue: 0.4, alpha: 1)))
            })
            
            VStack {
                HStack(spacing: 10) {
                    ForEach(pageNames.indices, id: \.self) { i in
                        VStack(spacing: 2) {
                            Text(pageNames[i])
                                .bold()
                                .foregroundColor(i == pageIndex ? Color(#colorLiteral(red: 0.1882352941, green: 0.2352941176, blue: 0.4, alpha: 1)) : Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                                .onTapGesture {
                                    withAnimation {
                                        pageIndex = i
                                    }
                                }
                            Text("")
                                .frame(height: i == pageIndex ? 4 : 0)
                        }
                        .overlay(
                            VStack {
                                Spacer()
                                Color(#colorLiteral(red: 0.1882352941, green: 0.2352941176, blue: 0.4, alpha: 1))
                                    .frame(height: 2)
                                    .cornerRadius(1)
                            }
                            .opacity(i == pageIndex ? 1 : 0)
                        )
                    }
                    Spacer()
                }
                .padding(.horizontal)
                TabView(selection: $pageIndex) {
                    MessageScrollView(messages: thumbedMessage)
                        .tag(0)
                    MessageScrollView(messages: commentMessage)
                        .tag(1)
                    MessageScrollView(messages: replyMessage)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding()
                
                NavigationLink(
                    destination: SchQuestionDetailView(question: questionNavigateTo),
                    isActive: $navigateToQuestionView,
                    label: { EmptyView() })
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .background(Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9725490196, alpha: 1)).edgesIgnoringSafeArea(.all))
        .onAppear(perform: loadData)
    }
    
    // 返回滚动列表
    private func MessageScrollView(messages: [SchMessageModel]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(messages.indices, id: \.self) { i in
                    Group {
                        if messages[i].type! == 0 {
                            ThumbedCellView(message: messages[i])
                        } else if messages[i].type! == 1 {
                            CommentCellView(message: messages[i])
                        } else {
                            ReplyCellView(message: messages[i])
                        }
                    }
                    .onTapGesture {
                        questionNavigateTo = messages[i].question ?? SchQuestionModel()
                        navigateToQuestionView = true
                        if (messages[i].visible ?? 0) == 1 {
                            SchMessageManager.setMessageRead(messageId: messages[i].id ?? 0) { (result) in
                                switch result {
                                case .success:
                                    log("设置已读成功")
                                case .failure(let err):
                                    log(err)
                                }
                            }
                        }
                    }
                    
                    if i != messages.count - 1 {
                        Color(#colorLiteral(red: 0.6745098039, green: 0.6823529412, blue: 0.7294117647, alpha: 1))
                            .frame(height: 1)
                            .padding(.top, 7)
                            .padding(.bottom, 3)
                    }
                }
            }
        }
    }
    
    private func loadData() {
        thumbedMessage = []
        commentMessage = []
        replyMessage = []
        SchMessageManager.getUnreadMessage { (result) in
            switch result {
            case .success(let messages):
                for m in messages {
                    switch m.type! {
                    case 0:
                        thumbedMessage.append(m)
                    case 1:
                        commentMessage.append(m)
                    default:
                        replyMessage.append(m)
                    }
                }
            case .failure(let err):
                log(err)
            }
        }
//        func generate(count: Int, type: Int) -> [SchMessageModel] {
//            return Array(repeating: SchMessageModel(id: 0, type: type, visible: 1, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil,
//                                                    contain: SchMessageContain(id: 0, contain: "不要你离开距离隔不开思念变成海在窗外进不来原谅说太快爱成了阻碍不要你离开距离隔不开思念变成海在窗外进不来原谅说太快爱成了阻碍", userID: 0, adminID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "这种重中之重", adminName: "哈啊哈哈哈哈", isLiked: true, score: 4, commit: "可以的"),
//                                                    question: SchQuestionModel(id: 0, name: "微北洋", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: "https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png", tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true)), count: count)
//        }
//
//        thumbedMessage = generate(count: 5, type: 0)
//        commentMessage = generate(count: 8, type: 1)
//        replyMessage = generate(count: 10, type: 2)
    }
}

fileprivate struct ThumbedCellView: View {
    var message: SchMessageModel
    private var commentTime: String {
        get {
            let day = message.createdAt?[0..<10] ?? ""
            let time = message.createdAt?[11..<16] ?? ""
            return day + "  " + time
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("Text")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(15)
                Text((message.contain?.username ?? "") + "  点赞了问题")
                    .font(.callout)
                    .foregroundColor(Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                Spacer()
                Text(commentTime)
                    .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                    .font(.footnote)
            }
            
            
                VStack {
                    HStack {
                        Text(message.question?.name ?? "")
                            .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if message.question?.thumbImg != nil {
                            URLImage(url: URL(string: message.question?.thumbImg ?? "")!) { (image) in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screen.width * 0.2, height: 50)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(height: 60)
                    
                    HStack {
                        Image("sch-comment")
                        Text((message.question?.msgCount ?? 0).description)
                            .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                            .font(.caption)
                        Image((message.question?.isLiked ?? false) ? "sch-like-fill" : "sch-like")
                            .padding(.leading, 10)
                        Text((message.question?.likes ?? 0).description)
                            .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                            .font(.caption)
                        Spacer()
                        Text((message.question?.solved ?? 0) == 0 ? "未回复" : "·已回复")
                            .font(.caption)
                            .foregroundColor((message.question?.solved ?? 0) == 0 ? Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)) : Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .addReddot(isPresented: message.visible ?? 0 == 1, size: 10)
        }
    }
}

fileprivate struct CommentCellView: View {
    var message: SchMessageModel
    private var commentTime: String {
        get {
            let day = message.createdAt?[0..<10] ?? ""
            let time = message.createdAt?[11..<16] ?? ""
            return day + "  " + time
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("Text")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(15)
                Text((message.contain?.username ?? "") + "  评论了问题")
                    .font(.callout)
                    .foregroundColor(Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                Spacer()
                Text(commentTime)
                    .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                    .font(.footnote)
            }
            
            VStack {
                HStack {
                    Text(message.question?.name ?? "")
                        .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if message.question?.thumbImg != nil {
                        URLImage(url: URL(string: message.question?.thumbImg ?? "")!) { (image) in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: screen.width * 0.2, height: 50)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 60)
                
                Color(#colorLiteral(red: 0.6745098039, green: 0.6823529412, blue: 0.7294117647, alpha: 1))
                    .frame(height: 0.7)
                    .opacity(0.5)
                
                Text("评价内容: " + (message.contain?.contain ?? ""))
                    .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image("sch-comment")
                    Text((message.question?.msgCount ?? 0).description)
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.caption)
                    Image((message.question?.isLiked ?? false) ? "sch-like-fill" : "sch-like")
                        .padding(.leading, 10)
                    Text((message.question?.likes ?? 0).description)
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.caption)
                    Spacer()
                    Text((message.question?.solved ?? 0) == 0 ? "未回复" : "·已回复")
                        .font(.caption)
                        .foregroundColor((message.question?.solved ?? 0) == 0 ? Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)) : Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .addReddot(isPresented: message.visible ?? 0 == 1, size: 10)
        }
    }
}

fileprivate struct ReplyCellView: View {
    var message: SchMessageModel
    private var commentTime: String {
        get {
            let day = message.createdAt?[0..<10] ?? ""
            let time = message.createdAt?[11..<16] ?? ""
            return day + "  " + time
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("官方")
                    .foregroundColor(.white)
                    .frame(width: 55, height: 30)
                    .background(Color(#colorLiteral(red: 0.3490196078, green: 0.3882352941, blue: 0.5215686275, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("回复了问题")
                    .font(.callout)
                    .foregroundColor(Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                Spacer()
                Text(commentTime)
                    .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                    .font(.footnote)
            }
            
            VStack {
                HStack {
                    Text(message.question?.name ?? "")
                        .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if message.question?.thumbImg != nil {
                        URLImage(url: URL(string: message.question?.thumbImg ?? "")!) { (image) in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: screen.width * 0.2, height: 50)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 60)
                
                Color(#colorLiteral(red: 0.6745098039, green: 0.6823529412, blue: 0.7294117647, alpha: 1))
                    .frame(height: 0.7)
                    .opacity(0.5)
                
                Text("回复内容: " + (message.contain?.commit ?? ""))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                    .lineLimit(2)
                
                HStack {
                    Image("sch-comment")
                    Text((message.question?.msgCount ?? 0).description)
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.caption)
                    Image((message.question?.isLiked ?? false) ? "sch-like-fill" : "sch-like")
                        .padding(.leading, 10)
                    Text((message.question?.likes ?? 0).description)
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.caption)
                    Spacer()
                    Text((message.question?.solved ?? 0) == 0 ? "未回复" : "·已回复")
                        .font(.caption)
                        .foregroundColor((message.question?.solved ?? 0) == 0 ? Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)) : Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .addReddot(isPresented: message.visible ?? 0 == 1, size: 10)
        }
    }
}

struct SchRecvMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SchRecvMessageView()
    }
}

struct SchRecvMessageViewCell_Previews: PreviewProvider {
    static let model = SchMessageModel(id: 0, type: 0, visible: 1, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil,
                                       contain: SchMessageContain(id: 0, contain: "不要你离开距离隔不开思念变成海在窗外进不来原谅说太快爱成了阻碍不要你离开距离隔不开思念变成海在窗外进不来原谅说太快爱成了阻碍", userID: 0, adminID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "这种重中之重", adminName: "哈啊哈哈哈哈", isLiked: true, score: 4, commit: "可以的"),
                                       question: SchQuestionModel(id: 0, name: "微北洋", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: "https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png", tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true, isFavorite: false, readen: true))
    static var previews: some View {
        VStack {
            ThumbedCellView(message: model)
            CommentCellView(message: model)
            ReplyCellView(message: model)
        }
        .frame(maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
    }
}
