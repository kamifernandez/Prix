//
//  ContactenosViewController.h
//  Prix
//
//  Created by Christian Fernandez on 30/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactenosViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBottomActualizar;

@property (weak, nonatomic) IBOutlet UIButton *btnEnviar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthBottomImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPrimeraCajaTexto;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthCampoComentario;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)IBOutlet UITextField * txtNombres;
@property(nonatomic,weak)IBOutlet UITextField * txtTelefono;
@property(nonatomic,weak)IBOutlet UITextField * txtFechaNacimiento;
@property(nonatomic,weak)IBOutlet UITextField * txtContrasena;

@property(nonatomic,weak)IBOutlet UITextView * txtComentario;

@property(nonatomic,strong)NSString *tipo;
@property(nonatomic,strong)NSMutableDictionary *data;
@property(nonatomic,strong)NSString *date;

@property(nonatomic,weak)UITextField * txtSelected;

//View Picker

@property(nonatomic,weak)IBOutlet UIView * vistaPicker;
@property(nonatomic,weak)IBOutlet UIView * vistaContentPicker;

@property(nonatomic,weak)IBOutlet UIDatePicker * pickerView;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

// PushNotification

@property(nonatomic,strong)NSMutableArray * dataDetalleCategorias;

// Vista Mensaje Enviado

@property(nonatomic,weak)IBOutlet UIView *vistaMensajeEnviado;

@property(nonatomic,weak)IBOutlet UILabel *lblMensajeEnviado;

@end
