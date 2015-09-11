//
//  Facts.h
//  TelstraSampleApp
//
//  Created by Cognizant on 9/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSAFacts : NSObject



@property(nonatomic,strong)NSMutableArray *factsCollection;


+ (id)sharedManager ;
-(void)insertFactsCollection:(NSArray *)parsedResponse;
-(void)setImageToCell:(NSData *)data andUIImageView:(UIImageView *)imgLoad andKey:(NSIndexPath *)key;
@end
