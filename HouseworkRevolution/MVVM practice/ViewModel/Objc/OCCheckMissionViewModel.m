//
//  OCCheckMissionViewModel.m
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import "OCCheckMissionViewModel.h"
#import <HouseworkRevolution-Swift.h>

@interface OCCheckMissionViewModel()

@end

// ?
@implementation OCMissionObject

@end

@implementation OCCheckMissionViewModel

- (NSArray *)weekdays {
    
    return [NSArray arrayWithObjects:
            @"Monday",
            @"Tuesday",
            @"Wednesday",
            @"Thursday",
            @"Friday",
            @"Saturday",
            @"Sunday", nil];
}

- (NSArray *)weekdaysInCH {
    
    return [NSArray arrayWithObjects:
            @"星期一",
            @"星期二",
            @"星期三",
            @"星期四",
            @"星期五",
            @"星期六",
            @"星期日", nil];
}

- (void) getMissionObjects:(void (^)(void))completion {
    
    FirebaseHelper *firebaseHelper = [[FirebaseHelper alloc]init];
    
    int count = [self.weekdays count];
    
    int i;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (i = 0; i < count; i++) {
        
        dispatch_group_enter(group);
        
        NSString *weekday = [self.weekdays objectAtIndex: i];
        
        NSArray *dailyMissions = [firebaseHelper getAllMissionsForOCWithDay: weekday];
        
        NSLog(@"'%@' 的任務有：", weekday);
        NSLog(@"家事：'%@'", dailyMissions);
        
        int dailyMissionCount = [dailyMissions count];
        
        int a;
        
        NSMutableArray *dailyMissionsVMArr;
        
        for (a = 0; a < dailyMissionCount; a++) {
            
            OCMissionObject *mission = [dailyMissions objectAtIndex: a];
            
            OCMissionCellViewModel * cellViewModel = [OCMissionCellViewModel initWithMissionObject: mission];
            
            [dailyMissionsVMArr addObject: cellViewModel];
            
            dispatch_group_leave(group);
        }
        
        [self.OCCellViewModel setValue:dailyMissionsVMArr forKey: weekday];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        completion;
    });
}

- (void) deleteMissionObject:(int)missionIndex onDayIndex:(int)day {
    
    FirebaseHelper *firebaseHelper = [[FirebaseHelper alloc]init];
    
    NSString *missionDay = [self.weekdays objectAtIndex: day];
    
    NSArray *missionsOfDay = [self.OCCellViewModel objectForKey: missionDay];
    
    OCMissionObject *toBeDeletedMission = [missionsOfDay objectAtIndex: missionIndex];
    
    [firebaseHelper deleteMissionWithTitle: toBeDeletedMission.title
                                    tiredValue:toBeDeletedMission.tiredValue
                                    weekday: missionDay];
}

@end
