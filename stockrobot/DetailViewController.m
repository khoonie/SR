//
//  DetailViewController.m
//  stockrobot
//
//  Created by BMM on 13/3/2.
//  Copyright (c) 2013年 BMM. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize arrayOfStocks, arrayOfStocks2;
@synthesize stockCollection;
@synthesize arrayOfStockPerformance, arrayOfSectorPerformance;
@synthesize numberOfDays, navItem, tableToReadFrom, codeToReferFrom;
@synthesize HUD, okToLoad, sectorTable, headerText, typeOfCell;
@synthesize currectUpdateDate;

typedef enum {
    
    perfType = 0,
    indType = 1,
    trendType = 2,
    volType = 3,
    trendVolType=4,
    
} cellType;

#pragma mark - HUD

-(void)hudWasHidden:(MBProgressHUD*)hud
{
    [HUD removeFromSuperViewOnHide];
    HUD = nil;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}


-(void) loadDataFromParse:(int)option
{
    
        
    // load in all the stock code, name, and industry
    PFQuery *query = [PFQuery queryWithClassName:codeToReferFrom];
    query.limit = 900;
    [query whereKey:@"indcode" greaterThan:[NSNumber numberWithInt:0]];
    [query orderByAscending:@"indcode"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
        arrayOfStocks = [[NSArray alloc]initWithArray:objects];
        
    } else {
        NSLog(@"Error Loading");
    }   
     [HUD hide:YES];
    } ];
}

-(void) loadPerformanceFromParse
{
    HUD  = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    PFQuery *query = [PFQuery queryWithClassName:tableToReadFrom];
    query.limit = 900;
    
    [query orderByDescending:numberOfDays];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            arrayOfStockPerformance = [[NSArray alloc]initWithArray:objects];
            [stockCollection reloadData];
            [HUD hide:YES];
        } else {
            NSLog(@"Error Loading");
            [HUD hide:YES];
        }
        okToLoad = TRUE;
        [self enableAllButtons];
    } ];
}

-(void) loadTrendFromParse
{
    HUD  = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    PFQuery *query = [PFQuery queryWithClassName:tableToReadFrom];
    query.limit = 900;
    
    NSSortDescriptor *trend1Descriptor = [[NSSortDescriptor alloc] initWithKey:@"trend2" ascending:NO];
    NSSortDescriptor *trend2Descriptor = [[NSSortDescriptor alloc] initWithKey:@"trend1" ascending:NO];
    NSArray *sortDescriptors = @[trend1Descriptor, trend2Descriptor];
    
    [query orderBySortDescriptors:sortDescriptors];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            arrayOfStockPerformance = [[NSArray alloc]initWithArray:objects];
            [stockCollection reloadData];
            [HUD hide:YES];
        } else {
            NSLog(@"Error Loading");
            [HUD hide:YES];
        }
        okToLoad = TRUE;
        [self hideAllButtons];
    } ];
}

-(void) loadVolFromParse
{
    HUD  = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    PFQuery *query = [PFQuery queryWithClassName:tableToReadFrom];
    query.limit = 900;
    
    NSSortDescriptor *volDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Parse_50V" ascending:NO];
    
    [query orderBySortDescriptor:volDescriptor];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            arrayOfStockPerformance = [[NSArray alloc]initWithArray:objects];
            [stockCollection reloadData];
            [HUD hide:YES];
        } else {
            NSLog(@"Error Loading");
            [HUD hide:YES];
        }
        okToLoad = TRUE;
        [self hideAllButtons];
    } ];

    
}

-(void) loadVolTrendFromParse
{
    HUD  = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    PFQuery *query = [PFQuery queryWithClassName:tableToReadFrom];
    query.limit = 900;
    
    NSSortDescriptor *trend1Descriptor = [[NSSortDescriptor alloc] initWithKey:@"trend2" ascending:NO];
    NSSortDescriptor *trend2Descriptor = [[NSSortDescriptor alloc] initWithKey:@"trend1" ascending:NO];
    NSSortDescriptor *volDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Parse_50V" ascending:NO];
    NSArray *sortDescriptors = @[trend1Descriptor, trend2Descriptor, volDescriptor];
    
    [query orderBySortDescriptors:sortDescriptors];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            arrayOfStockPerformance = [[NSArray alloc]initWithArray:objects];
            [stockCollection reloadData];
            [HUD hide:YES];
        } else {
            NSLog(@"Error Loading");
            [HUD hide:YES];
        }
        okToLoad = TRUE;
        [self hideAllButtons];
    } ];    
    
}


