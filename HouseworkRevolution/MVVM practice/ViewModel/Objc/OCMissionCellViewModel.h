//
//  OCMissionCellViewModel.h
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct Mission {
    
    NSString *title;
    
    int tiredValue;
};
typedef struct OCMission Mission;

@interface OCMissionCellViewModel : NSObject

+ (instancetype) initWithMissionObject: (NSObject *)housework;

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) int tiredValue;

@property (nonatomic, readonly) UIImage *icon;

@end


@interface OCMissionObject : NSObject

@property NSString *title;

@property int tiredValue;

@end

NS_ASSUME_NONNULL_END
