//
//  PartnerSelectionTableViewController.m
//
//  Created by Lev Trubov on 10/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "PartnerSelectionTableViewController.h"
#import "PartnerChoice.h"

@interface PartnerSelectionTableViewController () {
    NSArray<PartnerChoice *> *partnerList;
}

@property(weak) id<PartnerSelectionViewControllerDelegate> delegate;

@end

@implementation PartnerSelectionTableViewController

-(instancetype)initWithAdType:(NSString *)adType andDelegate:(id<PartnerSelectionViewControllerDelegate>)delegate {
    self = [super init];
    partnerList = [self partnerListForAdType:adType];
    self.delegate = delegate;
    return self;
}

-(NSArray<PartnerChoice *> *)partnerListForAdType:(NSString *)adType {
    if([adType isEqualToString:@"Interstitial"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"AdColony"],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Unity"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"Vungle"],
            [[PartnerChoice alloc] initWithName:@"Criteo"],
            [[PartnerChoice alloc] initWithName:@"Google"],
            [[PartnerChoice alloc] initWithName:@"Nimbus"],
            [[PartnerChoice alloc] initWithName:@"TAM"]
        ];
    } else if([adType isEqualToString:@"Rewarded"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"Auction"],
            [[PartnerChoice alloc] initWithName:@"Vungle"],
            [[PartnerChoice alloc] initWithName:@"AdColony"],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Unity"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"Tapjoy"],
            [[PartnerChoice alloc] initWithName:@"Criteo"],
            [[PartnerChoice alloc] initWithName:@"Nimbus"]
        ];
    } else if([adType isEqualToString:@"Banner"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"AdColony"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Criteo"],
            [[PartnerChoice alloc] initWithName:@"Google"],
            [[PartnerChoice alloc] initWithName:@"Nimbus"],
            [[PartnerChoice alloc] initWithName:@"TAM"]
        ];
    } else if([adType isEqualToString:@"Preroll"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"Google"],
            [[PartnerChoice alloc] initWithName:@"Nimbus"]
        ];
    } else if([adType isEqualToString:@"Small Banner"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Criteo"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"Unity"],
            [[PartnerChoice alloc] initWithName:@"Google"],
            [[PartnerChoice alloc] initWithName:@"Nimbus"],
            [[PartnerChoice alloc] initWithName:@"TAM"]

        ];
    } else if([adType isEqualToString:@"Medium Native"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES]
        ];
    } else if([adType isEqualToString:@"Small Native"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES]
        ];
    }
    
    return @[]; //shouldn't happen
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select Ad Partner";
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"partnerCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeAndExit)];
}

-(void)closeAndExit {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return partnerList.count;
}

//*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell" forIndexPath:indexPath];
    //
    PartnerChoice *pc = partnerList[indexPath.row];
    cell.textLabel.text = pc.name;
    cell.accessoryType = pc.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}
//*/

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerChoice *pc = partnerList[indexPath.row];
    if([pc.name isEqualToString:@"All"]) {
        for(int i = 1; i < partnerList.count; i++) {
            partnerList[i].selected = NO;
        }
        pc.selected = YES;
    } else {
        partnerList[0].selected = NO;
        pc.selected = !pc.selected;
    }
    
    for(int i = 0; i < [tableView numberOfRowsInSection:0]; i++){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = partnerList[i].selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - sending selected partner info on exit

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.isMovingFromParentViewController) {
        [self.delegate partnersSelected:[self extractChosenPartners]];
    }
}

-(NSArray *)extractChosenPartners {
    if(partnerList[0].selected) {
        return @[@"all"];
    }
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    [partnerList enumerateObjectsUsingBlock:^(PartnerChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.selected) {
            [res addObject:[obj.name lowercaseString]];
        }
    }];
    return res;
}

@end
