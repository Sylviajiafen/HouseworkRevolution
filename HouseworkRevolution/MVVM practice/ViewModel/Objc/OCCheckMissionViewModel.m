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

@property NSArray *weekdays;

@end

// ?
@implementation OCMissionObject

@end

@implementation OCCheckMissionViewModel

- (void) getMissionObjects {
    
    FirebaseHelper *firebaseHelper = [[FirebaseHelper alloc]init];
    
    self.weekdays = [NSArray arrayWithObjects:
                     @"Monday",
                     @"Tuesday",
                     @"Wednesday",
                     @"Thursday",
                     @"Friday",
                     @"Saturday",
                     @"Sunday", nil];
    
    int count = [self.weekdays count];
    
    int i;
    
    for (i = 0; i < count; i++) {
        
        NSString *weekday = [self.weekdays objectAtIndex: i];
        
        NSArray *dailyMissions;
        
        dailyMissions = [firebaseHelper getAllMissionsForOCWithDay: weekday];
        
        [self.OCCellViewModel setValue:dailyMissions forKey: weekday];
    }
}

- (void) deleteMissionObject:(int)missionIndex onDayIndext:(int)day {
    
    FirebaseHelper *firebaseHelper = [[FirebaseHelper alloc]init];
    
    NSString *missionDay = [self.weekdays objectAtIndex: day];
    
    NSArray *missionsOfDay = [self.OCCellViewModel objectForKey: missionDay];
    
    OCMissionObject *toBeDeletedMission = [missionsOfDay objectAtIndex: missionIndex];
    
    [firebaseHelper deleteMissionWithTitle: toBeDeletedMission.title
                                    tiredValue:toBeDeletedMission.tiredValue
                                    weekday: missionDay];
}

@end
