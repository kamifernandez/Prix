//
//  IngresarCodigoViewController.h
//  Prix
//
//  Created by Christian Fernandez on 23/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngresarCodigoViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTituloRecuperar;

@property (weak, nonatomic) IBOutlet UITextField *txtMail;

@property(nonatomic,strong)NSMutableDictionary *data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@property (weak, nonatomic) IBOutlet UIView * vistaCampoCorreo;

@end
