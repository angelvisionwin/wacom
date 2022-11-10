#include "FiveWin.Ch"
#define NTRIM(n)    ( LTrim( Str( n ) ) )
//#define print(x)  msginfo(x)



#translate print( <v1>[, <v2>])      =>  ;
                   msginfo( <v1> [,  <v2> ] )


STATIC UsbDevices, usbDevice, tablet, protocolHelper, r, r1

//------------------------------------------------------------------------//
Function main()

   If MsgNoYes("Borrar")
      BorrarTablet()
   Else
      EnviarImagen()
   EndIf

   print("fin")
RETURN NIL

//------------------------------------------------------------------------//
Function Connect()
Local nCount    //, r1, r
//Local usbDevices, nCount
//Local usbDevice, tablet, protocolHelper, r1, r
Local Connected := .F.

     nCount := 0
     TRY
       usbDevices = createObject("WacomGSS.STU.UsbDevices")
       nCount := usbDevices:Count
     CATCH
        Msginfo("Falta el driver de conexion STU")
        RETURN Connected
     END

     If nCount ==0
        MsgInfo("No se localizaron dispositivos STU")
        Return Connected
     EndIf


     with object usbDevices
          usbDevice := :Item(0)
     End

    protocolHelper = createObject("WacomGSS.STU.ProtocolHelper")
    tablet         = createObject("WacomGSS.STU.Tablet")
    r1             = tablet:usbConnect(usbDevice, 0)
    r              = r1:value
    If r = 0
       Connected = .t.
    Else
       MsgInfo("No se pudo conectar")
    EndIf

Return Connected

//------------------------------------------------------------------------//
#define EncodingFlag_Zlib   0x01
#define EncodingFlag_1bit   0x02        // mono
#define EncodingFlag_16bit  0x04        // 16bit colour (520/530)
#define EncodingFlag_24bit  0x08        // 24bit colour (530)

/*
enumEncodingFlag = {                // encodingFlag reports what the STU device is capable of:
  EncodingFlag_Zlib : 0x01,
  EncodingFlag_1bit : 0x02,         // mono
  EncodingFlag_16bit : 0x04,        // 16bit colour (520/530)
  EncodingFlag_24bit : 0x08         // 24bit colour (530)
}
*/

#define EncodingMode_1bit   0x00    // mono display STU300/430/500
#define EncodingMode_1bit_Zlib  0x01    // use zlib compression (not automated by the SDK – the application code has to compress the data)
#define EncodingMode_16bit  0x02    // colour stu-520 & 530
#define EncodingMode_24bit  0x04    // colour STU 530
                                        // tablet.supportsWrite() is true if the bulk driver is installed and available
#define EncodingMode_1bit_Bulk  0x10    // use bulk driver (520/530)
#define EncodingMode_16bit_Bulk 0x12
#define EncodingMode_24bit_Bulk 0x14
#define EncodingMode_Raw    0x00
#define EncodingMode_Zlib   0x01
#define EncodingMode_Bulk   0x10
#define EncodingMode_16bit_565  0x02


/*
enumEncodingMode = {                // selects image transformation
  EncodingMode_1bit : 0x00,         // mono display STU300/430/500
  EncodingMode_1bit_Zlib : 0x01,    // use zlib compression (not automated by the SDK – the application code has to compress the data)
  EncodingMode_16bit : 0x02,        // colour stu-520 & 530
  EncodingMode_24bit : 0x04,        // colour STU 530
                                    // tablet.supportsWrite() is true if the bulk driver is installed and available
  EncodingMode_1bit_Bulk : 0x10,    // use bulk driver (520/530)
  EncodingMode_16bit_Bulk : 0x12,
  EncodingMode_24bit_Bulk : 0x14,

  EncodingMode_Raw : 0x00,
  EncodingMode_Zlib : 0x01,
  EncodingMode_Bulk : 0x10,
  EncodingMode_16bit_565 : 0x02
}
*/

#define Scale_Stretch   0
#define Scale_Fit   1
#define Scale_Clip  2

/*
enumScale = {
  Scale_Stretch : 0,
  Scale_Fit : 1,
  Scale_Clip : 2
}
*/

#define false   0

FUNCTION BorrarTablet()
If !Connect()
   RETURN NIL
EndIf
print("Tablet conectada")
tablet:setClearScreen()
tablet:disconnect()
print("tablet borrada")
return nil



FUNCTION unescape(xValue) ; RETURN xValue

FUNCTION EnviarImagen()
Memvar oErr
Local caps, info, pId, encodingFlag, encodingMode, stuImage, filename
BorrarTablet()

If !Connect()
   RETURN NIL
EndIf
print("Tablet conectada")

caps = tablet:getCapability()
info = tablet:getInformation()
print("STU model: " + info:modelName)
pId = tablet:getProductId()
print("Product id: "+ dectohex(pId))

encodingFlag = protocolHelper:simulateEncodingFlag(pId, caps:encodingFlag)
print("encodingFlag: " + dectohex(encodingFlag))

If nAnd(encodingFlag, EncodingFlag_24bit ) != 0
    encodingMode = iif(tablet:supportsWrite(), EncodingMode_24bit_Bulk, EncodingMode_24bit)
elseif nAnd(encodingFlag , EncodingFlag_16bit) != 0
    encodingMode = iif(tablet:supportsWrite(), EncodingMode_16bit_Bulk, EncodingMode_16bit)
else
    encodingMode = EncodingMode_1bit
EndIf


print(encodingflag)
print(EncodingFlag_24bit )
print(nAnd(EncodingFlag, EncodingFlag_Zlib ))
print(nAnd(EncodingFlag, EncodingFlag_1bit ))
print(nAnd(EncodingFlag, EncodingFlag_16bit))
print(nAnd(EncodingFlag, EncodingFlag_24bit ))
print(tablet:supportsWrite(), "suportswrite")
print("encodingMode: " + dectohex(encodingMode))


filename := unescape("screen.bmp")
stuImage = protocolHelper:resizeAndFlatten(filename, 0, 0, 0, 0, caps:screenWidth, caps:screenHeight, encodingMode, Scale_Fit, .f., 0)

print(filename, "filename")
print(caps:screenWidth, "screenwidth")
print(caps:screenHeight, "screenhigh")
print(encodingMode, "encondingmode")
print(Scale_Fit, "ScaleFit")


TRY
   tablet:writeImage(encodingMode, stuImage)      // uses the colour mode flags in encodingMode
CATCH oErr
   Msginfo("Error en la escritura de la tablet")
END


tablet:disconnect()

RETURN NIL

 