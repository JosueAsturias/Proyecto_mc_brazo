#Proyecto 2
#Programación de microncontroladores
#Miguel García   17560
#Josué Asturias  17262

from tkinter import *
import serial
import time
import sys


#----------------------------------------------------------------
puerto = 'COM15'
ser = serial.Serial(port = puerto, baudrate = 9600,
                    parity = serial.PARITY_NONE,
                    stopbits = serial.STOPBITS_ONE,
                    bytesize = serial. EIGHTBITS, timeout = 0)
#-----------------------------------------------------------------
color_fondo = '#DCDCDC'
numero = 0
x = 0
Y = 0
Z = 0

#------------------------------------------------------------
def gra1():
    global x
    x = 0
    archivo=open('recibido_1.txt','w')
    while x == 0:    
            dato = ser.read()
            try:
                if dato == '':
                    pass
                else:
                    if ord(dato) == 200:

                        dato1 = ser.read()
                        dato2 = ser.read()
                        dato3 = ser.read()
                        dato4 = ser.read()

                        valor1 = ord(dato1)
                        valor2 = ord(dato2)
                        valor3 = ord(dato3)            
                        valor4 = ord(dato4)
                        archivo.write(str(valor1)+'\n')
                        archivo.write(str(valor2)+'\n')
                        archivo.write(str(valor3)+'\n')
                        archivo.write(str(valor4)+'\n')
                        print(str(valor1) + ',' + str(valor2) + ',' + str(valor3)+ ',' + str(valor4))
                        ser.flushInput()
                        time.sleep(.1)
                                     
                    else:
                        ser.flushInput()
            except:
                print('.')
            ventana.update()
    archivo.close()
    

def rep1():
    f = open('recibido_1.txt','r')
    mensaje = f.readlines()
    elemento1 = 200
    elemento1 = elemento1.to_bytes(1,'little')
    ser.write(elemento1)
    ser.flushOutput()
    for elemento in mensaje:
        time.sleep(.003)
        ventana.update()
        try:
            numero = int(elemento)
            numero = numero.to_bytes(1,'little')
            ser.write(numero)
            ser.flushOutput()
        except TypeError:
            print('no manda')

        print(elemento)
    f.close()
    adios = 235
    adios = adios.to_bytes(1, 'little')
    ser.write(adios)
    ser.flushOutput()
    print('Rutina terminada')


def par1():
    global x
    x = 1
    print("Deja de grabar")


#------------------------------------------------------------

def gra2():
    global Y
    Y = 0
    archivo=open('recibido_2.txt','w')
    while Y == 0:    
            dato = ser.read()
            try:
                if dato == '':
                    pass
                else:
                    if ord(dato) == 200:

                        dato1 = ser.read()
                        dato2 = ser.read()
                        dato3 = ser.read()
                        dato4 = ser.read()

                        valor1 = ord(dato1)
                        valor2 = ord(dato2)
                        valor3 = ord(dato3)            
                        valor4 = ord(dato4)
                        archivo.write(str(valor1)+'\n')
                        archivo.write(str(valor2)+'\n')
                        archivo.write(str(valor3)+'\n')
                        archivo.write(str(valor4)+'\n')
                        print(str(valor1) + ',' + str(valor2) + ',' + str(valor3)+ ',' + str(valor4))
                        ser.flushInput()
                        time.sleep(.1)
                                     
                    else:
                        ser.flushInput()
            except:
                print('.')
            ventana.update()
    archivo.close()


def rep2():
    f = open('recibido_2.txt','r')
    mensaje = f.readlines()
    elemento1 = 200
    elemento1 = elemento1.to_bytes(1,'little')
    ser.write(elemento1)
    ser.flushOutput()
    for elemento in mensaje:
        time.sleep(.003)
        ventana.update()
        try:
            numero = int(elemento)
            numero = numero.to_bytes(1,'little')
            ser.write(numero)
            ser.flushOutput()
        except TypeError:
            print('no manda')

        print(elemento)
    f.close()
    adios = 235
    adios = adios.to_bytes(1, 'little')
    ser.write(adios)
    ser.flushOutput()
    print('Rutina terminada')

