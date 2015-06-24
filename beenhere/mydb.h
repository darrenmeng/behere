//
//  mydb.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/16.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface mydb : NSObject
{
    FMDatabase *db;
    BOOL havedEmail;
    NSString * message;
    NSDictionary * RequestResult;
    NSMutableArray * frindRequestList;
}

+ (mydb *)sharedInstance;

//瀏覽
- (id)queryCust;

//查詢有 custname 的資料
- (id)queryCustName:(NSString *)custname;

-(id)queryemail:(NSString *)beemail;

- (BOOL)andnewEmail:(NSString *)email;

//取得流水號
- (NSString *)newCustNo;

//新增(以欄位)
- (void)insertMemeberNo:(NSString *)memberId andMBName:(NSString *)Bename andEMAIL:(NSString *)BeEMAIL andPassword:(NSString *)BePassword ;
//修改
- (void)updateBeName:(NSString *)bename andBeTel:(NSString *)betel andBeemail:(NSString *)Beemail andBebirthday:(NSDate *)Bebthday andBeid:(NSString *)Beid andBelocation:(NSString *)Belocation andBepassword:(NSString *)bpw andBesex:(NSString *)bsex andbhereno:(NSString *)bhereno;
//- (void)updateBeName:(NSString *)bename andBeTel:(NSInteger *)betel andBeemail:(NSString *)Beemail andBebirthday:(NSDate *)Bebthday andBeid:(NSString *)Beid andBelocation:(NSString *)Belocation andBepassword:(NSString *)bpw andBesex:(NSString *)bsex andbhereno:(NSString *)bhereno;
//刪除
- (void)deleteCustNo:(NSString *)custno;

//新增(以Dictionary)
- (void)insertCustDict:(NSDictionary *)custDict;

- (void)insertfriendname:(NSString *)memberId friendname:(NSString *)friendname andffriendID :(NSString *)friendID;
-(NSDictionary*)SearchRequest:(NSString *)SearchfriendID;
//新增內容
- (void)insertMemeberNo:(NSString *)memberId andcontenttext:(NSString *)Contenttext andlevel:(NSString *)level anddate:(NSDate *)date andcontentno:(NSString *)content_no;
//新增回覆內容
- (void)insertreplyMemeberNo:(NSString *)memberId andcontenttext:(NSString *)Contenttext andlevel:(NSString *)level anddate:(NSDate *)date andcontentno:(NSString *)content_no;
-(id)queryindexcontent:(NSString *)beeid;
-(id)queryreplycontent:(NSString *)content_id;
//新增發佈內容
-(void)insertcontentremote:(NSDictionary *)params;
//新增子回覆內容
-(void)insertcontentreplyremote:(NSDictionary *)params;
//serach content_no
-(void)SearchIDcontent:(NSString *)beid;
//mysql 查詢主頁內容
-(void)querymysqlindexcontent:(NSString *)beeid;
@end
