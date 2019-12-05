//
//  OCCheckMissionViewModel.h
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCCheckMissionViewModelDelegate <NSObject>

- (void) missionDeleted;

@end

@interface OCCheckMissionViewModel : NSObject

@property (nonatomic, assign) id<OCCheckMissionViewModelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
