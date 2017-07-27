//
//  RegistroViewController.m
//  Prix
//
//  Created by Christian Fernandez on 19/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "RegistroViewController.h"
#import "utilidades.h"
#import "RequestUrl.h"
#import "Globales.h"
#import "InicioViewController.h"
#import "InicioSesionViewController.h"
#import "CerrarSesionViewController.h"

@interface RegistroViewController ()

@end

@implementation RegistroViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    [self.btnFace.layer setCornerRadius:15.0];
    [self.btnGoogle.layer setCornerRadius:15.0];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.topPrimeraCajaTexto.constant = 55;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topPrimeraCajaTexto.constant = 115;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topPrimeraCajaTexto.constant = 105;
    }
    [self.view layoutIfNeeded];
    
    UIColor *color = [UIColor whiteColor];
    self.txtNombres.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nombres" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtApellidos.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Apellidos" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtFechaNacimiento.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Fecha de Nacimiento" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtConfirmarCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirmar Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    //Google SignIn
    
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
}

#pragma mark Own Methods

-(void)pasarInicio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"YES" forKey:@"login"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Metodos IBActions

-(IBAction)validarCampos:(id)sender{
    if ([self.txtNombres.text isEqualToString:@""] || [self.txtApellidos.text isEqualToString:@""] || [self.txtCorreo.text isEqualToString:@""] || [self.txtFechaNacimiento.text isEqualToString:@""] || [self.txtConfirmarCorreo.text isEqualToString:@""] || [self.txtContrasena.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtCorreo.text]){
            
            if (![self.txtCorreo.text isEqualToString:self.txtConfirmarCorreo.text]) {
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Por favor verifica que los campos de correo coincidan" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"" forKey:@"Cancel"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            }else{
                self.tipo = @"3";
                [self requestServerRegistro];
            }
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
                              self.tipo = @"2";
                              [self requestServerRegistro];
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

-(IBAction)btnFechaNacimiento:(id)sender{
    [self.view endEditing:TRUE];
    [[NSBundle mainBundle] loadNibNamed:@"VistaFechaNacimiento" owner:self options:nil];
    [self.vistaPicker setAlpha:0.0];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [letterTapRecognizer setNumberOfTapsRequired:1];
    [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
    [self.vistaPicker setFrame:self.view.bounds];
    [self.view addSubview:self.vistaPicker];
    [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 194, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaPicker setAlpha:1.0];
    }completion:^(BOOL finished){

    }];
}

-(IBAction)selectPikcerButton:(id)sender{
    if (sender != nil) {
        NSDate *date = _pickerView.date;
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [dateFormat stringFromDate:date];
        
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        
        _txtFechaNacimiento.text = [dateFormat stringFromDate:date];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.vistaContentPicker.frame.size.width, self.vistaContentPicker.frame.size.height)];
    }completion:^(BOOL finished){
        [self.vistaPicker removeFromSuperview];
        self.vistaPicker = nil;
    }];
}

- (IBAction)LoginGoogleButtonAction:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtNombres isEqual:textField]) {
        [_txtApellidos becomeFirstResponder];
    }else if ([_txtApellidos isEqual:textField]){
        //[_txtCorreo becomeFirstResponder];
        [self.view endEditing:true];
    }else if ([_txtCorreo isEqual:textField]){
        [_txtConfirmarCorreo becomeFirstResponder];
    }else if ([_txtConfirmarCorreo isEqual:textField]){
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scroll.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, _tViewSeleccionado.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = _tViewSeleccionado.frame.origin.y-100;
        }else{
            tamano = _tViewSeleccionado.frame.origin.y-130;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        [_scroll setContentOffset:scrollPoint animated:YES];
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _scroll.contentInset = contentInsets;
         _scroll.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
}

#pragma mark - WebServices

#pragma mark - RequestServer Registro

