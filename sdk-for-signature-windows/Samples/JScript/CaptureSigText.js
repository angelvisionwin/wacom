/*
  CaptureSigText
  Captures a signature and creates a SigText file sig.txt
  (an alternative output filename can be supplied as an argument)
  
*/
function print( txt ) {
  WScript.Echo(txt);
}
main();
function main() {
  filename = "sig.txt";
  // Look for commandline arguments
  args = WScript.Arguments;
  if(args.Count() > 0 )
    filename=args(0);
  // Create ActiveX controls
  sigCtl = new ActiveXObject("Florentis.SigCtl");
  sigCtl.SetProperty("Licence","eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3YmM5Y2IxYWIxMGE0NmUxODI2N2E5MTJkYTA2ZTI3NiIsImV4cCI6MjE0NzQ4MzY0NywiaWF0IjoxNTYwOTUwMjcyLCJyaWdodHMiOlsiU0lHX1NES19DT1JFIiwiU0lHQ0FQVFhfQUNDRVNTIl0sImRldmljZXMiOlsiV0FDT01fQU5ZIl0sInR5cGUiOiJwcm9kIiwibGljX25hbWUiOiJTaWduYXR1cmUgU0RLIiwid2Fjb21faWQiOiI3YmM5Y2IxYWIxMGE0NmUxODI2N2E5MTJkYTA2ZTI3NiIsImxpY191aWQiOiJiODUyM2ViYi0xOGI3LTQ3OGEtYTlkZS04NDlmZTIyNmIwMDIiLCJhcHBzX3dpbmRvd3MiOltdLCJhcHBzX2lvcyI6W10sImFwcHNfYW5kcm9pZCI6W10sIm1hY2hpbmVfaWRzIjpbXX0.ONy3iYQ7lC6rQhou7rz4iJT_OJ20087gWz7GtCgYX3uNtKjmnEaNuP3QkjgxOK_vgOrTdwzD-nm-ysiTDs2GcPlOdUPErSp_bcX8kFBZVmGLyJtmeInAW6HuSp2-57ngoGFivTH_l1kkQ1KMvzDKHJbRglsPpd4nVHhx9WkvqczXyogldygvl0LRidyPOsS5H2GYmaPiyIp9In6meqeNQ1n9zkxSHo7B11mp_WXJXl0k1pek7py8XYCedCNW5qnLi4UCNlfTd6Mk9qz31arsiWsesPeR9PN121LBJtiPi023yQU8mgb9piw_a-ccciviJuNsEuRDN3sGnqONG3dMSA");
  dynCapt = new ActiveXObject("Florentis.DynamicCapture");
  // Start Signature Capture
  rc = dynCapt.Capture(sigCtl,"Who","Why");
  if( rc == 0 ) {
    // Capture was successful
    // (optionally) insert some extra data in the signature object
    sigCtl.Signature.ExtraData("AdditionalData") = "CaptureSigText.js Additional Data";

    print("SigText:\n"+sigCtl.Signature.SigText);

    // Save SigText to disk
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForWriting = 2;
    var f = fso.OpenTextFile(filename, ForWriting, true);
    f.Write(sigCtl.Signature.SigText);
    f.Close();
    print("Created Signature Text file: " + filename);
  }
  else {
    // Capture failed:
    print("Capture returned: " + rc);
    switch(rc) {
      case 1:   print("Cancelled");
                break;
      case 100: print("Signature tablet not found");
                break;
      case 103: print("Capture not licensed");
                break;
    }
  }
}
