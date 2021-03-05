//
//  AboutTwTView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/4.
//

import SwiftUI

struct AboutTwTView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15.0){
                Text("微北洋4.0  天外天介绍").font(.title2).fontWeight(.heavy)
                Text("天外天下设天外天新闻中心和天外天工作室，是天津大学唯一的全媒体平台，连续八年荣获天津大学十佳社团第一名。\n\n天外天新闻网，连续七年荣获教育部“全国高校百佳网站”的称号、连续四年荣获“全国高校十佳新闻网站”的称号。2019年，天外天荣获教育部中国大学生在线“优秀校园网络通讯站”称号。\n\n\(Text("天外天新闻中心").font(.headline))“天外天”微信公众号，关注人数超过65000人，累计发布文章千余篇，年均推送阅读量过百万。拥有若干原创作品，同时于校内各大平台组织、机关部处、学生社团、校外网络平台等合作开展活动和宣传。")
                Image("first")
                    .resizable()
                    .scaledToFit()
                Text(" 天外天始终追求高质量原创文章，目前天外天公众号拥有“斜杠青年”“践·行”“戒·耀”“我们”“干货”等众多出色专题，同时还推出情怀散文、通知公告、校园新闻......\n\n由天外天全面开发维护的天外天新闻网，日点击量两万余次。作为校园官方媒体，网站内容覆盖校内外各个热点话题，2019至2020年度发稿千余篇总阅读量百万余人次。")
                Image("second")
                    .resizable()
                    .scaledToFit()
                Text("\(Text("TWT Studio").font(.headline))起源于2000年卫津路校区的一间小办公室，今年是工作室陪伴天大学子走过的第21年。二十一年来，热爱互联网的天大学子不断投身其中，为工作室注入新鲜血液，怀揣着对互联网的热爱，用自己的努力建设着母校。现在天外天工作室是唯一负责学校各项互联网建设事业的学生互联网团队。")
                Image("third")
                    .resizable()
                    .scaledToFit()
                Text("初遇北洋，\(Text("新生入学教育网站").font(.headline))与你相伴；学在北洋，\(Text("微北洋app").font(.headline))总结信息，服务师生；思在北洋，\(Text("校务专区").font(.headline))聚焦时事，建设校风；悟在北洋，\(Text("青年大学习积分系统").font(.headline))助你提升思想觉悟；身在北洋，\(Text("天外天专属表情包").font(.headline))送来欢乐；念在北洋，\(Text("海棠节H5").font(.headline))引来万千遐想......")
                Image("forth")
                    .resizable().scaledToFit()
            }
            .frame(width: screen.width * 0.9)
        }
        .padding(.top, 30)
    }
}

struct AboutTwTView_Previews: PreviewProvider {
    static var previews: some View {
        AboutTwTView()
    }
}
