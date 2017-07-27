//
//  InicioSesionViewController.h
//  Prix
//
//  Created by Christian Fernandez on 18/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface InicioSesionViewController : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate,UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonInisiarSesion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCajaCorreo;

@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;
@property(nonatomic,weak)IBOutlet UITextField * txtContrasena;

@property(nonatomic,weak)IBOutlet UIButton * lblRegister;

@property(nonatomic,weak)IBOutlet UIButton * btnFace;
@property(nonatomic,weak)IBOutlet UIButton * btnGoogle;

@property(nonatomic,strong)NSMutableDictionary *data;

@property(nonatomic,strong)NSString *tipo;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

//GoogleSigIn

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end
