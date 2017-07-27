//
//  InicioSesionViewController.m
//  Prix
//
//  Created by Christian Fernandez on 18/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "InicioSesionViewController.h"
#import "RequestUrl.h"
#import "utilidades.h"
#import "Globales.h"
#import "RegistroViewController.h"
#import "NuevaContrasenaViewController.h"
#import "CerrarSesionViewController.h"
#import "InicioSesionViewController.h"

@interface InicioSesionViewController (){
    BOOL loginFacebook;
}

@end

@implementation InicioSesionViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //Google SignIn
    
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"login"] isEqualToString:@"YES"]) {
        [self pasarInicioDos];
    }
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)configurerView{
    [self.btnFace.layer setCornerRadius:15.0];
    [self.btnGoogle.layer setCornerRadius:15.0];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.bottonInisiarSesion.constant = 35;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.bottonInisiarSesion.constant = 75;
        self.topImage.constant = 300;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.bottonInisiarSesion.constant = 100;
        self.bottomCajaCorreo.constant = 30;
        self.topImage.constant = 300;
        [self.lblRegister setTitle:@"             Registrase" forState:UIControlStateNormal];
    }
    [self.view layoutIfNeeded];
}

#pragma mark Own Methods

-(void)pasarInicioDos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"YES" forKey:@"login"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)pasarInicio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"YES" forKey:@"login"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pasarRecuperarContrasena{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     NuevaContrasenaViewController *inicioJuegoViewController = [story instantiateViewControllerWithIdentifier:@"NuevaContrasenaViewController"];
     [self.navigationController pushViewController:inicioJuegoViewController animated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtCorreo isEqual:textField]) {
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
        [self.view endEditing:TRUE];
        if (self.view.frame.origin.y != 0) {
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 
                             }
             ];
        }
    }
    return true;
}

#pragma mark Metodos IBActions

-(IBAction)loginCuenta:(id)sender{
    [self.view endEditing:YES];
    if ([utilidades verifyEmpty:self.view]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vació" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if([utilidades validateEmailWithString:self.txtCorreo.text]){
            self.tipo = @"3";
            [self requestServerLogin];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica el campo correo sea valido" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }
}

-(IBAction)loginButtonClickedFaceBook:(id)sender
{
    [self.view endEditing:YES];
    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){}];
    [self mostrarCargando];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends", @"user_birthday"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
             [msgDict setValue:@"Atención" forKey:@"Title"];
             [msgDict setValue:[error localizedDescription] forKey:@"Message"];
             [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
             [msgDict setValue:@"" forKey:@"Cancel"];
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                 waitUntilDone:YES];
             [self mostrarCargando];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
             [msgDict setValue:@"Atención" forKey:@"Title"];
             [msgDict setValue:@"Cancelled" forKey:@"Message"];
             [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
             [msgDict setValue:@"" forKey:@"Aceptar"];
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                 waitUntilDone:YES];
             [self mostrarCargando];
         } else {
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,first_name,email,last_name,birthday,gender" forKey:@"fields"];
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error) {
                      NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
                      
                      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                      dispatch_async(queue, ^{
                          dispatch_sync(dispatch_get_main_queue(), ^{
                              if (![result objectForKey:@"first_name"]) {
                                  [_defaults setObject:@"-" forKey:@"nombre"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"first_name"] forKey:@"nombre"];
                              }
                              
                              [_defaults setObject:[result objectForKey:@"id"] forKey:@"id"];
                              
                              if (![result objectForKey:@"last_name"]) {
                                  [_defaults setObject:@"-" forKey:@"apellido"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"last_name"] forKey:@"apellido"];
                              }
                              
                              if (![result objectForKey:@"email"]) {
                                  [_defaults setObject:@"-" forKey:@"email"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"email"] forKey:@"email"];
                              }
                              
                              
                              if (![result objectForKey:@"gender"]) {
                                  //[_defaults setObject:@"-" forKey:@"genero"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"gender"] forKey:@"genero"];
                              }
                              
                              
                              if (![result objectForKey:@"birthday"]) {
                                  [_defaults setObject:@"-" forKey:@"cumpleaños"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"birthday"] forKey:@"cumpleaños"];
                              }
                              loginFacebook = YES;
                              self.tipo = @"2";
                              [self requestServerLogin];
                          });
                      });
                  }
                  else{
                      NSLog(@"%@", [error localizedDescription]);
                  }
              }];
         }
     }];
}

- (IBAction)LoginGoogleButtonAction:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}

