//
//  CustomCell.m
//  TelstraSampleApp
//
//  Created by Meera on 9/2/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "TSACustomCell.h"



@implementation TSACustomCell
@synthesize descriptionTitle;
@synthesize descriptionImage;
@synthesize descriptionText;
@synthesize indicatorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //configure view
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)];
        
        // configure control(s)
        self.descriptionTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 300, kDescriptionTitleHeight)];
        self.descriptionTitle.textColor = [UIColor colorWithRed:66.0/255.0 green:41.0/255.0 blue:161.0/255.0 alpha:1.0];
        self.descriptionTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        
        //CGSize size = [self findMessgeStringHeight:content];

        self.descriptionImage=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-kImagePadding ,  self.descriptionTitle.frame.size.height+kDescriptionIndicatorHeight, kDescriptionImageHeight, kDescriptionImageHeight)];
        [self.contentView addSubview:self.descriptionImage];
        
        self.descriptionText=[[UILabel alloc] initWithFrame:CGRectMake(self.descriptionTitle.frame.origin.x, 20, [UIScreen mainScreen].bounds.size.width-(self.descriptionImage.frame.size.width+40), ktableViewCellPadding)];
        self.descriptionText.textColor = [UIColor blackColor];

        self.indicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-kImagePadding, self.descriptionTitle.frame.size.height+kDescriptionIndicatorHeight, kDescriptionIndicatorHeight, kDescriptionIndicatorHeight)];

        [self.indicatorView setHidden:YES];
        [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        [self.contentView addSubview:self.descriptionTitle];
        [self.contentView addSubview:self.descriptionText];
        [self.contentView addSubview:self.indicatorView];

    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGSize)findMessgeStringHeight :(NSString *)message
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:message attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12.0f] }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){225, MAXFLOAT}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize requiredSize = rect.size;
    
    return requiredSize; //finally u return your height
}

@end
