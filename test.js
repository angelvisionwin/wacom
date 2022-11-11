/*
  Javascript
  Captures a signature and creates encoded image file sig.png
  Optionally a different filename can be supplied as an argument
  e.g. sign myfile.png
  
*/
function print( txt ) {
    WScript.Echo(txt);
  }
  main();
  function main() {
    mimeType = "<<MIMETYPE>>";
    outFile  = "<<OUTFILE>>";
    comPort  = "<<COMPORT>>";
    if( mimeType.substr(1) == "<MIMETYPE>>" )
      mimeType="image/png";
    if( outFile.substr(1) == "<OUTFILE>>" )
      outFile="sign.png";
    if( comPort.substr(1) == "<COMPORT>>" )
      comPort="";
    sigCtl = new ActiveXObject("Florentis.SigCtl");
    sigCtl.SetProperty( "Licence", "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3YmM5Y2IxYWIxMGE0NmUxODI2N2E5MTJkYTA2ZTI3NiIsImV4cCI6MjE0NzQ4MzY0NywiaWF0IjoxNTYwOTUwMjcyLCJyaWdodHMiOlsiU0lHX1NES19DT1JFIiwiU0lHQ0FQVFhfQUNDRVNTIl0sImRldmljZXMiOlsiV0FDT01fQU5ZIl0sInR5cGUiOiJwcm9kIiwibGljX25hbWUiOiJTaWduYXR1cmUgU0RLIiwid2Fjb21faWQiOiI3YmM5Y2IxYWIxMGE0NmUxODI2N2E5MTJkYTA2ZTI3NiIsImxpY191aWQiOiJiODUyM2ViYi0xOGI3LTQ3OGEtYTlkZS04NDlmZTIyNmIwMDIiLCJhcHBzX3dpbmRvd3MiOltdLCJhcHBzX2lvcyI6W10sImFwcHNfYW5kcm9pZCI6W10sIm1hY2hpbmVfaWRzIjpbXX0.ONy3iYQ7lC6rQhou7rz4iJT_OJ20087gWz7GtCgYX3uNtKjmnEaNuP3QkjgxOK_vgOrTdwzD-nm-ysiTDs2GcPlOdUPErSp_bcX8kFBZVmGLyJtmeInAW6HuSp2-57ngoGFivTH_l1kkQ1KMvzDKHJbRglsPpd4nVHhx9WkvqczXyogldygvl0LRidyPOsS5H2GYmaPiyIp9In6meqeNQ1n9zkxSHo7B11mp_WXJXl0k1pek7py8XYCedCNW5qnLi4UCNlfTd6Mk9qz31arsiWsesPeR9PN121LBJtiPi023yQU8mgb9piw_a-ccciviJuNsEuRDN3sGnqONG3dMSA" );
    dynCapt = new ActiveXObject("Florentis.DynamicCapture");
    if( comPort != "" ) {
      dynCapt.SetProperty( "stuSigModeScreenNum", 1 );
      dynCapt.SetProperty( "stuSigModeWhen", 1 );		// TimeGMT
      dynCapt.SetProperty( "stuSigModeOK", "Aceptar" );
      dynCapt.SetProperty( "stuSigModeClear", "Borrar" );
      dynCapt.SetProperty( "stuSigModeCancel", "Cancelar" );
      dynCapt.SetProperty( "stuSigModeFontName", "Verdana" );
      dynCapt.SetProperty( "stuSigModeFontSize", 10 ); 
      dynCapt.SetProperty( "stuPort", comPort );
      dynCapt.SetProperty( "stuBaudRate", 128000 );
    }	
    rc = dynCapt.Capture( sigCtl, " ", " " );
    switch(rc) {
    case 0:  // CaptureOk
      sigCtl.Signature.RenderBitmap( outFile, 300, 150, mimeType, 0.5, 0xff0000, 0xffffff, 0.0, 0.0, 0x1000 | 0x80000 | 0x400000 ); // RenderOutputFilename | RenderColor32BPP | RenderEncodeData
      break;
    case 1:   // CaptureCancel
      break;
    case 100: // CapturePadError
      print( "Error en captura 100: Dispositivo de firma no disponible" );
      break;
    case 101: // CaptureError
      print( "Error en captura " + rc + ": Error en dispositivo" );
      break;
    case 103: // CaptureNotLicensed
      print( "Error en captura " + rc + ": Licencia inválida" );
      break;
    default:
      print( "Error en captura " + rc );
      break;
    }
  }
  