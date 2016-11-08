//
//  CommonCityController.m
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SettingCityController.h"
#import "SRUserDefaults.h"
#import "SRLocationTool.h"
#import "SRWeatherDataTool.h"
#import "SRWeatherCityTool.h"

@interface SettingCityController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *commonCities;

@property (nonatomic, weak  ) UISwitch       *autoLocationSwitch;

@property (nonatomic, strong) UITableView    *tableView;

@end

@implementation SettingCityController

#pragma mark - Lazy load

- (NSMutableArray *)commonCities {
    
    if (!_commonCities) {
        _commonCities = [NSMutableArray arrayWithArray:[SRWeatherCityTool commonCities]];
    }
    return _commonCities;
}

#pragma mark - Life circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACKGROUND_GRAY;
    
    [self setupNavBar];
    
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationServicesDisabled)
                                                 name:SRLocationServicesDisabled object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationServicesAuthorizationStatusDenied)
                                                 name:SRLocationServicesAuthorizationStatusDenied object:nil];
}

#pragma mark - Init setting

- (void)setupTableView {
    
    _tableView                = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource     = self;
    _tableView.delegate       = self;
    _tableView.rowHeight      = SCREEN_ADJUST(50);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)setupNavBar {

    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(dismissAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                           target:self
                                                                                           action:@selector(editAction)];
}

#pragma mark - Monitor method

- (void)dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editAction {
    
    if (self.commonCities.count == 0) {
        return;
    }
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                               target:self
                                                                                               action:@selector(editAction)];
    } else {
        [self setupNavBar];
    }
}

- (void)switchViewAction:(UISwitch *)sender {
    
    if (sender.isOn) {
        [SRLocationTool sharedInstance].autoLocation = YES;
        
        if ([self.delegate respondsToSelector:@selector(settingCityControllerDidOpenAutoLocation)]) {
            [self.delegate settingCityControllerDidOpenAutoLocation];
        }
    } else {
        [SRLocationTool sharedInstance].autoLocation = NO;
        [SRLocationTool sharedInstance].currentLocationCity = nil;
    
        if ([self.delegate respondsToSelector:@selector(settingCityControllerDidCloseAutoLocation)]) {
            [self.delegate settingCityControllerDidCloseAutoLocation];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([SRLocationTool sharedInstance].isAutoLocation && [SRLocationTool sharedInstance].currentLocationCity) {
            return 2;
        }
        return 1;
    }
    return self.commonCities.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"自动定位";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:SCREEN_ADJUST(15)];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0 , 0, 60, 30)];
            [switchView setOnTintColor:[UIColor grayColor]];
            [switchView setTintColor:COLOR_BACKGROUND_GRAY];
            [switchView addTarget:self action:@selector(switchViewAction:) forControlEvents:UIControlEventValueChanged];
            switchView.on = [[SRLocationTool sharedInstance] isAutoLocation];
            cell.accessoryView = switchView;
            self.autoLocationSwitch = switchView;
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = [[SRLocationTool sharedInstance] currentLocationCity];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:SCREEN_ADJUST(15)];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_location_dark"]];
        }
        UIView *divider= [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_ADJUST(50) - 1, SCREEN_WIDTH, 1)];
        divider.backgroundColor = COLOR_DIVIDERLIN;
        [cell addSubview:divider];
    } else {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:SCREEN_ADJUST(16)];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.text = @"常用城市";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            static NSString * const cellID = @"cellID";
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.font = [UIFont systemFontOfSize:SCREEN_ADJUST(15)];
            }
            cell.textLabel.text = self.commonCities[indexPath.row - 1];
        }
        UIView *divider= [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_ADJUST(50) - 1, SCREEN_WIDTH, 1)];
        divider.backgroundColor = COLOR_DIVIDERLIN;
        [cell addSubview:divider];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *city = self.commonCities[indexPath.row - 1];
        [self.commonCities removeObjectAtIndex:indexPath.row - 1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(settingCityControllerDidDeleteCommonCity:)]) {
            [self.delegate settingCityControllerDidDeleteCommonCity:city];
        }
        
        if (self.commonCities.count == 0) {
            [self setupNavBar];
            [self editAction];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString *city = self.commonCities[fromIndexPath.row - 1];
    [self.commonCities removeObject:city];
    
    if (toIndexPath.section == 0 || toIndexPath.row == 0) {
        [self.commonCities insertObject:city atIndex:0];
        [SRWeatherCityTool saveCommonCities:[self.commonCities copy]];
        [self.tableView reloadData];
    } else {
        [self.commonCities insertObject:city atIndex:toIndexPath.row - 1];
        [SRWeatherCityTool saveCommonCities:[self.commonCities copy]];
    }
    if ([self.delegate respondsToSelector:@selector(settingCityControllerDidReorderCommonCity)]) {
        [self.delegate settingCityControllerDidReorderCommonCity];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 0.1;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        if ([self.delegate respondsToSelector:@selector(settingCityControllerDidSelectCity:isLocationCity:)]) {
            [self.delegate settingCityControllerDidSelectCity:[SRLocationTool sharedInstance].currentLocationCity isLocationCity:YES];
        }
        [self dismissAction];
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *city = cell.textLabel.text;
    if ([self.delegate respondsToSelector:@selector(settingCityControllerDidSelectCity:isLocationCity:)]) {
        [self.delegate settingCityControllerDidSelectCity:city isLocationCity:NO];
    }
    [self dismissAction];
}

#pragma mark - Public method

- (void)showAlertController:(NSString *)message {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       self.autoLocationSwitch.on = NO;
                                                   }];
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)locationServicesDisabled {
    
    [self showAlertController:@"请打开系统定位服务"];
}

- (void)locationServicesAuthorizationStatusDenied {
    
    [self showAlertController:@"请允许APP使用定位功能\n设置->隐私->定位服务->幻视"];
}

- (void)reloadCommonCityTableViewIsInsert:(BOOL)isInsert {
    
    if (isInsert) {
        [self insertTableViewRowForLocationCity];
    } else {
        [self deleteTableViewRowForLocationCity];
    }
}

- (void)insertTableViewRowForLocationCity {
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)deleteTableViewRowForLocationCity {
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows == 2) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
