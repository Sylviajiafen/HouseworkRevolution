//
//  OCCheckMissionViewController.m
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

#import "OCCheckMissionViewController.h"

@interface OCCheckMissionViewController () <UITableViewDelegate, UITableViewDataSource>

@property OCCheckMissionViewModel *OCMainViewModel;

@property (nonatomic, weak) IBOutlet UITableView *OCCheckMissionTableView;

@end

@implementation OCCheckMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.OCMainViewModel = [[OCCheckMissionViewModel alloc]init];
    
    self.OCMainViewModel.delegate = self;
    
    self.OCCheckMissionTableView.delegate = self;
    
    self.OCCheckMissionTableView.dataSource = self;
    
    UINib *headerXib = [UINib nibWithNibName:@"WeekdaySectionHeaderView" bundle: nil];
    
    [self.OCCheckMissionTableView registerNib:headerXib
           forHeaderFooterViewReuseIdentifier: @" WeekdaySectionHeaderView"];
    
    [self.OCMainViewModel getMissionObjects:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.OCCheckMissionTableView reloadData];
        });
    }];
}


- (IBAction)backToPrevious:(id)sender {
    
    [self dismissViewControllerAnimated: true completion: nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OCWeekdaySectionHeaderView *header = [self.OCCheckMissionTableView
                      dequeueReusableHeaderFooterViewWithIdentifier: @"WeekdaySectionHeaderView"];
    
    NSString *day = [self.OCMainViewModel.weekdays objectAtIndex: section];
    
    header.weekdayLabel.text = day;
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.OCMainViewModel.weekdays count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                             cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *day = [self.OCMainViewModel.weekdays objectAtIndex: indexPath.section];
    
    NSArray *dailyMissions = [self.OCMainViewModel.OCCellViewModel objectForKey:day];
    
    NSInteger missionsCount = [dailyMissions count];
    
    if (missionsCount > 0) {
        
        static NSString *identifier = @"MissionListTableViewCell";
        
        OCCheckMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        if (cell == nil) {
            
            cell = [[OCCheckMissionTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                        reuseIdentifier: identifier];
            
            return cell;
        }
        
        cell.delegate = self;
        
        [cell setByViewModel: [dailyMissions objectAtIndex: indexPath.row]];
        
        return cell;
        
    } else {
        
        static NSString *emptyCellIdentifier = @"MissionEmptyTableViewCell";
        
        OCEmptyMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: emptyCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[OCEmptyMissionTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                        reuseIdentifier: emptyCellIdentifier];
            
            return cell;
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSString *day = [self.OCMainViewModel.weekdays objectAtIndex: section];
    
    NSArray *dailyMissions = [self.OCMainViewModel.OCCellViewModel objectForKey:day];
    
    NSInteger missionsCount = [dailyMissions count];
    
    if (missionsCount == 0) {
        
        return 1;
        
    } else {
        
        return missionsCount;
    }
}

- (void)missionDeleted {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.OCCheckMissionTableView reloadData];
    });
}

- (void)removeMission:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.OCCheckMissionTableView indexPathForCell:cell];
    
    [self.OCMainViewModel deleteMissionObject: (int) indexPath.row onDayIndex: (int) indexPath.section];
}

@end
