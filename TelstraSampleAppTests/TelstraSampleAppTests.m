//
//  TelstraSampleAppTests.m
//  TelstraSampleAppTests
//
//  Created by Meera on 9/2/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "TSAConstants.h"
@interface TelstraSampleAppTests : XCTestCase{
    ViewController *testClassObj;
}

@end

@implementation TelstraSampleAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testClassObj=[[ViewController alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
/* testCheckNull performs check if the input is Null.
 * The test has two parts:
 * 1. Through the input: method, feed the function with a Null value 
 * 2. Confirm that displayValue is @"".
 */
- (void) testCheckNull {
   
}
/* testDownloadedResponseArray performs the array is valid and assigns values to the DetailArray.
 * The test has two parts:
 * 1. Through the input: method, feed the function with a sample parseResponse
 * 2. Confirm that the DetailArray contains values .
 */
-(void)testDownloadedResponseArray
{
    NSDictionary *parsedResponse=[self returnResponseArray];
    NSMutableArray *detailArray=[[NSMutableArray alloc]init];

    if([parsedResponse count]>0)
    {
    
    NSArray *arr=[[NSArray alloc]initWithArray:[parsedResponse valueForKey:@"rows"]];
    
    for(NSDictionary *dict in arr){
        
        if(![[self checkNull:[dict objectForKey:@"title"]]isEqualToString:@""]|| ![[self checkNull:[dict objectForKey:@"description"]]isEqualToString:@""] || ![[self checkNull:[dict objectForKey:@"imageHref"]]isEqualToString:@""]){
            [detailArray addObject:dict];
            }
    
        }
    }
    XCTAssertTrue(detailArray.count >0);

}
-(NSDictionary *)returnResponseArray
{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"Hello" forKey:@"description"];
    [dict setValue:@"Title" forKey:@"title"];
    [dict setValue:@"" forKey:@"imageHref"];
    NSArray *rowArray=[[NSArray alloc]initWithObjects:dict, nil];
    NSMutableDictionary *reponseDict=[[NSMutableDictionary alloc]init];
    [reponseDict setValue:rowArray forKey:@"rows"];
    return [reponseDict mutableCopy];
    

    
}
-(NSString*)checkNull:(NSString*)value
{
    if([value isEqual:[NSNull null]]){
        value=@"";
    }
    return value;
}
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
