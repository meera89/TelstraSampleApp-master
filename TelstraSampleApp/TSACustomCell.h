//
//  CustomCell.h
//  TelstraSampleApp
//
//  Created by Meera on 9/2/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSAConstants.h"

@interface TSACustomCell : UITableViewCell
@property (nonatomic, strong) UILabel *descriptionTitle;
@property(nonatomic,strong) UIImageView *descriptionImage;
@property(nonatomic,strong) UILabel *descriptionText;
@property(nonatomic,strong) UIActivityIndicatorView *indicatorView;


@end
