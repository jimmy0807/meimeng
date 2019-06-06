import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { ZimgProvider } from '../../providers/zimg';
import { QRScanner, QRScannerStatus } from '@ionic-native/qr-scanner';

@IonicPage()
@Component({
  selector: 'page-test',
  templateUrl: 'test.html',
})
export class TestPage {

  constructor(public navCtrl: NavController,
    private qrScanner: QRScanner,
    public zimg: ZimgProvider,
    public navParams: NavParams) {
  }

  async  upload() {
    //let img = ""
    //let d = await this.zimg.uploadBase64(img);
    //alert(JSON.stringify(d));
  }

  async scan() {
    try {
      let status = await this.qrScanner.prepare();
      if (status.authorized) {
        // camera permission was granted
        // start scanning
        let scanSub = this.qrScanner.scan().subscribe((text: string) => {
          console.log('Scanned something', text);

          this.qrScanner.hide(); // hide camera preview
          scanSub.unsubscribe(); // stop scanning
        });

        // show camera preview
        this.qrScanner.show();

        // wait for user to scan something, then the observable callback will be called

      } else if (status.denied) {
        // camera permission was permanently denied
        // you must use QRScanner.openSettings() method to guide the user to the settings page
        // then they can grant the permission from there
      } else {
        // permission was denied, but not permanently. You can ask for permission again at a later time.
      }
    }
    catch (e) {
      console.log('Error is', e)
    }
  }
}
