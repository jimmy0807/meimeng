import { Component, ViewChild } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, Slides, ToastController } from 'ionic-angular';
import { PhotoLibrary } from '@ionic-native/photo-library';

@IonicPage()
@Component({
  selector: 'page-image-slides',
  templateUrl: 'image-slides.html',
})
export class ImageSlidesPage {
  imgs = [];
  index: number;
  @ViewChild("Slides") slides: Slides;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public photoLibrary: PhotoLibrary,
    public navParams: NavParams) {

    let imgs: any[] = navParams.data.imgs;
    let index = navParams.data.index;
    for (var i = 0; i < imgs.length; i++) {
      this.imgs.push(imgs[(i + index) % imgs.length]);
    }
  }

  ngAfterViewInit() {
  }

  close() {
    this.viewCtrl.dismiss();
  }

  save() {
    let url = this.imgs[this.slides.realIndex];
    this.photoLibrary.requestAuthorization({
      read: true,
      write: true
    }).then(() => {
      this.photoLibrary.saveImage(url, '店尚')
        .then(d => {
          this.showToast("保存成功");
        })
        .catch(d => {
          this.showToast(d);
        });
    })
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000,
      position: 'middle'
    });
    toast.present();
  }
}
