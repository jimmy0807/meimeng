import { Component } from '@angular/core';
import { NavController, ToastController, NavParams, ViewController, ActionSheetController, ModalController } from 'ionic-angular';
import { VisitData, Visit, VisitNote } from '../../providers/visit-data';
import { ReservationAddPage } from '../reservation-add/reservation-add';
import { Camera } from '@ionic-native/camera';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-visit',
  templateUrl: 'visit.html'
})
export class VisitPage {
  v: Visit;
  member: {
    id?: number,
    name?: string,
    mobile?: string,
    member_name?: string,
  } = {};
  mid: number;
  groupMedical;
  segment = 'normal';
  levels = [];
  advisories = [];
  customers = []
  operates = [];
  users = [];
  isAdmin = false;
  readonly = false;
  adminMode = false;
  constructor(
    public navParams: NavParams,
    public camera: Camera,
    public asCtrl: ActionSheetController,
    private toastCtrl: ToastController,
    public visitData: VisitData,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public navCtrl: NavController) {
    let user = AppGlobal.getInstance().user;
    this.isAdmin = user.role == '1' || user.role == '2' || user.role == '3';
    if (navParams.data) {
      let d = navParams.data;
      if (d.v) {
        this.v = d.v;
        this.readonly = true;
        this.adminMode = this.isAdmin;
        //this.visit.added_images = [];
        //this.visit.deleted_images = [];
        //if (!this.visit.visit_image_ids)
        //  this.visit.visit_image_ids = [];
      }
    }
  }

  async ngAfterViewInit() {
    if (!this.groupMedical)
      return;
    if (this.readonly)
      return;
    try {
      let r = await this.visitData.getVisitLevels();
      if (r.errcode === 0)
        this.levels = r.data;
      r = await this.visitData.getMedicalAdvisory(this.mid);
      if (r.errcode === 0)
        this.advisories = r.data;
      r = await this.visitData.getMedicalCustomers();
      if (r.errcode === 0)
        this.customers = r.data;
      r = await this.visitData.getMedicalOperate(this.mid);
      if (r.errcode === 0)
        this.operates = r.data;
      r = await this.visitData.getMedicalUsers();
      if (r.errcode === 0)
        this.users = r.data;
    }
    catch (e) {

    }
  }

  showNote(n: VisitNote) {
    if (n.employee_id === AppGlobal.getInstance().user.eid)
      this.navCtrl.push('VisitNotePage', n);
  }

  reserve() {
    let item = {
      'member_id': this.member.id,
      'member_name': this.member.member_name,
      'telephone': this.member.mobile
    }
    this.navCtrl.push(ReservationAddPage, item);
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
