import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, ModalController, ActionSheetController } from 'ionic-angular';
import { MemberData, Member } from '../../providers/member-data';
import { PartnerData } from '../../providers/partner-data';
import { MemberSelectorPage } from '../member-selector/member-selector';
import { EmployeeListPage } from '../employee-list/employee-list';
import { Camera } from '@ionic-native/camera';
import { AppGlobal } from '../../app-global';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';
import { MemberDetailPage } from '../member-detail/member-detail';

@Component({
  selector: 'page-member-add',
  templateUrl: 'member-add.html'
})
export class MemberAddPage {
  title: string;
  member: Member;
  editMode = false;
  adMode = false;
  showMore = false;
  source: any[];
  belongs: any[];

  changeImage = false;
  old_num;
  groupMedical = false;
  seePartner = false;

  constructor(public navCtrl: NavController,
    public asCtrl: ActionSheetController,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public partnerData: PartnerData,
    public navParams: NavParams,
    public Camera: Camera,
    public toastCtrl: ToastController,
    public memberData: MemberData) {

    this.groupMedical = AppGlobal.getInstance().groupMedical;
    this.seePartner = AppGlobal.getInstance().user.is_accept_see_partner;
    this.member = navParams.data;
    this.editMode = this.member.id > 0;
    this.adMode = this.member.is_ad || false;
    this.old_num = this.member.mobile || '';
    this.title = (this.editMode ? '编辑' : '新建') + (this.adMode ? '体验会员' : '会员');
    if (!this.editMode)
      this.member.gender = 'Female';
  }

  async ngAfterViewInit() {
    try {
      let r = await this.memberData.getMemberSource();
      if (r.errcode === 0)
        this.source = r.data;
      r = await this.memberData.getMemberBelongs();
      if (r.errcode === 0)
        this.belongs = r.data;
    } catch (e) {

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
      this.member.image_url = url;
      this.member.image = imageData;
      this.changeImage = true;
    }
  }

  async save() {

    if (!(this.member.name)) {
      this.showToast("请输入姓名");
      return;
    }
    if (!(this.member.mobile)) {
      this.showToast("请输入手机");
      return;
    }
    if (!/^1\d{10}$/.test(this.member.mobile)) {
      this.showToast("请输入正确的手机");
      return;
    }

    let changeMobile = true;
    if (this.editMode) {
      if (this.member.mobile === this.old_num)
        changeMobile = false;
    }

    let r = await this.memberData.saveMember(this.member, changeMobile, this.changeImage);
    if (r.errcode == 0) {
      let m: Member = r.data;
      this.member.id = m.id;
      this.member.dj_partner_id = m.dj_partner_id;
      this.member.dj_partner_name = m.dj_partner_name;
      this.member.dd_partner_id = m.dd_partner_id;
      this.member.dd_partner_name = m.dd_partner_name;
      this.member.dl_partner_id = m.dl_partner_id;
      this.member.dl_partner_name = m.dl_partner_name;
      this.viewCtrl.dismiss(this.member);
      this.showMember();
    } else {
      this.showToast(r.errmsg);
    }
  }

  showMember() {
    if (!this.editMode) {
      let m: any = this.member;
      m.mode = 'view';
      this.navCtrl.push(MemberDetailPage, m);
    }
  }

  selectEmployee(key: string) {
    let m = this.modalCtrl.create(EmployeeListPage, { mode: 'single', cat: key });
    m.onDidDismiss(data => {
      if (data) {
        switch (key) {
          case 'adviser':
            this.member.employee_id = data.id;
            this.member.employee_name = data.name;
            break;
          case 'technician':
            this.member.technician_id = data.id;
            this.member.technician_name = data.name;
            break;
          case 'referee':
            this.member.referee_name = data.id;
            this.member.referee_name_name = data.name;
            break;
          case 'designers':
            this.member.designers_id = data.id;
            this.member.designers_name = data.name;
            break;
          case 'director':
            this.member.director_employee_id = data.id;
            this.member.director_employee_name = data.name;
            break;
        }
      }
    });
    m.present();
  }

  selectMember(key: string) {
    let m = this.modalCtrl.create(MemberSelectorPage, { mode: 'single', filter: '' });
    m.onDidDismiss(data => {
      if (data) {
        this.member.parent_id = data.id;
        this.member.parent_name = data.name;
      }
    });
    m.present();
  }

  select(type: string) {
    switch (type) {
      case 'dd':
        this.modalSelector(SelectorType.DD, true, d => {
          this.member.dd_partner_id = d.id;
          this.member.dd_partner_name = d.name;
        });
        break;
      case 'dj':
        this.modalSelector(SelectorType.DJ, true, d => {
          this.member.dj_partner_id = d.id;
          this.member.dj_partner_name = d.name;
        });
        break;
      case 'dl':
        this.modalSelector(SelectorType.DL, true, d => {
          this.member.dl_partner_id = d.id;
          this.member.dl_partner_name = d.name;
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

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
