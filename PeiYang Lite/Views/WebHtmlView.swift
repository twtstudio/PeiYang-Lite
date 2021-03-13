//
//  WebHtmlView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/12.
//

import SwiftUI
import WebKit

struct WebHtmlView: UIViewRepresentable {
    @Binding var html: String
    @State var baseURL: URL? = nil
    @State var isScrollEnabled: Bool = true
    
    func makeUIView(context: Context) -> WKWebView {
        let jsStr = "var p=document.getElementsByTagName('p');for(var i=0;i<p.length;i++){p[i].style.color='#363C54';p[i].style.fontSize='12pt'};"
        // 根据JS字符串初始化WKUserScript对象
        let userScript = WKUserScript(source: jsStr, injectionTime:.atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        let userWebview = WKWebView(frame: .zero, configuration: webConfiguration)
        userWebview.scrollView.isScrollEnabled = isScrollEnabled
        return userWebview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
//        let adaptiveHtml = html.appendingFormat("<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>",screen.width * 2 / 3 - 20)
        let adaptiveHtml = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>" + html
        uiView.loadHTMLString(adaptiveHtml, baseURL: baseURL)
    }
}


struct WebHtmlView_Previews: PreviewProvider {
    static var previews: some View {
        WebHtmlView(html: .constant("<html><body><h1>Hello World</h1></body></html>"))
    }
}
