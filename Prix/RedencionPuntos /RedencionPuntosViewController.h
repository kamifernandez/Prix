//
//  RedencionPuntosViewController.h
//  Prix
//
//  Created by Christian Fernandez on 27/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+MD5.h"
#import "FTWCache.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface RedencionPuntosViewController : UIViewController

@property(nonatomic,weak)IBOutlet UICollectionView * collection;

@property(nonatomic,weak)IBOutlet UIPageControl * pageCollection;

@property(nonatomic,weak)IBOutlet UIScrollView * scroll;

@property(nonatomic,weak)IBOutlet UIView * viewBack;

@property (weak, nonatomic) IBOutlet UIProgressView * progressView;

@property(nonatomic,weak)IBOutlet UITextView *txvComents;
@property(nonatomic,weak)IBOutlet UILabel * lblNombreUsuario;

@property(nonatomic,weak)IBOutlet UILabel * lblPuntosFaltantes;

@property(nonatomic,weak)IBOutlet UILabel * lblPuntos;

@property(nonatomic,weak)IBOutlet UILabel * lblTitulos;

@property(nonnull,strong)NSMutableArray * data;

@property(nonatomic,weak)IBOutlet UIButton * btnFavoritos;

@property(nonatomic,weak)IBOutlet UIView * vistaCollection;

// Estrellas

@property(nonatomic,weak)IBOutlet UIImageView * imgFirstStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgSecondtStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgthirdtStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgFourStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgFiveStar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeigthView;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
