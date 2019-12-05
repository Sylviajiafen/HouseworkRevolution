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

@property (nonatomic, weak) id<OCCheckMissionViewModelDelegate> delegate;

@property NSDictionary <NSString *, id> *OCCellViewModel;

- (OCMissionObject *) getMissionObjects: (NSString *)day;

@end

NS_ASSUME_NONNULL_END