-(void) loadSectorsFromParse
{
    HUD  = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    PFQuery *query = [PFQuery queryWithClassName:tableToReadFrom];
    query.limit = 900;
    
    [query orderByDescending:numberOfDays];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            arrayOfSectorPerformance = [[NSArray alloc]initWithArray:objects];
            [stockCollection reloadData];
            [HUD hide:YES];
        } else {
            NSLog(@"Error Loading");
            [HUD hide:YES];
        }
        okToLoad = TRUE;
        [self enableAllButtons];
    } ];
    
}


-(NSString*)convertToUTC:(NSDate*)GMTDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];

    NSString *dateString = [dateFormatter stringFromDate:GMTDate];
    
    return dateString;
    
}

-(void) loadDateFromParse
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"UpdatedStamp"];
    query.limit = 10;
    
    //[query whereKey:@"tablename" containsString:@"stocks_perf"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSArray *tempArray = [[NSArray alloc]initWithArray:objects];
            NSIndexPath *tempPath = [NSIndexPath indexPathForItem:0 inSection:0];
            PFObject *tempObj = [tempArray objectAtIndex:tempPath.item];
            NSDate *tempDate = [tempObj objectForKey:@"latest"];
            NSLog(@"Date = %@",[tempDate description]);
            [self.currectUpdateDate setText:[self convertToUTC:tempDate]];
        } else {
            NSLog(@"Error Loading");
        }
        
    } ];
    
}

-(NSUInteger) findIndexOfValue:(NSString*)code
{
    NSUInteger result = [arrayOfStockPerformance indexOfObjectPassingTest:^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        return [[dict objectForKey:@"code"] isEqualToString:code];
    }];
    
    return result;
}

-(NSUInteger) findIndexOfDetail:(NSString*)code
{
    NSUInteger result = [arrayOfStocks indexOfObjectPassingTest:^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        return [[dict objectForKey:@"code"] isEqualToString:code];
    }];
    
    return result;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    okToLoad = FALSE;
    sectorTable = FALSE;
    typeOfCell = perfType;
    numberOfDays = @"D";
    tableToReadFrom = @"stocks_perf";
    codeToReferFrom = @"stock_code";
    headerText = @"上市全部";
    [self.stockCollection setPagingEnabled:NO];
    [self loadDataFromParse:0];
    [self loadPerformanceFromParse];
    [self loadDateFromParse];
    

}


-(UIImage*)getIndustryIcon:(NSUInteger)indcode
{
    UIImage* tempImage;
    
    switch (indcode) {
        case 1:
            tempImage = [UIImage imageNamed:@"cement.png"];
            break;
        case 2:
            tempImage = [UIImage imageNamed:@"food.png"];
            break;
        case 3:
            tempImage = [UIImage imageNamed:@"plastic.png"];
            break;
        case 4:
            tempImage = [UIImage imageNamed:@"textile.png"];
            break;
        case 5:
            tempImage = [UIImage imageNamed:@"machine.png"];
            break;
        case 6:
            tempImage = [UIImage imageNamed:@"appliance.png"];
            break;
        case 8:
            tempImage = [UIImage imageNamed:@"glass.png"];
            break;
        case 9:
            tempImage = [UIImage imageNamed:@"paper.png"];
            break;
        case 10:
            tempImage = [UIImage imageNamed:@"metal.png"];
            break;
        case 11:
            tempImage = [UIImage imageNamed:@"rubber.png"];
            break;
        case 12:
            tempImage = [UIImage imageNamed:@"auto.png"];
            break;
        case 14:
            tempImage = [UIImage imageNamed:@"construction.png"];
            break;
        case 15:
            tempImage = [UIImage imageNamed:@"transport.png"];
            break;
        case 16:
            tempImage = [UIImage imageNamed:@"tourism.png"];
            break;
        case 17:
            tempImage = [UIImage imageNamed:@"finance.png"];
            break;
        case 18:
            tempImage = [UIImage imageNamed:@"trade.png"];
            break;
        case 20:
            tempImage = [UIImage imageNamed:@"other.png"];
            break;
        case 21:
            tempImage = [UIImage imageNamed:@"chemical.png"];
            break;
        case 22:
            tempImage = [UIImage imageNamed:@"bio.png"];
            break;
        case 23:
            tempImage = [UIImage imageNamed:@"Energy.png"];
            break;
        case 24:
            tempImage = [UIImage imageNamed:@"semicon.png"];
            break;
        case 25:
            tempImage = [UIImage imageNamed:@"peripheral.png"];
            break;
        case 26:
            tempImage = [UIImage imageNamed:@"fiber.png"];
            break;
        case 27:
            tempImage = [UIImage imageNamed:@"comm.png"];
            break;
        case 28:
            tempImage = [UIImage imageNamed:@"parts.png"];
            break;
        case 29:
            tempImage = [UIImage imageNamed:@"email.png"];
            break;
        case 30:
            tempImage = [UIImage imageNamed:@"it.png"];
            break;
        case 31:
            tempImage = [UIImage imageNamed:@"otherelec.png"];
            break;
        case 91:
            tempImage = [UIImage imageNamed:@"tdr.png"];
            break;
        case 99:
            tempImage = [UIImage imageNamed:@"manage.png"];
            break;
        default:
            break;
    }
    return tempImage;
}

