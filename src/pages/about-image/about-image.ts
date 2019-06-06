import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, ActionSheetController } from 'ionic-angular';
import { Employee, EmployeeData } from '../../providers/employee-data';
import { Camera } from '@ionic-native/camera';

@Component({
  selector: 'page-about-image',
  templateUrl: 'about-image.html'
})
export class AboutImagePage {
  employee: Employee;
  key: string;
  value: any;
  base64: string;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public employeeData: EmployeeData,
    public asCtrl: ActionSheetController,
    public camera: Camera,
    public navParams: NavParams) {
    this.employee = navParams.data.employee;
    this.key = navParams.data.key;
    this.value = navParams.data.value;
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
      targetHeight: 256,
      targetWidth: 256,
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
      targetHeight: 256,
      targetWidth: 256,
    }).then(
      (imageData) => this.setImage(imageData),
      (err) => this.showToast(err));
  }

  setImage(imageData) {
    if (imageData) {
      this.value = 'data:image/jpeg;base64,' + imageData;
      this.base64 = imageData;
      this.save();
    }
  }

  save() {
    this.employeeData.saveEmployeeProp(this.employee.id, this.key, this.base64).then(
      info => {
        var data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode == 0) {
          this.employee.image_url = this.value;
          //this.viewCtrl.dismiss();
        }
      },
      err => {
        this.showToast();
      }
    );
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
