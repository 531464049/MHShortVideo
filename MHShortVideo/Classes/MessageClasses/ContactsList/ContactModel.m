//
//  ContactModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

+(NSArray *)contactList
{
    
    NSArray *xings = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"楚",@"卫",@"蒋",@"沈",@"韩",@"杨"];
    NSArray *ming1 = @[@"大",@"美",@"帅",@"应",@"超",@"海",@"江",@"湖",@"春",@"夏",@"秋",@"冬",@"上",@"左",@"有",@"纯"];
    NSArray *ming2 = @[@"强",@"好",@"领",@"亮",@"超",@"华",@"奎",@"海",@"工",@"青",@"红",@"潮",@"兵",@"垂",@"刚",@"山"];
    
    NSMutableArray * userArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 30; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10) > 3) {
            NSString *ming = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:ming];
        }
        ContactModel *model = [ContactModel new];
        model.userName = name;
        model.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        [userArr addObject:model];
    }
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (ContactModel * model in userArr) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(userName)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(userName)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray * sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    [newSectionArray removeObjectsInArray:temp];
    
    NSMutableArray * listArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < sectionTitlesArray.count; i ++) {
        NSString * title = (NSString *)sectionTitlesArray[i];
        NSArray * users = (NSArray *)newSectionArray[i];
        
        NSDictionary * dic = @{
                               @"sectionTitle":title,
                               @"userArr":users
                               };
        [listArr addObject:dic];
    }
    
    NSDictionary * allFocusDic = @{
                                 @"sectionTitle":@"",
                                 @"userArr":@[]
                                 };
    [listArr insertObject:allFocusDic atIndex:0];
    
    NSMutableArray * friendArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 5; i ++) {
        ContactModel * model = [[ContactModel alloc] init];
        model.userName = [NSString stringWithFormat:@"好友%d",i+1];
        model.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        [friendArr addObject:model];
    }
    NSDictionary * friendDic = @{
                                 @"sectionTitle":@"",
                                 @"userArr":friendArr
                                 };
    [listArr insertObject:friendDic atIndex:0];

    return [NSArray arrayWithArray:listArr];
}

@end