-(void) viewDidUnload{
    
    [self setStockCollection:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection Header

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
    
    [header.headerLabel setText:headerText];
    return header;
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark CollectionView Delegates and Methods

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    int i;
    switch (typeOfCell) {
        case perfType:
            i = [arrayOfStocks count];
            break;
        case indType:
            i = [arrayOfSectorPerformance count];
            break;
        case trendType:
            i = [arrayOfStocks count];
            break;
        case volType:
            i = [arrayOfStocks count];
            break;
        case trendVolType:
            i = [arrayOfStocks count];
            break;
        default:
            i = 0;
            break;
    }
    
    return i;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdent;
    
    switch (typeOfCell) {
        case perfType:
            cellIdent = @"stockCell";
            break;
        case indType:
            cellIdent = @"sectorCell";
            break;
        case trendType:
            cellIdent = @"trendCell";
            break;
        case volType:
            cellIdent = @"volCell";
            break;
        case trendVolType:
            cellIdent = @"trendVolCell";
            break;
        default:
            break;
    }

    CustomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
    NSNumber *gainNumber;
    
    if (typeOfCell == indType) {
        
        // For Industry Rankings
        
        PFObject *tempObj = [arrayOfSectorPerformance objectAtIndex:indexPath.item];
        NSString *sectorName = [tempObj objectForKey:@"industry"];
        [[cell industry]setText:sectorName];
        gainNumber = [tempObj objectForKey:numberOfDays];
        NSMutableString *gainString = [NSMutableString stringWithFormat:@"%1.2f",[gainNumber floatValue]];
        [gainString appendString:@" %"];
        [[cell returns]setText:gainString];
        NSNumber *indNum = [tempObj objectForKey:@"industrycode"];
        NSLog(@"Interger value is %d",[indNum integerValue]);
        [[cell industryIcon]setImage:[self getIndustryIcon:[indNum integerValue]]];
        
    } else if (typeOfCell == trendType) {
    
    // For Trend Rankings
        NSLog(@"TrendType Cell");
        PFObject *tempObj = [arrayOfStockPerformance objectAtIndex:indexPath.item];
        
        NSString *codeNum = [tempObj objectForKey:@"code"];
        [[cell code]setText:codeNum];
                
        NSUInteger idx = [self findIndexOfDetail:codeNum];
        PFObject *tempObj2 = [arrayOfStocks objectAtIndex:idx];
        
        NSString *stockName = [tempObj2 objectForKey:@"name"];
        [[cell name]setText:stockName];
        NSString *sectorName = [tempObj2 objectForKey:@"industry"];
        [[cell industry]setText:sectorName];
        
        NSNumber *t1 = [tempObj objectForKey:@"trend1"];
        NSNumber *t2 = [tempObj objectForKey:@"trend2"];
        gainNumber = [NSNumber numberWithFloat:[t1 floatValue]];
        //NSMutableString *gainString = [NSMutableString stringWithFormat:@"%1.2f",[gainNumber floatValue]];
        
        NSMutableString *gainString = [NSMutableString stringWithString:[t1 description]];
        [gainString appendString:@":"];
        [gainString appendString:[t2 description]];
        [[cell returns]setText:gainString];
        
        if ([t2 floatValue] > 0) {
            [[cell industryIcon]setImage:[UIImage imageNamed:@"up.png"]];
        } else {
            [[cell industryIcon]setImage:[UIImage imageNamed:@"down.png"]];
        }
        
    } else if (typeOfCell == volType) {
        
        PFObject *tempObj = [arrayOfStockPerformance objectAtIndex:indexPath.item];
        
        NSString* codeNum = [tempObj objectForKey:@"code"];
        [[cell code]setText:codeNum];
        
        gainNumber = [tempObj objectForKey:@"Parse_50V"];
        NSMutableString *gainString = [NSMutableString stringWithFormat:@"%1.2f",[gainNumber floatValue]];
        [gainString appendString:@" %"];
        [[cell returns]setText:gainString];
        
        NSUInteger idx = [self findIndexOfDetail:codeNum];
        PFObject *tempObj2 = [arrayOfStocks objectAtIndex:idx];
        
        NSString* stockName = [tempObj2 objectForKey:@"name"];
        [[cell name]setText:stockName];
        NSString* industry = [tempObj2 objectForKey:@"industry"];
        [[cell industry]setText:industry];
        
    } else if (typeOfCell == trendVolType) {
        
        PFObject *tempObj = [arrayOfStockPerformance objectAtIndex:indexPath.item];
        
        NSString* codeNum = [tempObj objectForKey:@"code"];
        [[cell code]setText:codeNum];
        
        gainNumber = [tempObj objectForKey:@"Parse_50V"];
        NSMutableString *gainString = [NSMutableString stringWithFormat:@"%1.2f",[gainNumber floatValue]];
        [gainString appendString:@" %"];
        [[cell returns]setText:gainString];
        
        NSUInteger idx = [self findIndexOfDetail:codeNum];
        PFObject *tempObj2 = [arrayOfStocks objectAtIndex:idx];
        
        NSString* stockName = [tempObj2 objectForKey:@"name"];
        [[cell name]setText:stockName];
        NSString* industry = [tempObj2 objectForKey:@"industry"];
        [[cell industry]setText:industry];
        
        NSNumber *t1 = [tempObj objectForKey:@"trend1"];
        NSNumber *t2 = [tempObj objectForKey:@"trend2"];
        gainNumber = [NSNumber numberWithFloat:[t1 floatValue]];
        //NSMutableString *gainString = [NSMutableString stringWithFormat:@"%1.2f",[gainNumber floatValue]];
        
        NSMutableString *gainString2 = [NSMutableString stringWithString:[t1 description]];
        [gainString2 appendString:@":"];
        [gainString2 appendString:[t2 description]];
        [[cell ratio]setText:gainString2];
        
        if ([t2 floatValue] > 0) {
            [[cell industryIcon]setImage:[UIImage imageNamed:@"up.png"]];
        } else {
            [[cell industryIcon]setImage:[UIImage imageNamed:@"down.png"]];
        }
        
    }
     else
    {
    
        // For Stock Rankings
        
    PFObject *tempObj = [arrayOfStockPerformance objectAtIndex:indexPath.item];
    
    NSString *codeNum = [tempObj objectForKey:@"code"];
    [[cell code]setText:codeNum];
    gainNumber = [tempObj objectForKey:numberOfDays];
    NSMutableString *gainString = [NSMutableString stringWithFormat:@"%1.2f",[gainNumber floatValue]];
    [gainString appendString:@" %"];
    [[cell returns]setText:gainString];
    
    NSUInteger idx =[self findIndexOfDetail:codeNum];
    PFObject *tempObj2 = [arrayOfStocks objectAtIndex:idx];
    
    NSString *stockName = [tempObj2 objectForKey:@"name"];
    NSString *indName = [tempObj2 objectForKey:@"industry"];
    [[cell name]setText:stockName ];
    [[cell industry]setText:indName];
        
    NSNumber *indNum = [tempObj2 objectForKey:@"indcode"];
    NSLog(@"Interger value is %d",[indNum integerValue]);
    [[cell industryIcon]setImage:[self getIndustryIcon:[indNum integerValue]]];
    
        
    } // else stock ranking
    
    
    UIColor* redcellColor = [UIColor redColor];
    UIColor* darkredcellColor = [UIColor colorWithRed:124/255.0f green:0.0f blue:0.0f alpha:1.0f];
    UIColor* dark2redcellColor = [UIColor colorWithRed:80/255.0f green:0.0f blue:0.0f alpha:1.0f];
    UIColor* midredcellColor = [UIColor colorWithRed:200/255.0f green:0.0f blue:0.0F alpha:1.0f];
    UIColor* greycellColor = [UIColor grayColor];
    UIColor* greencellColor = [UIColor greenColor];
    UIColor* midgreencellColor = [UIColor colorWithRed:0.0f green:200/255.0f blue:0.0f alpha:1.0f];
    UIColor* darkgreencellColor = [UIColor colorWithRed:0.0f green:124/255.0f blue:0.0f alpha:1.0f];
    UIColor* dark2greencellColor = [UIColor colorWithRed:0.0f green:80/255.0f blue:0.0f alpha:1.0f];

    if ([gainNumber floatValue] >4) {
        [cell setBackgroundColor:redcellColor];
    } else if (([gainNumber floatValue] >2.5) && ([gainNumber floatValue] <=4)) {
        [cell setBackgroundColor:midredcellColor];
    } else if (([gainNumber floatValue] >1) && ([gainNumber floatValue] <=2.5)) {
        [cell setBackgroundColor:darkredcellColor];
    } else if (([gainNumber floatValue] >0) && ([gainNumber floatValue] <=1)) {
        [cell setBackgroundColor:dark2redcellColor];
    } else if ([gainNumber floatValue] == 0) {
        [cell setBackgroundColor:greycellColor];
    } else if (([gainNumber floatValue] >-1) && ([gainNumber floatValue] <0)) {
        [cell setBackgroundColor:dark2greencellColor];
    } else if (([gainNumber floatValue] >-2.5) && ([gainNumber floatValue] <=-1)) {
        [cell setBackgroundColor:darkgreencellColor];
    } else if (([gainNumber floatValue] >-4) && ([gainNumber floatValue] <=-2.5)) {
        [cell setBackgroundColor:midgreencellColor];
    } else if (([gainNumber floatValue] <=-4)){
        [cell setBackgroundColor:greencellColor];
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // TODO: do something when item is selected
}

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets cellInsets=UIEdgeInsetsMake(2.0,2.0,2.0,2.0);
    return cellInsets;
}

#pragma mark -

#pragma mark changeDisplay Method

-(void)changeDisplay:(NSUInteger)displayType displayName:(NSString*)str
{
    if (okToLoad) {
        
        [self disableAllButtons];
    switch (displayType) {
        case 1:
            // All TSE Stocks
            NSLog(@"TSE Stocks");
            numberOfDays = @"D";
            navItem.title = @"1 Day";
            typeOfCell = perfType;
            codeToReferFrom = @"stock_code";
            tableToReadFrom = @"stocks_perf";
            headerText = str;
            sectorTable = NO;
            break;
            
        case 2:
            NSLog(@"TSE Industry Ranking");
            numberOfDays = @"D";
            navItem.title = @"1 Day";
            headerText = str;
            typeOfCell = indType;
            tableToReadFrom = @"sector_perf";
            sectorTable = YES;
            break;
        case 3:
            NSLog(@"TSE trending");
            navItem.title = @"Trends";
            headerText = str;
            typeOfCell = trendType;
            codeToReferFrom = @"stock_code";
            tableToReadFrom = @"stocks_perf";
            sectorTable = NO;
            break;
        case 4:
            NSLog (@"TSE Volume");
            navItem.title = @"Volume";
            headerText = str;
            typeOfCell = volType;
            codeToReferFrom = @"stock_code";
            tableToReadFrom = @"stocks_perf";
            sectorTable = NO;
            break;
        case 5:
            NSLog (@"TSE Trend Volume");
            navItem.title = @"Trend + Volume";
            headerText = str;
            typeOfCell = trendVolType;
            codeToReferFrom = @"stock_code";
            tableToReadFrom = @"stocks_perf";
            sectorTable = NO;
            break;
        case 11:
            // All Gretai Stocks
            NSLog(@"Gretai Stocks");
            numberOfDays = @"D";
            navItem.title = @"1 Day";
            codeToReferFrom = @"stock_code2";
            tableToReadFrom = @"stocks_perf2";
            headerText = str;
            typeOfCell = perfType;
            sectorTable =NO;
            break;
        case 12:
            // All Gretai Stocks
            NSLog(@"Gretai Industry Ranking");
            numberOfDays = @"D";
            navItem.title = @"1 Day";
            headerText = str;
            typeOfCell = indType;
            tableToReadFrom = @"sector_perf2";
            sectorTable = YES;
            break;
        case 13:
            NSLog (@"Gretai Trending");
            navItem.title = @"Trends";
            headerText = str;
            typeOfCell = trendType;
            codeToReferFrom = @"stock_code2";
            tableToReadFrom = @"stocks_perf2";
            break;
        case 14:
            NSLog (@"Gretai Volume");
            navItem.title = @"Volume";
            headerText = str;
            typeOfCell = volType;
            codeToReferFrom = @"stock_code2";
            tableToReadFrom = @"stocks_perf2";
            sectorTable = NO;
            break;
        case 15:
            NSLog (@"GRETAI Trend Volume");
            navItem.title = @"Trend + Volume";
            headerText = str;
            typeOfCell = trendVolType;
            codeToReferFrom = @"stock_code2";
            tableToReadFrom = @"stocks_perf2";
            sectorTable = NO;
            break;
        default:
            break;
    }
    
        switch (typeOfCell) {
            case perfType:
                    arrayOfStockPerformance = nil;
                    arrayOfStocks = nil;
                    [self loadDataFromParse:0];
                    [self loadPerformanceFromParse];
                [self unhideAllButtons];
                break;
            case indType:
                    arrayOfSectorPerformance = nil;
                    [self loadSectorsFromParse];
                [self unhideAllButtons];
                break;
            case trendType:
                arrayOfStockPerformance = nil;
                arrayOfStocks = nil;
                [self loadDataFromParse:0];
                [self loadTrendFromParse];
                break;
            case volType:
                arrayOfStockPerformance = nil;
                arrayOfStocks =nil;
                [self loadDataFromParse:0];
                [self loadVolFromParse];
                break;
            case trendVolType:
                arrayOfSectorPerformance = nil;
                arrayOfStocks = nil;
                [self loadDataFromParse:0];
                [self loadVolTrendFromParse];
                break;
            default:
                break;
        }
        [self loadDateFromParse];
    } // end okToLoad
}


#pragma mark -

#pragma mark Days Buttons Methods

-(void)hideAllButtons{
    
    [self.oneD setHidden:YES];
    [self.twoD setHidden:YES];
    [self.fiveD setHidden:YES];
    [self.tenD setHidden:YES];
    [self.twentyD setHidden:YES];
    [self.onetwentyD setHidden:YES];
    [self.twosixtyD setHidden:YES];
}

-(void)unhideAllButtons {
    
    [self.oneD setHidden:NO];
    [self.twoD setHidden:NO];
    [self.fiveD setHidden:NO];
    [self.tenD setHidden:NO];
    [self.twentyD setHidden:NO];
    [self.onetwentyD setHidden:NO];
    [self.twosixtyD setHidden:NO];
}

-(void)disableAllButtons{
    okToLoad = NO;
    [self.oneD setEnabled:NO];
    [self.twoD setEnabled:NO];
    [self.fiveD setEnabled:NO];
    [self.tenD setEnabled:NO];
    [self.twentyD setEnabled:NO];
    [self.onetwentyD setEnabled:NO];
    [self.twosixtyD setEnabled:NO];
}

-(void)enableAllButtons{
    
    [self.oneD setEnabled:YES];
    [self.twoD setEnabled:YES];
    [self.fiveD setEnabled:YES];
    [self.tenD setEnabled:YES];
    [self.twentyD setEnabled:YES];
    [self.onetwentyD setEnabled:YES];
    [self.twosixtyD setEnabled:YES];
}

-(IBAction)press1D:(id)sender
{
    [self disableAllButtons];
    numberOfDays = @"D";
    navItem.title =@"1 Day";
    
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }
}
-(IBAction)press2D:(id)sender
{
    [self disableAllButtons];
    numberOfDays =@"Parse_2D";
    navItem.title =@"2 Days";
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }
}
-(IBAction)press5D:(id)sender
{
    [self disableAllButtons];
    numberOfDays = @"Parse_5D";
    navItem.title =@"1 Week";
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }

}
-(IBAction)press10D:(id)sender
{
    [self disableAllButtons];
    numberOfDays = @"Parse_10D";
    navItem.title =@"2 Weeks";
    
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }

}
-(IBAction)press20D:(id)sender
{
    [self disableAllButtons];
    numberOfDays = @"Parse_20D";
    navItem.title =@"1 Month";
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }

}
-(IBAction)press120D:(id)sender
{
    [self disableAllButtons];
    numberOfDays = @"Parse_120D";
    navItem.title =@"6 Months";
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }

}
-(IBAction)press260D:(id)sender
{
    [self disableAllButtons];
    numberOfDays = @"Parse_260D";
    navItem.title =@"1 Year";
    if (sectorTable) {
        arrayOfSectorPerformance = nil;
        [self loadSectorsFromParse];
    } else {
        arrayOfStockPerformance = nil;
        [self loadPerformanceFromParse];
    }
}

@end