def par2():
    global Y
    Y = 1
    print("Deja de grabar")
#------------------------------------------------------------
def gra3():
    global Z
    Z = 0
    archivo=open('recibido_3.txt','w')
    while Z == 0:    
            dato = ser.read()
            try:
                if dato == '':
                    pass
                else:
                    if ord(dato) == 200:

                        dato1 = ser.read()
                        dato2 = ser.read()
                        dato3 = ser.read()
                        dato4 = ser.read()

                        valor1 = ord(dato1)
                        valor2 = ord(dato2)
                        valor3 = ord(dato3)            
                        valor4 = ord(dato4)
                        archivo.write(str(valor1)+'\n')
                        archivo.write(str(valor2)+'\n')
                        archivo.write(str(valor3)+'\n')
                        archivo.write(str(valor4)+'\n')
                        print(str(valor1) + ',' + str(valor2) + ',' + str(valor3)+ ',' + str(valor4))
                        ser.flushInput()
                        time.sleep(.1)
                                     
                    else:
                        ser.flushInput()
            except:
                print('.')
            ventana.update()
    archivo.close()

def rep3():
    f = open('recibido_3.txt','r')
    mensaje = f.readlines()
    elemento1 = 200
    elemento1 = elemento1.to_bytes(1,'little')
    ser.write(elemento1)
    ser.flushOutput()
    for elemento in mensaje:
        time.sleep(.003)
        ventana.update()
        try:
            numero = int(elemento)
            numero = numero.to_bytes(1,'little')
            ser.write(numero)
            ser.flushOutput()
        except TypeError:
            print('no manda')

        print(elemento)
    f.close()
    adios = 235
    adios = adios.to_bytes(1, 'little')
    ser.write(adios)
    ser.flushOutput()
    print('Rutina terminada')

def par3():
    global Z
    Z = 1
    print("Deja de grabar")

#------------------ventana-------------------
ventana = Tk()
ventana.title("Proyecto 2")
ventana.geometry("600x550")
ventana.resizable(width=FALSE, height=FALSE)
ventana.config(bg=color_fondo)
ventana.iconbitmap('hola.ico')

#------------------imagen-------------------
##imagen1 = PhotoImage(file="PIC_1.png")
##fondo = Label(ventana, image=imagen1, background = color_fondo).place(x=300,y=290)
img_bt = PhotoImage(file="Captura1.png")
img_bt2 = PhotoImage(file="Captura2.png")
img_bt3 = PhotoImage(file="Stop_1.png")

#------------------labels-------------------
rut1 = Label(ventana, text="Rutina 1", background = color_fondo, font=('Comics', 18)).place(x=145,y=40)
rut2 = Label(ventana, text="Rutina 2", background = color_fondo, font=('Comics', 18)).place(x=145,y=180)
rut3 = Label(ventana, text="Rutina 3", background = color_fondo, font=('Comics', 18)).place(x=145,y=320)
nombre1 = Label(ventana, text="Miguel García \n17560", background = color_fondo, font=('Times', 14)).place(x=370,y=460)
nombre2 = Label(ventana, text="Josué Asturias \n17262",background = color_fondo, font=('Times', 14)).place(x=85,y=460)

#-----------------Botones---------------------
grabar1 = Button(ventana, image = img_bt, command=gra1).place(x=280,y=40)
grabar2 = Button(ventana, image = img_bt, command=gra2).place(x=280,y=180)
grabar3 = Button(ventana, image = img_bt, command=gra3).place(x=280,y=320)

repro1 = Button(ventana, image = img_bt2, command=rep1).place(x=365,y=64)
repro2 = Button(ventana, image = img_bt2, command=rep2).place(x=365,y=204)
repro3 = Button(ventana, image = img_bt2, command=rep3).place(x=365,y=344)

parar1 = Button(ventana, image = img_bt3, command=par1).place(x=280,y=105)
parar2 = Button(ventana, image = img_bt3, command=par2).place(x=280,y=245)
parar3 = Button(ventana, image = img_bt3, command=par3).place(x=280,y=385
                                                              )


ventana.mainloop()
