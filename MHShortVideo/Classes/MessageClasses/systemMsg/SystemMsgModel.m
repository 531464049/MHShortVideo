//
//  SystemMsgModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SystemMsgModel.h"

@implementation SystemMsgModel

+(NSArray *)test_someModels:(HomeMessageType)msgType
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 20; i ++) {
        SystemMsgModel * model = [[SystemMsgModel alloc] init];
        model.messageType = msgType;
        
        if (msgType == HomeMessageTypeNews) {
            model.newsTypeIcon = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
            model.newsImage = [MHVideoTool t_videoPreImage:i%10];
        }
        model.msgTitle = [self ttttt_title:i%10];
        model.msgDes = [self ttttt_des:i%10];
        model.msgTime = @"星期八 26:90";
        
        [model message_Layout];
        [arr addObject:model];
    }
    
    return [NSArray arrayWithArray:arr];
}
-(void)message_Layout
{
    SystemMsgLayout * layout = [[SystemMsgLayout alloc] init];
    CGFloat textWidth = Screen_WIDTH - layout.iconLeft - layout.iconWidth - layout.titleLeft - layout.titleRight;
    CGFloat textHeight = [self.msgDes textHeight:layout.desFont width:textWidth lineSpace:7 keming:0];
    self.msgDesHeight = textHeight;
    
    CGFloat totleHeight = layout.titleTop + layout.titleHeight + layout.desTop + textHeight + layout.time_des_Top + layout.timeHeight + layout.timeBottom;
    self.cellHeight = totleHeight;
}
+(NSString *)ttttt_title:(NSInteger)index
{
    NSArray * arr = @[
                      @"阿拉伯国有电视台",
                      @"卡塔尔方面表示",
                      @"海外网12月3日电",
                      @"《报告》作者不少来自金融监管部门",
                      @"资产管理机构缺少有效风险管理工具",
                      @"洪磊上述分报告",
                      @"与境外成熟市场相比",
                      @"各类机构",
                      @"具体来说，产品层面",
                      @"我国仅有三只股指期货"];
    return arr[index];
}
+(NSString *)ttttt_des:(NSInteger)index
{
    NSArray * arr = @[
                      @"随着微信的流行，人们交流的主要通讯工具就是属它莫属了，男女的交往更是如此，微信更是代表着一个人的形象，所以，很多人都会用心装饰自己的微信，包括头像，简介，照片等。",
                      @"都说你的行为代表着你个人的内心活动，这话一点都不假。尤其是女人，只要心情发生变化",
                      @"但很多男人却觉得女人的心思很难猜，所以，有很多男士至今单身，原因在于，女人真的很难追，而且也不知道什么样的女人是适合结婚的，这常常让男人感到非常地头痛。",
                      @"对于刚认识的女人，男人总是不知道如何下手，更不知道这个女人是否适合走到最后，总害怕自己的真心付出，结果却是一场空。",
                      @"其实，对于刚认识的女人，初步判断可以通过她使用的微信头像就可以看出来的。",
                      @"这样的女人通常都有一颗真诚的心，希望自己真诚待人，也得到别人的真诚相待，这样的女孩子通常都是比较自信的，而且是活泼开朗的。",
                      @"这样的女孩子没什么心机，她想彼此都能够坦诚相待，不想和有心机的人交往，只要你付出真心，她也愿意用真心回报你。",
                      @"一般用自己的生活照作为头像的女人，都是自信且自恋的女人，多少都对自己的颜值比较自信的。所以，你要追求她除了有真心，还得要足够的优秀。",
                      @"证明这样的女人是很在乎自己的形象的，又或者与她的工作有关，不得不在意自己的形象问题，这样的女人在职场上一定是个有能力的女人。",
                      @"从在乎头像这件事情既可以看出，她是一个做事情非常慎重的人，也是一个很认真的人。"];
    return arr[index];
}
@end


@implementation SystemMsgLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.iconLeft = Width(15);
        self.iconTop = Width(10);
        self.iconWidth = Width(50);
        
        self.titleLeft = Width(10);
        self.titleTop = Width(10);
        self.titleRight = Width(95);
        self.titleHeight = Width(27);
        self.titleFont = FONT(16);
        
        self.desTop = 2;
        self.desFont = FONT(14);
        
        self.rightItemRight = Width(15);
        self.rightItemWidth = Width(70);
        
        self.time_des_Top = 3;
        self.timeHeight = Width(20);
        self.timeFont = FONT(13);
        self.timeBottom = Width(15);
    }
    return self;
}

@end
