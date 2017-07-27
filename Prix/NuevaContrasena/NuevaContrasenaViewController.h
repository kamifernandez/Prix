//
//  NuevaContrasenaViewController.h
//  Prix
//
//  Created by Christian Fernandez on 23/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NuevaContrasenaViewController : UIViewController<UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTxtConfirmar;

@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *tipo;

@property(nonatomic,strong)NSMutableDictionary * data;

@property (weak, nonatomic) IBOutlet UIButton *btnEnviar;

@property (weak, nonatomic) IBOutlet UITextField *txtNueva;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmar;

@property (weak, nonatomic) IBOutlet UIView * vistaCampoCorreo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthImageSombra;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthImageBottom;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
