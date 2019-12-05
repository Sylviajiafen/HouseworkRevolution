//
//  OCMissionCellViewModel.m
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import "OCMissionCellViewModel.h"

@interface OCMissionCellViewModel()

@property Mission housework;

@end

@implementation OCMissionCellViewModel

+ (instancetype) initWithObject:(Mission *)housework {
    
    OCMissionCellViewModel *viewModel = [[OCMissionCellViewModel alloc]initWith:housework];
    
    return viewModel;
}

- (instancetype) initWith:(Mission *)housework {
    self = [super init];
    
    if (self) {
        self.housework = *(housework);
    }
    
    return self;
}

- (NSString *)title {
    
    return self.housework.title;
}

- (int)tiredValue {
    
    return self.housework.tiredValue;
}

- (UIImage *)icon {
    
    if ([self.title  isEqual: @"掃地"]) {
        return [UIImage imageNamed:@"cleanFloorICON"];
    }
    else if ([self.title  isEqual: @"拖地"]) {
        return [UIImage imageNamed: @"mopICON"];
    }
    else if ([self.title  isEqual: @"吸塵"]) {
        return [UIImage imageNamed: @"vacuumICON"];
    }
    else if ([self.title  isEqual: @"倒垃圾"]) {
        return [UIImage imageNamed: @"garbageICON"];
    }
    else if ([self.title  isEqual: @"洗衣服"]) {
        return [UIImage imageNamed: @"laundryICON"];
    }
    else if ([self.title  isEqual: @"煮飯"]) {
        return [UIImage imageNamed: @"cookICON"];
    }
    else if ([self.title  isEqual: @"買菜"]) {
        return [UIImage imageNamed: @"laundryICON"];
    }
    else if ([self.title isEqual: @"掃廁所"]) {
        return [UIImage imageNamed: @"cleanToiletICON"];
    }
    else {
        return [UIImage imageNamed: @"customWorkICON"];
    }
}

@end

// 差 configure METHOD 未轉成 objc
