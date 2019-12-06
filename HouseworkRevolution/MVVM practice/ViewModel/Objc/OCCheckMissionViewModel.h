//
//  OCCheckMissionViewModel.h
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OCMissionCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OCCheckMissionViewModelDelegate <NSObject>

- (void) missionDeleted;

@end

@interface OCCheckMissionViewModel : NSObject

@property (nonatomic) NSArray *weekdays;

@property (nonatomic, weak) id<OCCheckMissionViewModelDelegate> delegate;

@property NSDictionary <NSString *, id> *OCCellViewModel;

- (void) getMissionObjects;

- (void) deleteMissionObject: (int)missionIndex onDayIndext: (int)day;

@end

@class FirebaseHelper;

NS_ASSUME_NONNULL_END
