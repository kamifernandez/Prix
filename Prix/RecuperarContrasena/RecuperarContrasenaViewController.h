//
//  RecuperarContrasenaViewController.h
//  Prix
//
//  Created by Christian Fernandez on 20/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecuperarContrasenaViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthImageCorreo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthBottomImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTitulo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTituloRecuperar;

@property (weak, nonatomic) IBOutlet UILabel * lblTituloDescripcion;

@property (weak, nonatomic) IBOutlet UIButton * btnEnviarContrasena;

@property (weak, nonatomic) IBOutlet UITextField * txtMail;

@property (weak, nonatomic) IBOutlet UIView * vistaCampoCorreo;

@property(nonatomic,strong)NSMutableDictionary * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
