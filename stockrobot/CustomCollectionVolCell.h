//
//  CustomCollectionVolCell.h
//  stockrobot
//
//  Created by BMM on 13/3/6.
//  Copyright (c) 2013年 BMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionVolCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *industry;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *returns;

@end
