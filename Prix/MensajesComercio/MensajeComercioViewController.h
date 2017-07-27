//
//  MensajeComercioViewController.h
//  Prix
//
//  Created by Christian Fernandez on 27/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "NSString+MD5.h"
#import "FTWCache.h"

@interface MensajeComercioViewController : UIViewController{
    int tagFavoritos;
}

@property(nonatomic,weak)IBOutlet UICollectionView * collection;

@property(nonatomic,weak)IBOutlet UIPageControl * pageCollection;

@property(nonatomic,weak)IBOutlet UITextView *txvComents;
@property(nonatomic,weak)IBOutlet UILabel * lblNombreUsuario;

@property(nonatomic,weak)IBOutlet UILabel * lblPuntosFaltantes;

@property(nonatomic,weak)IBOutlet UILabel * lblPuntos;

@property(nonatomic,weak)IBOutlet UILabel * lblTitulos;

@property(nonatomic,weak)IBOutlet UIButton * btnFavoritos;

@property(nonatomic,strong)NSMutableArray * dataDetalleCategorias;

@property(nonatomic,strong)NSMutableArray * fotos;

@property (weak, nonatomic) IBOutlet UIProgressView * progressView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeigthView;

@property(nonatomic,weak)IBOutlet UIView * vistaCollection;

// Estrellas

@property(nonatomic,weak)IBOutlet UIImageView * imgFirstStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgSecondtStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgthirdtStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgFourStar;
@property(nonatomic,weak)IBOutlet UIImageView * imgFiveStar;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
