import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, ActionSheetController, ViewController, ModalController } from 'ionic-angular';
import { VisitNote, VisitData, Visit } from '../../providers/visit-data';
import { Camera } from '@ionic-native/camera';
import { AppGlobal } from '../../app-global';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-visit-note',
  templateUrl: 'visit-note.html',
})
export class VisitNotePage {
  v: Visit;
  n: VisitNote;
  list: VisitNote[];
  isAdmin = false;
  isSelf = false;
  levels = [];
  readonly = false;
  holder1 = '请输入';
  holder2 = '请选择';
  loading = false;
  constructor(public navCtrl: NavController,
    public visitData: VisitData,
    public asCtrl: ActionSheetController,
    public toastCtrl: ToastController,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public camera: Camera,
    public navParams: NavParams) {
    this.v = navParams.data.v;
    this.n = navParams.data.n || {};
    this.list = navParams.data.list || [];
    this.n.added_images = [];
    this.n.deleted_images = [];
    this.n.visit_image_ids = this.n.visit_image_ids || [];

    let ug = AppGlobal.getInstance().userGroup;
    if (ug)
      this.isAdmin = ug.sel_groups_103_104 === '经理'
    //if (this.n.id)
    //  this.readonly = true;
    if (!this.n.plant_visit_date) {
      let d = new Date();
      this.n.plant_visit_date = this.getDateStr(d);
    }
    if (!this.n.state) {
      this.n.state = 'draft';
      this.n.state_name = '待回访';
    }
    if (this.readonly) {
      this.holder1 = this.holder2 = '';
    }
    if (this.n.employee_id === AppGlobal.getInstance().user.eid)
      this.isSelf = true;
  }

  getDateStr(d: Date) {
    return `${d.getFullYear()}-${this.padLeft(d.getMonth() + 1)}-${this.padLeft(d.getDate())}`;
  }

  padLeft(num) {
    if (num < 10)
      return '0' + String(num);
    return String(num);
  }

  async ngAfterViewInit() {
    let r = await this.visitData.getVisitLevels();
    if (r.errcode === 0) {
      this.levels = r.data;
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
      (imageData) => this.addImage(imageData),
      (err) => this.showToast(err));
  }

  selectPhoto() {
    this.camera.getPicture({
      destinationType: this.camera.DestinationType.DATA_URL,
      sourceType: this.camera.PictureSourceType.PHOTOLIBRARY,
      mediaType: this.camera.MediaType.PICTURE,
      allowEdit: false,
      encodingType: this.camera.EncodingType.JPEG,
    }).then(
      (imageData) => this.addImage(imageData),
      (err) => this.showToast(err));
  }

  addImage(data) {
    let img = { image: data, image_url: 'data:image/jpeg;base64,' + data };
    this.n.visit_image_ids.push(img);
    this.n.added_images.push(img);
  }

  delImage(img) {
    let index = this.n.visit_image_ids.indexOf(img);
    this.n.visit_image_ids.splice(index, 1);
    if (img.id) {
      this.n.deleted_images.push(img);
    }
    else {
      let index = this.n.added_images.indexOf(img);
      this.n.added_images.splice(index, 1);
    }
  }

  showImage(img) {
    let p = {
      imgs: this.n.visit_image_ids.map(i => i.image_url),
      index: this.n.visit_image_ids.indexOf(img),
    }
    this.navCtrl.push('ImageSlidesPage', p);
  }

  async save() {
    if (!this.n.employee_id) {
      this.showToast('请选择员工');
      return;
    }
    if (!this.n.levle_id) {
      this.showToast('请选择类型');
      return;
    }
    if (!this.n.plant_visit_date) {
      this.showToast('请选择回访日期');
      return;
    }

    for (var i = 0; i < this.levels.length; i++) {
      if (this.levels[i].id == this.n.levle_id) {
        this.n.levle_name = this.levels[i].name;
        break;
      }
    }
    try {
      this.loading = true;
      if (this.n.id) {
        let r = await this.visitData.saveVisitNote(this.n);
        this.showToast(r.errmsg);
        if (r.errcode == 0) {
          this.changeState(r.data);
          this.dismiss();
        }
      }
      else if (this.v.id) {
        this.n.visit_id = this.v.id;
        let r = await this.visitData.saveVisitNote(this.n);
        this.showToast(r.errmsg);
        if (r.errcode == 0) {
          this.n.id = r.data.id;
          this.changeState(r.data);
          this.v.note_ids.push(this.n);
          this.dismiss();
        }
      }
      else {
        if (this.v.note_ids.indexOf(this.n) < 0)
          this.v.note_ids.push(this.n);
        this.dismiss();
      }
    }
    finally {
      this.loading = false;
    }
  }

  changeState(d: VisitNote) {
    this.n.state = d.state;
    this.n.state_name = d.state_name;
    let note = this.list.find(i => i.id == d.id);
    if (note) {
      note.state = d.state;
      note.state_name = d.state_name;
    }
  }

  async done() {
    try {
      if (!this.n.note) {
        this.showToast('请填写回访结果')
        return;
      }
      this.loading = true;
      let r = await this.visitData.doneVisitNote(this.n)
      this.showToast(r.errmsg);
      if (r.errcode === 0) {
        this.n.state = 'done';
        this.n.state_name = '已回访';
        this.dismiss();
      }
    }
    finally {
      this.loading = false;
    }
  }


  select(type: string) {
    if (this.readonly)
      return;

    switch (type) {
      case 'employee':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.n.employee_id = d.id;
          this.n.employee_name = d.name;
          this.n.plant_visit_user_id = d.user_id;
        });
        break;
      case 'user':
        this.modalSelector(SelectorType.User, true, d => {
          this.n.plant_visit_user_id = d.id;
          this.n.plant_visit_user_name = d.name;
        });
        break;
    }
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function, mid: number = undefined, ) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single, data: mid });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
  }

  async finish() {
    try {
      this.loading = true;
      let r = await this.visitData.finishVisitNote(this.n)
      this.showToast(r.errmsg);
      if (r.errcode === 0) {
        this.n.state = 'finish';
        this.n.state_name = '已完成';
        this.dismiss();
      }
    }
    finally {
      this.loading = false;
    }
  }

  async draft() {
    try {
      this.loading = true; let r = await this.visitData.draftVisitNote(this.n)
      this.showToast(r.errmsg);
      if (r.errcode === 0) {
        this.n.state = 'draft';
        this.n.state_name = '待回访';
        this.dismiss();
      }
    }
    finally {
      this.loading = false;
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