-(IBAction)registrarUsuario:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistroViewController *registroViewController = [story instantiateViewControllerWithIdentifier:@"RegistroViewController"];
    [self.navigationController pushViewController:registroViewController animated:YES];
}

#pragma mark - WebServices

#pragma mark - RequestServer Login

-(void)requestServerLogin{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        if ([self.tipo isEqualToString:@"3"]) {
            [self mostrarCargando];
        }
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerLogin) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerLogin{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    [data setObject:self.tipo forKey:@"tipo"];
    if ([self.tipo isEqualToString:@"3"]) {
        [data setObject:self.txtCorreo.text forKey:@"email"];
        [data setObject:self.txtContrasena.text forKey:@"password"];
    }else{
        [data setObject:[_defaults objectForKey:@"email"] forKey:@"email"];
        [data setObject:[_defaults objectForKey:@"id"] forKey:@"password"];
    }
    _data = [RequestUrl login:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoLogin) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoLogin{
    if ([_data count]>0) {
        NSMutableDictionary * temp = [_data objectForKey:@"AUTENTICAR_USUARIOResult"];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"1"]) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:self.tipo forKey:@"tipo"];
            [_defaults setObject:[temp objectForKey:@"IdCliente"] forKey:@"IdCliente"];
            [_defaults setObject:[temp objectForKey:@"apellido"] forKey:@"apellidos"];
            [_defaults setObject:[temp objectForKey:@"email"] forKey:@"email"];
            [_defaults setObject:[temp objectForKey:@"nombre"] forKey:@"nombre"];
            [_defaults setObject:_txtContrasena.text forKey:@"contrasena"];
            [_defaults setObject:@"12-01-1976" forKey:@"fecha_nacimiento"];
            if ([self.txtContrasena.text isEqualToString:@""]) {
                [_defaults setObject:@"0" forKey:@"contrasena"];
            }
            [self.txtContrasena setText:@""];
            [self.txtCorreo setText:@""];
            [self pasarInicio];
        }else if([codigo isEqualToString:@"5"]){
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:self.tipo forKey:@"tipo"];
            [_defaults setObject:[temp objectForKey:@"IdCliente"] forKey:@"IdCliente"];
            [_defaults setObject:[temp objectForKey:@"apellido"] forKey:@"apellidos"];
            [_defaults setObject:_txtCorreo.text forKey:@"email"];
            [_defaults setObject:[temp objectForKey:@"nombre"] forKey:@"nombre"];
            [_defaults setObject:_txtContrasena.text forKey:@"contrasena"];
            [_defaults setObject:@"12-01-1976" forKey:@"fecha_nacimiento"];
            if ([self.txtContrasena.text isEqualToString:@""]) {
                [_defaults setObject:@"0" forKey:@"contrasena"];
            }
            [self.txtContrasena setText:@""];
            [self.txtCorreo setText:@""];
            [self pasarRecuperarContrasena];
        }else{
            NSString * mensaje = @"Por favor verifica tu usuario o contraseña";
            if ([self.tipo isEqualToString:@"2"]) {
                mensaje = @"Por favor verifica que tu usuario fue creado por esta red social";
            }
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:mensaje forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intenta de nuevo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self.view endEditing:TRUE];
    [self mostrarCargando];
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
                                            [_defaults setObject:@"NO" forKey:@"login"];
                                            for (UIViewController *controller in self.navigationController.viewControllers) {
                                                
                                                //Do not forget to import AnOldViewController.h
                                                if ([controller isKindOfClass:[InicioSesionViewController class]]) {
                                                    
                                                    [self.navigationController popToViewController:controller
                                                                                          animated:YES];
                                                    break;
                                                }
                                            }
                                        }
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

#pragma mark - Google Singnin Request

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    if (error == nil) {
        NSString *userId = user.userID;                  // For client-side use only!
        //NSString *idToken = user.authentication.idToken; // Safe to send to the server
        //NSString *fullName = user.profile.name;
        //NSString *givenName = user.profile.givenName;
        //NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:email forKey:@"email"];
        [_defaults setObject:userId forKey:@"id"];
        self.tipo = @"2";
        [self requestServerLogin];
    }else{
        NSLog(@"%@", error.localizedDescription);
        [self mostrarCargando];
    }
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [self mostrarCargando];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Tab

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0)
    {
        // First Tab is selected do something
    }else if (tabBarController.selectedIndex == 1){
        NSLog(@"Prueba");
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[CerrarSesionViewController class]]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Cerrar Sesión" forKey:@"Title"];
        [msgDict setValue:@"Esta seguro que desea cerrar sesión" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        return NO;
    }
    return YES;
}

@end
