import { Component } from '@angular/core';
import { NavController, NavParams, ActionSheetController, ToastController, ViewController } from 'ionic-angular';
import { Partner, PartnerData, PartnerImage } from '../../providers/partner-data';
import { Camera } from '@ionic-native/camera';

@Component({
  selector: 'page-partner-detail-image',
  templateUrl: 'partner-detail-image.html'
})
export class PartnerDetailImagePage {
  p: Partner;
  img: PartnerImage;
  types = [];

  constructor(public navCtrl: NavController,
    public camera: Camera,
    public asCtrl: ActionSheetController,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public partnerData: PartnerData,
    public navParams: NavParams) {
    this.p = navParams.data.p;
    this.img = navParams.data.img;
  }

  async ngAfterViewInit() {
    try {
      let r = await this.partnerData.getImageTypes();
      if (r.errcode === 0)
        this.types = r.data;
    }
    catch (e) { }
  }

  async save() {
    try {
      if (!this.img.name) {
        this.showToast('请输入标题');
        return;
      }
      if (!this.img.image && !this.img.image_url) {
        this.showToast('请选择图片');
        return;
      }
      if (this.img.type) {
        this.img.type_name = this.types.find(t => t.id == this.img.type).name;
      }
      if (this.p.id) {
        let r = await this.partnerData.savePartnerImage(this.img, this.p.id);
        this.showToast(r.errmsg);
        if (r.errcode === 0) {
          let newImg: PartnerImage = r.data;
          let index = this.p.image_ids.indexOf(this.img);
          if (index >= 0)
            this.p.image_ids[index] = newImg;
          else
            this.p.image_ids.push(newImg);
          this.viewCtrl.dismiss();
        }
      }
      else {
        if (this.p.image_ids.indexOf(this.img) < 0) {
          this.p.image_ids.push(this.img);
        }
        this.viewCtrl.dismiss();
      }
    } catch (e) {
      this.showToast();
    }
  }

  getImage() {
    let actionSheet = this.asCtrl.create({
      buttons: [{
        text: '拍照',
        handler: () => this.takePhoto()
      },
      {
        text: '选择照片',
        handler: () => this.selectPhoto()
      },
      {
        text: '取消',
        role: 'cancel',
      }]
    });
    actionSheet.present();
  }

  takePhoto() {
    this.camera.getPicture({
      destinationType: this.camera.DestinationType.DATA_URL,
      sourceType: this.camera.PictureSourceType.CAMERA,
      allowEdit: true,
      encodingType: this.camera.EncodingType.JPEG,
    }).then(
      (imageData) => this.setImage(imageData),
      (err) => this.showToast(err));
  }

  selectPhoto() {
    this.camera.getPicture({
      destinationType: this.camera.DestinationType.DATA_URL,
      sourceType: this.camera.PictureSourceType.PHOTOLIBRARY,
      mediaType: this.camera.MediaType.PICTURE,
      allowEdit: true,
      encodingType: this.camera.EncodingType.JPEG,
    }).then(
      (imageData) => this.setImage(imageData),
      (err) => this.showToast(err));
  }

  setImage(data) {
    if (data) {
      this.img.image = data;
      this.img.image_url = "data:image/jpeg;base64," + data;
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }


  dismiss() {
    this.viewCtrl.dismiss();
  }
}
