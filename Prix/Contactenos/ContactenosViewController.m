//
//  ContactenosViewController.m
//  Prix
//
//  Created by Christian Fernandez on 30/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ContactenosViewController.h"
#import "RequestUrl.h"

@interface ContactenosViewController ()

@end

@implementation ContactenosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    [self.btnEnviar.layer setCornerRadius:15.0];
    
    //[self.txtComentario.layer setBorderWidth:1.0];
    //[self.txtComentario.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.topPrimeraCajaTexto.constant = 35;
        self.heigthCampoComentario.constant = 100;
        self.bottomBottomActualizar.constant = 40;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topPrimeraCajaTexto.constant = 80;
        self.heigthCampoComentario.constant = 160;
        self.heigthBottomImage.constant = 240;
        self.bottomBottomActualizar.constant = 60;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topPrimeraCajaTexto.constant = 105;
        self.heigthCampoComentario.constant = 180;
        self.heigthBottomImage.constant = 250;
        self.bottomBottomActualizar.constant = 60;
    }
    [self.view layoutIfNeeded];
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(nextClick:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexible,doneButton, nil]];
    self.txtTelefono.inputAccessoryView = keyboardDoneButtonView;
    
}

- (void)nextClick:(id)sender
{
    if ([_txtTelefono isEqual:_txtTelefono]) {
        [_txtComentario becomeFirstResponder];
    }
}

#pragma mark IBActions

-(IBAction)enviar:(id)sender{
    if ([self.txtNombres.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor asegurate que el campo asunto no se encuentre vacío" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([self.txtComentario.text isEqualToString:@""]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor asegurate que el campo comentario no se encuentre vacío" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            [self requestServerContactenos];
        }
    }
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _txtSelected = textField;
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtNombres isEqual:textField]) {
        [_txtTelefono becomeFirstResponder];
    }else if ([_txtTelefono isEqual:textField]){
        [self.txtComentario becomeFirstResponder];
    }
    return true;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:_txtTelefono]){
        NSUInteger maxLength = 0;
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        maxLength = 10;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= maxLength || returnKey;
    }
    return YES;
}

#pragma mark Metodos UITextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Comentario"] || [textView.text isEqualToString:@" "]) {
        [textView setText:@""];
        textView.textColor = [UIColor colorWithRed:93.0/255.0 green:93/255.0 blue:93/255.0 alpha:1.0];
    }
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
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] || [textView.text isEqualToString:@" "]) {
        textView.text = @"Comentario";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

#pragma mark - RequestServer Contactenos

-(void)requestServerContactenos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerContactenos) object:nil];
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

-(void)envioServerContactenos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:self.txtNombres.text forKey:@"asunto"];
    [data setObject:self.txtComentario.text forKey:@"mensaje"];
    
    NSString * telefono = self.txtTelefono.text;
    
    if ([telefono isEqualToString:@""]) {
        telefono = @"-";
    }
    
    [data setObject:telefono  forKey:@"telefono"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    
    NSMutableDictionary * temp = [RequestUrl contactenos:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoContactenos:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoContactenos:(NSMutableDictionary *)data{
    if ([data count]>0) {
        NSMutableDictionary * temp = [data objectForKey:@"CONTACTENOSResult"];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"1"]) {
            [self.txtNombres setText:@""];
            [self.txtComentario setText:@"Comentario"];
            [self.txtTelefono setText:@""];
            [[NSBundle mainBundle] loadNibNamed:@"VistaMensajeEnviado" owner:self options:nil];
            [self.vistaMensajeEnviado setAlpha:1.0];
            [self.vistaMensajeEnviado setFrame:CGRectMake(0, -30, self.vistaMensajeEnviado.frame.size.width, 30)];
            [self.view addSubview:self.vistaMensajeEnviado];
            [self.lblMensajeEnviado setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
            [UIView animateWithDuration:0.5 animations:^{
                [self.vistaMensajeEnviado setAlpha:1.0];
                [self.vistaMensajeEnviado setFrame:CGRectMake(0, 25, self.view.frame.size.width, 30)];
            }completion:^(BOOL finished){
                [self performSelector:@selector(hiddenToast) withObject:nil afterDelay:4.0];
            }];
        }
        [self mostrarCargando];
    }
}

-(void)hiddenToast{
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaPicker setAlpha:1.0];
        [self.vistaMensajeEnviado setFrame:CGRectMake(0, -30, self.vistaMensajeEnviado.frame.size.width, 30)];
    }completion:^(BOOL finished){
        [self.vistaMensajeEnviado removeFromSuperview];
        self.vistaMensajeEnviado = nil;
    }];
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

@end
