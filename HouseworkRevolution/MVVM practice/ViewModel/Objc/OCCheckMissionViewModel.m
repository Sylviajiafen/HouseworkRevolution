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

//@property (nonatomic) NSArray *weekdays;

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

- (void) getMissionObjects:(void (^)(void))completion {
    
    FirebaseHelper *firebaseHelper = [[FirebaseHelper alloc]init];
    
    int count = [self.weekdays count];
    
    int i;
    
//    dispatch_group_t group = dispatch_group_create();
    
//    dispatch_group_enter(group);
    
    for (i = 0; i < count; i++) {
        
        NSString *weekday = [self.weekdays objectAtIndex: i];
        
        NSArray *dailyMissions;
        
        dailyMissions = [firebaseHelper getAllMissionsForOCWithDay: weekday];
        
        [self.OCCellViewModel setValue:dailyMissions forKey: weekday];
        
//        dispatch_group_leave(group);
    }
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        completion;
//    });
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
