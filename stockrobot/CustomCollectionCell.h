//
//  CustomCollectionCell.h
//  stockrobot
//
//  Created by BMM on 13/3/3.
//  Copyright (c) 2013年 BMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *industryIcon;
@property (weak, nonatomic) IBOutlet UILabel *industry;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *returns;
@property (weak, nonatomic) IBOutlet UILabel *ratio;

@end
