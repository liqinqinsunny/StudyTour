//
//  CardIdVerification.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/9.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "CardIdVerification.h"

@interface CardIdVerification ()

// 去掉最后一位的身份证号
@property (nonatomic, copy) NSString *subCardID;
@property (nonatomic, copy) NSSet *areaSet;
@property (nonatomic, copy) NSString *cardId;
@end

@implementation CardIdVerification
/**
 * 身份证号码的格式：610821-20061222-612-X
 * 由18位数字组成：前6位为地址码，第7至14位为出生日期码，第15至17位为顺序码，
 * 第18位为校验码。检验码分别是0-10共11个数字，当检验码为“10”时，为了保证公民身份证号码18位，所以用“X”表示。虽然校验码为“X”不能更换，但若需全用数字表示，只需将18位公民身份号码转换成15位居民身份证号码，去掉第7至8位和最后1位3个数码。
 * 当今的身份证号码有15位和18位之分。1985年我国实行居民身份证制度，当时签发的身份证号码是15位的，1999年签发的身份证由于年份的扩展（由两位变为四位）和末尾加了效验码，就成了18位。
 * （1）前1、2位数字表示：所在省份的代码；
 * （2）第3、4位数字表示：所在城市的代码；
 * （3）第5、6位数字表示：所在区县的代码；
 * （4）第7~14位数字表示：出生年、月、日；
 * （5）第15、16位数字表示：所在地的派出所的代码；
 * （6）第17位数字表示性别：奇数表示男性，偶数表示女性
 * （7）第18位数字是校检码：根据一定算法生成
 * @author wjp
 *
 */
+ (BOOL)cardIdVerification:(NSString *)cardId
{
    
    BOOL bRet = NO;
    CardIdVerification *civ = [[CardIdVerification alloc] init];
    civ.cardId = cardId;
    do {
        if (![civ lengthTypeVerification:cardId]) {
            break;
        }
        if (![civ birthDayVerification:civ.subCardID]) {
            break;
        }
        if (![civ areaCodeVerification:cardId]) {
            break;
        }
        if (cardId.length == 18 && ![civ lastVarifyCodeVerification:civ.subCardID]) {
            break;
        }
        bRet = YES;
    } while (0);
    
    return bRet;
    return YES;
}

- (BOOL)lengthTypeVerification:(NSString *)cardId
{
    BOOL bRet = NO;
    do {
        if (cardId.length != 15 && cardId.length != 18) {
            break;
        }
        
        NSString *subStr;
        if (cardId.length == 18) {
            subStr = [cardId substringToIndex:17];
        } else {
            NSString *str1 = [cardId substringToIndex:6];
            NSString *str2 = @"19";
            NSString *str3 = [cardId substringFromIndex:6];
            subStr = [NSString stringWithFormat:@"%@%@%@", str1, str2, str3];
        }
        
        _subCardID = subStr;
        
        NSScanner* scan = [NSScanner scannerWithString:subStr];
        int val;
        bRet = [scan scanInt:&val] && [scan isAtEnd];
    } while (0);
    
    return bRet;
}

- (BOOL)birthDayVerification:(NSString *)cardId
{
    BOOL bRet = NO;
    
    NSString *str1 = [cardId substringWithRange:NSMakeRange(6, 4)];
    NSString *str2 = [cardId substringWithRange:NSMakeRange(10, 2)];
    NSString *str3 = [cardId substringWithRange:NSMakeRange(12, 2)];
    NSString *birthStr = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
    
    NSString *regex = @"^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))?$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    bRet = [identityCardPredicate evaluateWithObject:birthStr];
    
    return bRet;
}

- (BOOL)areaCodeVerification:(NSString *)cardId
{
    BOOL bRet = NO;
    
    NSString *areaStr = [cardId substringToIndex:2];
    if ([self.areaSet containsObject:areaStr]) {
        bRet = YES;
    }
    
    return bRet;
}

- (BOOL)lastVarifyCodeVerification:(NSString *)cardId
{
    BOOL bRet = NO;
    do {
        int weight[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
        NSArray *VarifyCode = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        int sum = 0;
        for (int i = 0; i < 17; ++i) {
            NSString *c = [NSString stringWithFormat:@"%c", [cardId characterAtIndex:i]];
            sum += c.integerValue * weight[i];
        }
        int modValue = sum % 11;
        NSString *lastChar = VarifyCode[modValue];
        NSString *tempStr = [cardId stringByAppendingString:lastChar];
        if ([tempStr isEqualToString:_cardId]) {
            bRet = YES;
        }
    } while (0);
    
    return bRet;
}

- (NSSet *)areaSet
{
    if (_areaSet == nil) {
        NSSet *areaSet = [NSSet setWithObjects:@"11", @"12", @"13", @"14", @"15",
                          @"21", @"22", @"23",
                          @"31", @"32", @"33", @"34", @"35", @"36", @"37",
                          @"41", @"42", @"43", @"44", @"45", @"46",
                          @"50", @"51", @"52", @"53", @"54",
                          @"61", @"62", @"63", @"64", @"65",
                          @"71",
                          @"81", @"82",
                          @"91", nil];
        _areaSet = areaSet;
    }
    return _areaSet;
}

#pragma mark -- 手机号 验证
+ (BOOL)phoneNumVerification:(NSString *)phoneNum
{
    BOOL bRet = NO;
    do {
        // 手机号格式检查
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700
         */
        NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:phoneNum] == NO)
            && ([regextestcm evaluateWithObject:phoneNum] == NO)
            && ([regextestct evaluateWithObject:phoneNum] == NO)
            && ([regextestcu evaluateWithObject:phoneNum] == NO))
        {
            break;
        }
        bRet = YES;
    } while (0);
    return bRet;
}

+ (BOOL)mailAddVerification:(NSString *)mailAdd
{
    BOOL bRet = NO;
    do {
        // 邮箱地址格式检查
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:mailAdd]) {
            break;
        }
        
        bRet = YES;
    } while (0);
    return bRet;
}
/*
 护照号码的格式：
 因私普通护照号码格式有:14/15+7位数,G+8位数；因公普通的是:P.+7位数；
 公务的是：S.+7位数 或者 S+8位数,以D开头的是外交护照.D=diplomatic
 
 */
+ (BOOL)passportVerification:(NSString *)passport
{
    BOOL bRet = NO;
    do{
        // 护照格式
        NSString *passportRegex = @"^1[45][0-9]{7}|G[0-9]{8}|P[0-9]{7}|S[0-9]{7,8}|D[0-9]+$|E[0-9]{8}";
        NSPredicate *passporttest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passportRegex];
        if (![passporttest evaluateWithObject:passport]) {
            break;
        }
        bRet = YES;
    } while (0);
    return bRet;
}

@end
