//
//  NuevaContrasenaViewController.m
//  Prix
//
//  Created by Christian Fernandez on 23/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "NuevaContrasenaViewController.h"
#import "RequestUrl.h"
#import "utilidades.h"
#import "CerrarSesionViewController.h"
#import "InicioSesionViewController.h"

@interface NuevaContrasenaViewController ()

@end

@implementation NuevaContrasenaViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.topTxtConfirmar.constant = 45;
        self.heigthImageSombra.constant = 220;
        self.heigthImageBottom.constant = 200;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topTxtConfirmar.constant = 70;
        self.heigthImage.constant = 260;
        self.heigthImageSombra.constant = 265;
        self.heigthImageBottom.constant = 210;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topTxtConfirmar.constant = 60;
        self.heigthImage.constant = 300;
        self.heigthImageSombra.constant = 250;
        self.heigthImageBottom.constant = 250;
    }
    [self.view layoutIfNeeded];
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    self.tipo = [_defaults objectForKey:@"tipo"];
    
    NSString *dateStr = [_defaults objectForKey:@"fecha_nacimiento"];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    self.date = [dateFormat stringFromDate:date];
    
    [self.btnEnviar.layer setCornerRadius:15.0];
    
}

-(void)pasarInicio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"YES" forKey:@"login"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark IBActions

-(IBAction)enviarNuevaContrasena:(id)sender{
    if ([utilidades verifyEmpty:self.vistaCampoCorreo]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vació" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([self.txtNueva.text isEqualToString:self.txtConfirmar.text]) {
            [self requestServerActualizarUsuario];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica que las contraseñas coincidan" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }
}

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             int subirVista = 0;
                             if ([[UIScreen mainScreen] bounds].size.height == 480) {
                                 subirVista = -120;
                             }else if([[UIScreen mainScreen] bounds].size.height == 568){
                                 subirVista = -90;
                             }else if([[UIScreen mainScreen] bounds].size.height == 667){
                                 subirVista = -65;
                             }else{
                                 //subirVista = -300;
                             }
                             
                             [self.view setFrame:CGRectMake(0, subirVista, self.view.frame.size.width, self.view.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtNueva isEqual:textField]) {
        [_txtConfirmar becomeFirstResponder];
    }else if ([_txtConfirmar isEqual:textField]){
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

#pragma mark - WebServices

#pragma mark - RequestServer Registro

-(void)requestServerActualizarUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerActualizarUsuario) object:nil];
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


-(void)envioServerActualizarUsuario{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    
    [data setObject:[_defaults objectForKey:@"email"] forKey:@"email"];
    [data setObject:_txtNueva.text forKey:@"contrasena"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    
    [data setObject:@"ACTUALIZAR_CONTRASENA/" forKey:@"metodo"];
    
    _data = [RequestUrl actualizarContrasena:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoActualizarUsuario) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoActualizarUsuario{
    if ([_data count]>0) {
        NSMutableDictionary * temp = [_data objectForKey:@"ACTUALIZAR_CONTRASENAResult"];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"1"]) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[temp objectForKey:@"IdCliente"] forKey:@"IdCliente"];
            [_defaults setObject:[_defaults objectForKey:@"nombre"] forKey:@"nombre"];
            [_defaults setObject:[_defaults objectForKey:@"apellidos"] forKey:@"apellidos"];
            if ([self.tipo isEqualToString:@"3"]) {
                [_defaults setObject:self.txtNueva.text forKey:@"contrasena"];
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
