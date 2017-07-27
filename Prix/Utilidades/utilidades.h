//
//  utilidades.h
//  emi
//
//  Created by KUBO on 4/17/15.
//  Copyright (c) 2015 KUBO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface utilidades : NSObject

+(BOOL)consultarGpsActivo;

+ (BOOL)validateEmailWithString:(NSString*)checkString;

+(BOOL)verifyEmpty:(UIView *)viewSend;

+(NSString *)decimalNumberFormat:(int)decimalNumber;

+ (UIImage *) scaleAndRotateImage: (UIImage *)image;

+ (NSAttributedString*)attributedHTMLString:(NSString *)string useFont:(UIFont*)font1 useHexColor:(NSString*)color;

@end
