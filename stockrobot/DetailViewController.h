//
//  DetailViewController.h
//  stockrobot
//
//  Created by BMM on 13/3/2.
//  Copyright (c) 2013年 BMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