-(void)requestServerRegistro{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        if ([self.tipo isEqualToString:@"3"]) {
            [self mostrarCargando];
        }
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerRegistro) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerRegistro{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([self.tipo isEqualToString:@"3"]) {
        [data setObject:self.date forKey:@"fecha"];
        [data setObject:@"REGISTRO_USUARIOS/" forKey:@"metodo"];
        [data setObject:self.txtNombres.text forKey:@"nombre"];
        [data setObject:self.txtApellidos.text forKey:@"apellidos"];
        [data setObject:self.txtCorreo.text forKey:@"correo"];
        [data setObject:self.txtContrasena.text forKey:@"contrasena"];
    }else{
        [data setObject:@"-" forKey:@"fecha"];
        [data setObject:@"REGISTRO_USUARIOS_RS/" forKey:@"metodo"];
        [data setObject:[_defaults objectForKey:@"nombre"] forKey:@"nombre"];
        [data setObject:[_defaults objectForKey:@"apellido"] forKey:@"apellidos"];
        [data setObject:[_defaults objectForKey:@"email"] forKey:@"correo"];
        [data setObject:[_defaults objectForKey:@"id"] forKey:@"red"];
    }
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    
    _data = [RequestUrl crearUsuario:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoRegistro) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoRegistro{
    if ([_data count]>0) {
        NSString * keyLogin = @"REGISTRO_USUARIOSResult";
        if ([self.tipo isEqualToString:@"2"]) {
            keyLogin = @"REGISTRO_USUARIOS_RSResult";
        }
        NSMutableDictionary * temp = [_data objectForKey:keyLogin];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"0"]) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[temp objectForKey:@"IdCliente"] forKey:@"IdCliente"];
            [_defaults setObject:self.tipo forKey:@"tipo"];
            if ([self.tipo isEqualToString:@"3"]) {
                [_defaults setObject:self.txtNombres.text forKey:@"nombre"];
                [_defaults setObject:self.txtApellidos.text forKey:@"apellidos"];
                [_defaults setObject:self.txtCorreo.text forKey:@"email"];
                [_defaults setObject:self.txtContrasena.text forKey:@"contrasena"];
                [_defaults setObject:self.txtFechaNacimiento.text forKey:@"fecha_nacimiento"];
            }else{
                [_defaults setObject:@"" forKey:@"contrasena"];
                [_defaults setObject:[_defaults objectForKey:@"nombre"] forKey:@"nombre"];
                [_defaults setObject:[_defaults objectForKey:@"apellido"] forKey:@"apellidos"];
                [_defaults setObject:[_defaults objectForKey:@"email"] forKey:@"email"];
                [_defaults setObject:[_defaults objectForKey:@"cumpleaños"] forKey:@"fecha_nacimiento"];
            }
            NSString * mensaje = [temp objectForKey:@"MensajeRespuesta"];
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:mensaje forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"100" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else if([codigo isEqualToString:@"1"]){
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[temp objectForKey:@"IdCliente"] forKey:@"IdCliente"];
            [_defaults setObject:self.tipo forKey:@"tipo"];
            if ([self.tipo isEqualToString:@"3"]) {
                [_defaults setObject:self.txtContrasena.text forKey:@"contrasena"];
                [_defaults setObject:self.txtNombres.text forKey:@"nombre"];
                [_defaults setObject:self.txtApellidos.text forKey:@"apellidos"];
                [_defaults setObject:self.txtCorreo.text forKey:@"email"];
            }else{
                [_defaults setObject:@"0" forKey:@"contrasena"];
                [_defaults setObject:[_defaults objectForKey:@"nombre"] forKey:@"nombre"];
                [_defaults setObject:[_defaults objectForKey:@"apellido"] forKey:@"apellidos"];
                [_defaults setObject:[_defaults objectForKey:@"email"] forKey:@"email"];
            }
            [self requestServerToken];
            NSString * mensaje = [temp objectForKey:@"MensajeRespuesta"];
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:mensaje forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
            //[self pasarInicio];
        }else{
            NSString * mensaje = [temp objectForKey:@"MensajeRespuesta"];
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
    [self mostrarCargando];
}

#pragma mark - WebServices

#pragma mark - RequestServer Token

-(void)requestServerToken{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerToken) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerToken{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    [data setObject:[_defaults objectForKey:@"token"] forKey:@"token"];
    _data = [RequestUrl registrarToken:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoToken) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoToken{
    if ([_data count]>0) {
        NSMutableDictionary * temp = [_data objectForKey:@"REGISTAR_DISPOSITIVOSResult"];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"1"]) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:@"YES" forKey:@"registrotoken"];
        }else{
            [self requestServerToken];
        }
    }else{
        //[self requestServerToken];
    }
}

#pragma mark Gesture Recognizer

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    [self selectPikcerButton:nil];
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"100"]) {
                                            [self pasarInicio];
                                        }else if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
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
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        //NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:userId forKey:@"id"];
        [_defaults setObject:email forKey:@"email"];
        [_defaults setObject:fullName forKey:@"nombre"];
        [_defaults setObject:givenName forKey:@"apellidos"];
        self.tipo = @"2";
        [self requestServerRegistro];
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
