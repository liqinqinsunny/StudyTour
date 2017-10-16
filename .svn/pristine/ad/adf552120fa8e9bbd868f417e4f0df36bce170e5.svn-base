//
//  MyTravelView.m
//  StudyTour
//
//  Created by owen on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "MyTravelView.h"
#import "NSString+Frame.h"

@implementation MyTravelView

-(id)init: (id)obj; {
    
    self = [super init];
    if (self) {
        //加载xib
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyTravelView" owner:obj options:nil] objectAtIndex:0];
        
//        [self setFrame:frame];
    }
    return self;
}

-(void)loadData : (MyTravel *)myTravel height:(void(^)(CGFloat height))ScrollHeight
{
    //标题
    self.titleTxt.text = [NSString stringWithFormat:@"第%@天",myTravel.curDays];
     //出发地[2]	(null)	@"startPlace" : @"华盛顿"
    self.travelStart.text = myTravel.startravel;
    self.startDesWidth.constant = [self getLableWidth:self.travelStart.text fontSize:15];
    
    //航班信息
    if (myTravel.travel.count) {
        NSString * trafficDes = [[myTravel.travel objectAtIndex:0] objectForKey:@"trafficDes"];
        if (trafficDes != nil && ![trafficDes isEqualToString: @""]) {
            self.consultDes.text = trafficDes;
            //TODO:如果字体长度大于默认110  目前自动撑开
        }
        else{
            self.consultView.hidden = YES;
            self.stayViewLeftPace.constant = 10;
        }
        
        //目的地
        NSString * desTxt1 = [[myTravel.travel objectAtIndex:0] objectForKey:@"destination"];
        if (desTxt1 != nil) {
            NSString * tools = [[myTravel.travel objectAtIndex:0] objectForKey:@"trafficTool"];
            
            [self.travelTool1 setImage:[UIImage imageNamed:[self getToolWaysImage:[tools intValue]]]];
            self.travelDes1.text = desTxt1;
            self.firstDesWidth.constant = [self getLableWidth:self.travelDes1.text fontSize:15];
        }
        else{
            self.travelTool1.hidden = YES;
            self.travelDes1.hidden = YES;
        }
        
        if (myTravel.travel.count> 1) {
            NSString * desTxt2 = [[myTravel.travel objectAtIndex:1] objectForKey:@"destination"];
            if (desTxt2 != nil) {
                NSString * tools2 = [[myTravel.travel objectAtIndex:1] objectForKey:@"trafficTool"];
                
                [self.travelTool2 setImage:[UIImage imageNamed:[self getToolWaysImage:[tools2 intValue]]]];
                self.travelDes2.text = desTxt2;
                self.secondDesWidth.constant = [self getLableWidth:self.travelDes2.text fontSize:15];
            }
            else
            {
                self.travelTool2.hidden = YES;
                self.travelDes2.hidden = YES;
            }
        }
        else
        {
            self.travelTool2.hidden = YES;
            self.travelDes2.hidden = YES;
        }
        
    }
    else
    {
        self.travelTool1.hidden = YES;
        self.travelDes1.hidden = YES;
        self.travelTool2.hidden = YES;
        self.travelDes2.hidden = YES;
        
        self.consultView.hidden = YES;
        self.stayViewLeftPace.constant = 10;
    }
    
    //酒店
    if (myTravel.liveHotel != nil) {
        self.stayLabel.text = myTravel.liveHotel;
        if (self.consultView.hidden) {
            self.stayViewLeftPace.constant = 10;
        }
        
    }
    else{
        self.stayView.hidden = YES;
    }
    
//    //行程描述
    self.travelDescribe.text = myTravel.tripDes;
    CGFloat txtheight =  [self getLableHeight:self.travelDescribe.text fontSize:13.0];

    //146 是除了字体外的高度
    txtheight = 146 + txtheight;
    ScrollHeight(txtheight);
}

-(void)setBaseLineHidden : (BOOL)isHidden
{
    self.lastLineView.hidden = isHidden;
}

-(void)showCurDayState
{
    //绿色 1 177 105  白色 255 255 255 线 128 216 180
    [self.titleTxt setTextColor: [UIColor colorWithRed:1/255.0 green:177/255.0 blue:105/255.0 alpha:1]];
    
    [self.travelLine setBackgroundColor:[UIColor colorWithRed:128/255.0 green:216/255.0 blue:180/255.0 alpha:1]];
    
    [self.travelView setBackgroundColor:[UIColor colorWithRed:1/255.0 green:177/255.0 blue:105/255.0 alpha:1]];
    
    NSArray * childViews = self.travelView.subviews;
    for (NSInteger i = 0; i < childViews.count; i++) {
        UIView * view = childViews[i];
        NSArray * views = view.subviews;
        if (views.count) {
            for (NSInteger n = 0; n < views.count; n++) {
                UIView * child = views[n];
                [self setLabelColor:child];
            }
        }
        else{
            [self setLabelColor:view];
        }
    }
}

-(void)showCurDayTravelWay : (NSArray *)wayArr
{
    if (wayArr.count == 1) {
        NSString * tools = [[wayArr objectAtIndex:0] objectForKey:@"trafficTool"];
        NSString * imageName = [self getCurToolWaysImage:[tools intValue]];
        [self.travelTool1 setImage:[UIImage imageNamed:imageName]];
    }
    else if(wayArr.count == 2)
    {
        NSString * tools = [[wayArr objectAtIndex:1] objectForKey:@"trafficTool"];
        NSString * imageName = [self getCurToolWaysImage:[tools intValue]];
        [self.travelTool2 setImage:[UIImage imageNamed:imageName]];
    }
    
}

-(void)setLabelColor : (UIView *)label
{
    BOOL ismember = [label isMemberOfClass : [UILabel class]];
    if (ismember) {
        [((UILabel *)label) setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    }
}

-(NSString *)getCurToolWaysImage : (travelTool)tool
{
    if (tool == PLANE) {
        return @"aircraft_white.png";
    }
    else if (tool == BUS){
        return @"Bus_white.png";
    }
    else if (tool == TRAIN){
        return @"Train_white.png";
    }
    else if (tool == BUS){
        return @"Ship_white.png";
    }
    return @"";
}

-(NSString *)getToolWaysImage : (travelTool)tool
{
    if (tool == PLANE) {
        return @"aircraft.png";
    }
    else if (tool == BUS){
        return @"Bus.png";
    }
    else if (tool == TRAIN){
        return @"Train.png";
    }
    else if (tool == BUS){
        return @"Ship.png";
    }
    return @"";
}

-(CGFloat)getLableWidth : (NSString *)str fontSize:(CGFloat)size
{
    CGFloat width = [str widthWithFont:[UIFont systemFontOfSize:size]];
    return width;
}

-(CGFloat)getLableHeight : (NSString *)str fontSize:(CGFloat)size
{
    CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:size] withinWidth:ScreenWidth-50];
    return height;
}

@end
