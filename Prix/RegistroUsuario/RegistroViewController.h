//
//  RegistroViewController.h
//  Prix
//
//  Created by Christian Fernandez on 19/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>


@interface RegistroViewController : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate,UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic,weak)IBOutlet UIView * viewContentScroll;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPrimeraCajaTexto;

@property(nonatomic,weak)IBOutlet UITextField * txtNombres;
@property(nonatomic,weak)IBOutlet UITextField * txtApellidos;
@property(nonatomic,weak)IBOutlet UITextField * txtFechaNacimiento;
@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;
@property(nonatomic,weak)IBOutlet UITextField * txtConfirmarCorreo;
@property(nonatomic,weak)IBOutlet UITextField * txtContrasena;

@property(nonatomic,weak)IBOutlet UIButton * btnFace;

@property(nonatomic,weak)IBOutlet UIButton * btnGoogle;

@property(nonatomic,strong)NSMutableDictionary * data;

@property(nonatomic,strong)NSString *tipo;

@property(nonatomic,strong)NSString *date;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

//View Picker

@property(nonatomic,weak)IBOutlet UIView * vistaPicker;
@property(nonatomic,weak)IBOutlet UIView * vistaContentPicker;

@property(nonatomic,weak)IBOutlet UIDatePicker * pickerView;

@end
