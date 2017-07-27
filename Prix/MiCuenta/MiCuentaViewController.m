//
//  MiCuentaViewController.m
//  Prix
//
//  Created by Christian Fernandez on 23/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MiCuentaViewController.h"
#import "utilidades.h"
#import "RequestUrl.h"
#import "Globales.h"
#import "AcumulacionComercioViewController.h"
#import "RedencionPuntosViewController.h"

@interface MiCuentaViewController ()

@end

@implementation MiCuentaViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"2" forKey:@"tabitem"];
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestServerDetalleComercio)
                                                 name:@"puntosComercioCuenta"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestServerRedencionComercio)
                                                 name:@"puntosComercioRedencionCuenta"
                                               object:nil];
    
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    [self.btnActualizar.layer setCornerRadius:15.0];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.topPrimeraCajaTexto.constant = 150;
        self.heigthImageFoto.constant = 400;
        self.topPrimeraCajaTexto.constant = 105;
        self.heigthBottomImage.constant = 200;
        self.bottomBottomActualizar.constant = 40;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topPrimeraCajaTexto.constant = 150;
        self.heigthImageFoto.constant = 480;
        self.topPrimeraCajaTexto.constant = 160;
        self.heigthBottomImage.constant = 200;
        self.bottomBottomActualizar.constant = 60;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topPrimeraCajaTexto.constant = 280;
        self.heigthImageFoto.constant = 560;
        self.topPrimeraCajaTexto.constant = 180;
        self.heigthBottomImage.constant = 250;
        self.bottomBottomActualizar.constant = 60;
    }
    [self.view layoutIfNeeded];
    
    UIColor *color = [UIColor whiteColor];
    self.txtNombres.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nombres" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtApellidos.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Apellidos" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtFechaNacimiento.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Fecha de Nacimiento" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    self.tipo = [_defaults objectForKey:@"tipo"];
    
    self.txtNombres.text = [_defaults objectForKey:@"nombre"];
    self.txtApellidos.text = [_defaults objectForKey:@"apellidos"];
    self.txtContrasena.text = [_defaults objectForKey:@"contrasena"];
    self.txtFechaNacimiento.text = [_defaults objectForKey:@"fecha_nacimiento"];
    
    NSString *dateStr = [_defaults objectForKey:@"fecha_nacimiento"];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    self.date = [dateFormat stringFromDate:date];
    
    if([self.tipo isEqualToString:@"2"]){
        self.txtContrasena.text = @"";
        [self.txtContrasena setEnabled:FALSE];
    }
}

#pragma mark Metodos IBActions

-(IBAction)btnFechaNacimiento:(id)sender{
    [self.view endEditing:TRUE];
    [[NSBundle mainBundle] loadNibNamed:@"VistaFechaNacimiento" owner:self options:nil];
    [self.vistaPicker setAlpha:0.0];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [letterTapRecognizer setNumberOfTapsRequired:1];
    [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
    [self.vistaPicker setFrame:self.view.bounds];
    //[self.view addSubview:self.vistaPicker];
    [self.tabBarController.view addSubview:self.vistaPicker];
    [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 194, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaPicker setAlpha:1.0];
    }completion:^(BOOL finished){
        
    }];
}

-(IBAction)actualizarCuenta:(id)sender{
    if ([utilidades verifyEmpty:self.view]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vació" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        [self requestServerActualizarUsuario];
    }
}

