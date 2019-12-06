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

@end

@implementation OCCheckMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.OCMainViewModel = [[OCCheckMissionViewModel alloc]init];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)missionDeleted {
    // 
}

@end
