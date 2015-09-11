//
//  Facts.m
//  TelstraSampleApp
//
//  Created by Cognizant on 9/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "TSAFacts.h"
#import "TSAFactDetails.h"

@implementation TSAFacts


+ (id)sharedManager {
    static TSAFacts *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
/*----------------------------------------------------------------------------------
 Method Name: insertFactsCollection
 Parameters: NSArray
 Descriptions:
 This method will insert the downloaded data into factsCollection
 return type: NSString
 ----------------------------------------------------------------------------------*/

-(void)insertFactsCollection:(NSArray *)parsedResponse
{
    NSMutableArray *detailArray=[[NSMutableArray alloc]init];
    self.factsCollection=[[NSMutableArray alloc]init];
    if([parsedResponse count]>0){
        
        NSArray *arr=[[NSArray alloc]initWithArray:[parsedResponse valueForKey:@"rows"]];
        
        for(NSDictionary *dict in arr){
            TSAFactDetails *factDetail=[[TSAFactDetails alloc]init];
            
            factDetail.factsTitle=[self checkNull:[dict objectForKey:@"title"]];
            factDetail.factsDescritpion=[self checkNull:[dict objectForKey:@"description"]];
            factDetail.factsImageUrl=[self checkNull:[dict objectForKey:@"imageHref"]];

            factDetail.factsDescriptionLblFont=[UIFont fontWithName:@"Helvetica" size:12.0f];
            [detailArray addObject:factDetail];
        }
    }
    
    self.factsCollection=[detailArray mutableCopy];
}
/*----------------------------------------------------------------------------------
 Method Name: setImageToCell
 Parameters: NSData,UIImageView,NSIndexPath
 Descriptions:
 This method will convert the data to image and will store it in imageCollection
 return type: NSString
 ----------------------------------------------------------------------------------*/
-(void)setImageToCell:(NSData *)data andUIImageView:(UIImageView *)imgLoad andKey:(NSIndexPath *)key
{
    UIImage *downloadedImage;

    if([data length]<1000){
        NSString *errorDetails = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        //check the errorDetails and set the respective placeholder image
        if([errorDetails isEqualToString:@"The request timed out."])
            
            downloadedImage=[UIImage imageNamed:@"placeholder_50"];
        
        else
            
            downloadedImage=[UIImage imageNamed:@"NoImage"];
    }
    else{
        downloadedImage = [[UIImage alloc] initWithData:data];
    }
    UIImageView *imageView=(UIImageView *)imgLoad;
    imageView.image=downloadedImage;
    TSAFactDetails *factDetails= [self.factsCollection objectAtIndex:key.row];
    factDetails.factsImage=nil;

    factDetails.factsImage=downloadedImage;

}

/*----------------------------------------------------------------------------------
 Method Name: checkNull
 Parameters: NSString
 Descriptions:
 This method is NULL check for the input string
 return type: NSString
 ----------------------------------------------------------------------------------*/
-(NSString*)checkNull:(NSString*)value
{
    if([value isEqual:[NSNull null]]||value==nil){
        value=@"";
    }
    return value;
}
@end