-(IBAction)selectPikcerButton:(id)sender{
    if (sender != nil) {
        NSDate *date = _pickerView.date;
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
        
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        
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

#pragma mark Gesture Recognizer

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    [self selectPikcerButton:nil];
}

#pragma mark - WebServices

#pragma mark - RequestServer Registro

-(void)requestServerActualizarUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([self.txtNombres.text isEqualToString:[_defaults objectForKey:@"nombre"]] && [self.txtApellidos.text isEqualToString:[_defaults objectForKey:@"apellidos"]] && [self.txtContrasena.text isEqualToString:[_defaults objectForKey:@"contrasena"]] && [self.txtFechaNacimiento.text isEqualToString:[_defaults objectForKey:@"fecha_nacimiento"]]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor asegurate de cambiar al menos un dato para actualizar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
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
}

-(void)envioServerActualizarUsuario{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [data setObject:self.date forKey:@"fecha"];
    
    [data setObject:self.txtNombres.text forKey:@"nombre"];
    [data setObject:self.txtApellidos.text forKey:@"apellidos"];
    [data setObject:[_defaults objectForKey:@"email"] forKey:@"correo"];
    [data setObject:self.date forKey:@"fecha"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    if ([self.tipo isEqualToString:@"3"]) {
        [data setObject:@"ACTUALIZAR_DATOS/" forKey:@"metodo"];
        [data setObject:self.txtContrasena.text forKey:@"contrasena"];
    }else{
        [data setObject:@"ACTUALIZAR_DATOS_RS/" forKey:@"metodo"];
    }
    
    _data = [RequestUrl actualizarUsuario:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoActualizarUsuario) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoActualizarUsuario{
    if ([_data count]>0) {
        NSMutableDictionary * temp = nil;
        if ([self.tipo isEqualToString:@"3"]) {
            temp = [_data objectForKey:@"ACTUALIZAR_DATOSResult"];
        }else{
            [_data objectForKey:@"ACTUALIZAR_DATOS_RSResult"];
        }
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"1"]) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[temp objectForKey:@"IdCliente"] forKey:@"IdCliente"];
            [_defaults setObject:self.txtNombres.text forKey:@"nombre"];
            [_defaults setObject:self.txtApellidos.text forKey:@"apellidos"];
            [_defaults setObject:self.txtFechaNacimiento.text forKey:@"fecha_nacimiento"];
            if ([self.tipo isEqualToString:@"3"]) {
                [_defaults setObject:self.txtContrasena.text forKey:@"contrasena"];
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

#pragma mark - Metodos PushNotification

#pragma mark - RequestServer Detalle Comercio

-(void)requestServerDetalleComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerDetalleComercio) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        //[msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerDetalleComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    
    //[data setObject:[[self.dataComercio objectAtIndex:tagCategoria] objectForKey:@"idCormercio"] forKey:@"idCormercio"];
    
    [data setObject:@"1" forKey:@"idCormercio"];
    
    NSMutableDictionary * temp = [RequestUrl detalleComercio:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoDetalleComercio:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoDetalleComercio:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataDetalleCategorias = [[data objectForKey:@"DETALLE_COMERCIOResult"] copy];
        if ([self.dataDetalleCategorias count]>0) {
            NSLog(@"%@",[[self.dataDetalleCategorias objectAtIndex:0] objectForKey:@"imagen"]);
            [self pasarDetalleComercio];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"No hay detalle para mostrar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"0" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No hay categorias para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"0" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

-(void)pasarDetalleComercio{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AcumulacionComercioViewController *acumulacionComercioViewController = [story instantiateViewControllerWithIdentifier:@"AcumulacionComercioViewController"];
    acumulacionComercioViewController.data = self.dataDetalleCategorias;
    [self.navigationController pushViewController:acumulacionComercioViewController animated:YES];
}

#pragma mark - RequestServer Redención putnos Comercio

-(void)requestServerRedencionComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerRedencionComercio) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        //[msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerRedencionComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    
    //[data setObject:[[self.dataComercio objectAtIndex:tagCategoria] objectForKey:@"idCormercio"] forKey:@"idCormercio"];
    
    [data setObject:@"1" forKey:@"idCormercio"];
    
    NSMutableDictionary * temp = [RequestUrl detalleComercio:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoRedencionComercio:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoRedencionComercio:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataDetalleCategorias = [[data objectForKey:@"DETALLE_COMERCIOResult"] copy];
        if ([self.dataDetalleCategorias count]>0) {
            NSLog(@"%@",[[self.dataDetalleCategorias objectAtIndex:0] objectForKey:@"imagen"]);
            [self pasarRedencionPuntos];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"No hay detalle para mostrar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"0" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No hay categorias para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"0" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

-(void)pasarRedencionPuntos{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RedencionPuntosViewController *redencionPuntosViewController = [story instantiateViewControllerWithIdentifier:@"redencionPuntosViewController"];
    redencionPuntosViewController.data = self.dataDetalleCategorias;
    [self.navigationController pushViewController:redencionPuntosViewController animated:YES];
}

@end
