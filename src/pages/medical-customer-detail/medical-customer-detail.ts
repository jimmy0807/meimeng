import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, ActionSheetController, ModalController } from 'ionic-angular';
import { MedicalData, Customer } from '../../providers/medical-data';
import { Camera } from '@ionic-native/camera';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@Component({
  selector: 'page-medical-customer-detail',
  templateUrl: 'medical-customer-detail.html'
})
export class MedicalCustomerDetailPage {
  c: Customer = {};
  list: Customer[] = [];
  editMode = false;
  title: string;
  old_num;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public asCtrl: ActionSheetController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public Camera: Camera,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.c = navParams.data.c;
    this.editMode = this.c.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    this.old_num = this.c.mobile;
  }

  async save() {
    if (!(this.c.name)) {
      this.showToast("请输入姓名");
      return;
    }
    if (!(this.c.mobile)) {
      this.showToast("请输入手机");
      return;
    }
    if (!/^1\d{10}$/.test(this.c.mobile)) {
      this.showToast("请输入正确的手机");
      return;
    }

    let changeMobile = true;
    if (this.editMode) {
      if (this.c.mobile === this.old_num)
        changeMobile = false;
    }

    let r = await this.medicalData.saveMedicalCustomer(this.c, changeMobile);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.c.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.c);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'parent':
        this.modalSelector(SelectorType.Customer, true, d => {
          this.c.parent_id = d.id;
          this.c.parent_name = d.name;
        });
        break;
      case 'rmember':
        this.modalSelector(SelectorType.Member, true, d => {
          this.c.recommend_member_id = d.id;
          this.c.recommend_member_name = d.name;
        });
        break;
      case 'partner':
        this.modalSelector(SelectorType.Partner, true, d => {
          this.c.channel_id = d.id;
          this.c.channel_name = d.name;
        });
        break;
      case 'employee':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.c.employee_id = d.id;
          this.c.employee_name = d.name;
        });
        break;
      case 'member':
        this.modalSelector(SelectorType.Member, true, d => {
          this.c.member_id = d.id;
          this.c.member_name = d.name;
        });
        break;
    }
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
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
    this.Camera.getPicture({
      destinationType: this.Camera.DestinationType.DATA_URL,
      sourceType: this.Camera.PictureSourceType.CAMERA,
      allowEdit: true,
      encodingType: this.Camera.EncodingType.JPEG,
      targetHeight: 256,
      targetWidth: 256,
    }).then(
      (imageData) => this.setImage(imageData),
      (err) => this.showToast(err));
  }

  selectPhoto() {
    this.Camera.getPicture({
      destinationType: this.Camera.DestinationType.DATA_URL,
      sourceType: this.Camera.PictureSourceType.PHOTOLIBRARY,
      mediaType: this.Camera.MediaType.PICTURE,
      allowEdit: true,
      encodingType: this.Camera.EncodingType.JPEG,
      targetHeight: 256,
      targetWidth: 256,
    }).then(
      (imageData) => this.setImage(imageData),
      (err) => this.showToast(err));
  }

  setImage(imageData) {
    if (imageData) {
      let url = 'data:image/jpeg;base64,' + imageData;
      this.c.image_url = url;
      this.c.photo = imageData;
    }
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
