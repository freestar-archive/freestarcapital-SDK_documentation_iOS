//
//  PartnerSelectionTableViewController.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "PartnerSelectionTableViewController.h"
#import "PartnerChoice.h"

@interface PartnerSelectionTableViewController () {
    NSArray<PartnerChoice *> *partnerList;
}

@end

@implementation PartnerSelectionTableViewController

-(instancetype)initWithAdType:(NSString *)adType {
    self = [super init];
    partnerList = [self partnerListForAdType:adType];
    return self;
}

-(NSArray<PartnerChoice *> *)partnerListForAdType:(NSString *)adType {
    if([adType isEqualToString:@"Interstitial"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"Chocolate"],
            [[PartnerChoice alloc] initWithName:@"AdColony"],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Unity"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"Vungle"],
            [[PartnerChoice alloc] initWithName:@"Amazon"],
            [[PartnerChoice alloc] initWithName:@"Criteo"]
        ];
    } else if([adType isEqualToString:@"Rewarded"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"Auction"],
            [[PartnerChoice alloc] initWithName:@"Chocolate"],
            [[PartnerChoice alloc] initWithName:@"Vungle"],
            [[PartnerChoice alloc] initWithName:@"AdColony"],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Unity"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"Tapjoy"],
            [[PartnerChoice alloc] initWithName:@"Amazon"],
            [[PartnerChoice alloc] initWithName:@"Criteo"]
        ];
    } else if([adType isEqualToString:@"Banner"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"Chocolate"],
            [[PartnerChoice alloc] initWithName:@"AdColony"],
            [[PartnerChoice alloc] initWithName:@"AppLovin"],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Yahoo"],
            [[PartnerChoice alloc] initWithName:@"Amazon"],
            [[PartnerChoice alloc] initWithName:@"Criteo"]
        ];
    } else if([adType isEqualToString:@"Preroll"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"Chocolate"],
            [[PartnerChoice alloc] initWithName:@"Google"],
            [[PartnerChoice alloc] initWithName:@"Amazon"]
        ];
    } else if([adType isEqualToString:@"Small Banner"]) {
        return @[
            [[PartnerChoice alloc] initWithName:@"All" andSelected:YES],
            [[PartnerChoice alloc] initWithName:@"GoogleAdmob"],
            [[PartnerChoice alloc] initWithName:@"Amazon"],
            [[PartnerChoice alloc] initWithName:@"Criteo"]
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
//
//    [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.accessoryType = UITableViewCellAccessoryNone;
//    }];
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    chosenPartnerIndex = indexPath.row;
}

#pragma mark - sending selected partner info on exit

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.isMovingFromParentViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChocolateSelectedNotification object:[self extractChosenPartners]];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
