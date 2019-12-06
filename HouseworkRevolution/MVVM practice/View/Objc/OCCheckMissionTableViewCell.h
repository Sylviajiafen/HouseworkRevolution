//
//  OCCheckMissionTableViewCell.h
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCMissionCellViewModel.h"
#import "OCCheckMissionTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class OCCheckMissionTableViewCell;

@class OCMissionCellViewModel;

@protocol OCCheckMissionTableViewCellDelegate <NSObject>

- (void) removeMission: (OCCheckMissionTableViewCell *)cell;

@end

@interface OCCheckMissionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<OCCheckMissionTableViewCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *missionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *houseworkIcon;
@property (nonatomic, weak)IBOutlet UILabel *tiredValueLabel;

- (void) setByViewModel: (OCMissionCellViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
