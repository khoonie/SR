//
//  DetailViewController.h
//  stockrobot
//
//  Created by BMM on 13/3/2.
//  Copyright (c) 2013年 BMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionCell.h"
#import "CustomCollectionIndCell.h"
#import "CustomCollectionHeader.h"
#import "CustomCollectionTrendCell.h"
#import "CustomCollectionVolCell.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *stockCollection;
@property (strong, nonatomic) NSArray *arrayOfStocks;
@property (strong, nonatomic) NSArray *arrayOfStocks2;
@property (strong, nonatomic) NSArray *arrayOfStockPerformance;
@property (strong, nonatomic) NSArray *arrayOfSectorPerformance;
@property (weak, nonatomic) IBOutlet UILabel *currectUpdateDate;

@property (strong, nonatomic) NSString *numberOfDays;
@property (strong, nonatomic) NSString *tableToReadFrom;
@property (strong, nonatomic) NSString *codeToReferFrom;
@property (strong, nonatomic) NSString *headerText;
@property (nonatomic) BOOL okToLoad;
@property (nonatomic) BOOL sectorTable;
@property (nonatomic) int typeOfCell;
@property (weak, nonatomic) IBOutlet UIButton *oneD;
@property (weak, nonatomic) IBOutlet UIButton *twoD;
@property (weak, nonatomic) IBOutlet UIButton *fiveD;
@property (weak, nonatomic) IBOutlet UIButton *tenD;
@property (weak, nonatomic) IBOutlet UIButton *twentyD;
@property (weak, nonatomic) IBOutlet UIButton *onetwentyD;
@property (weak, nonatomic) IBOutlet UIButton *twosixtyD;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) MBProgressHUD *HUD;

-(void)changeDisplay:(NSUInteger)displayType displayName:(NSString*)str;

-(IBAction)press1D:(id)sender;
-(IBAction)press2D:(id)sender;
-(IBAction)press5D:(id)sender;
-(IBAction)press10D:(id)sender;
-(IBAction)press20D:(id)sender;
-(IBAction)press120D:(id)sender;
-(IBAction)press260D:(id)sender;


@end
