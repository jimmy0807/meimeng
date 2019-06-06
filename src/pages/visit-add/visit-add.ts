import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, LoadingController, ModalController, ViewController } from 'ionic-angular';
import { Visit, VisitData, VisitNote, VisitPlan } from '../../providers/visit-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';
import { AppGlobal } from '../../app-global';

@IonicPage()
@Component({
  selector: 'page-visit-add',
  templateUrl: 'visit-add.html',
})
export class VisitAddPage {
  v: Visit = {};
  title = '';
  addMode = true;
  readonly = false;
  states = [];
  isAdmin = false;
  eid;
  holder1 = '请输入';
  holder2 = '请选择';
  cat_dict = {
    'potential': '潜在客户跟进',
    'operate': '术后回访',
    'problem': '问题客户术后回访',
    'other': '其他',
  }
  navData: { vid, note: VisitNote, list };
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public modalCtrl: ModalController,
    public visitData: VisitData,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.eid = AppGlobal.getInstance().user.eid;
    let ug = AppGlobal.getInstance().userGroup;
    if (ug)
      this.isAdmin = ug.sel_groups_103_104 === '经理'

    this.navData = navParams.data;
    if (navParams.data.cat)
      this.v.category = navParams.data.cat;

  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      if (this.navData && this.navData.vid) {
        let r = await this.visitData.getVisit(this.navData.vid);
        if (r.errcode === 0) {
          this.v = r.data;
          let index = this.v.note_ids.findIndex(n => n.id === this.navData.note.id);
          this.v.note_ids[index] = this.navData.note;
        }
      }
      if (this.v.id) {
        this.title = '回访内容';
        this.addMode = false;
        this.readonly = true;
      }
      else {
        this.v.state = 'draft';
        this.v.category_name = this.cat_dict[this.v.category];
        this.v.note_ids = [];
        this.v.plan_ids = [];
        switch (this.v.category) {
          case 'operate': this.title = '新建术后回访'; break;
          case 'problem': this.title = '问题客术后回访'; break;
        }
      }

      if (this.readonly) {
        this.holder1 = this.holder2 = '';
      }

      if (this.v.category === 'problem') {
        let r = await this.visitData.getDoStates();
        if (r.errcode === 0)
          this.states = r.data;
      }
    }
    finally {
      loader.dismiss();
    }
  }

  async save() {
    if (!this.v.member_id) {
      this.showToast('请选择会员');
      return;
    }
    if (!this.v.name) {
      this.showToast('请输入主题');
      return;
    }
    if (!this.v.operate_id) {
      this.showToast('请选择治疗记录');
      return;
    }
    let r = await this.visitData.saveVisit(this.v);
    if (r.errcode == 0)
      this.viewCtrl.dismiss();
    else
      this.showToast(r.errmsg);
  }

  addNote() {
    this.navCtrl.push('VisitNotePage', { v: this.v });
  }

  showNote(n: VisitNote) {
    //if (n.employee_id !== this.eid && !this.isAdmin)
    //  return;
    this.navCtrl.push('VisitNotePage', { v: this.v, n: n, list: this.navData.list })
  }

  async delNote(n: VisitNote) {
    if (n.id) {
      let r = await this.visitData.deleteVisitNote(n.id);
      this.showToast(r.errmsg);
      if (r.errcode != 0)
        return;
    }
    let index = this.v.note_ids.indexOf(n);
    this.v.note_ids.splice(index, 1);
  }

  addPlan() {
    this.navCtrl.push('VisitTextPage', { v: this.v, prob: true });
  }

  showPlan(p: VisitPlan) {
    this.navCtrl.push('VisitTextPage', { v: this.v, p: p, prob: true });
  }

  async delPlan(p: VisitPlan) {
    if (p.id) {
      let r = await this.visitData.deleteVisitPlan(p.id);
      this.showToast(r.errmsg);
      if (r.errcode != 0)
        return;
    }
    let index = this.v.note_ids.indexOf(p);
    this.v.note_ids.splice(index, 1);
  }

  done() {
    if (this.v.note_ids) {
      if (this.v.note_ids.some(n => n.state != 'finish')) {
        this.showToast('尚有未完成的任务');
        return;
      }
    }
    this.navCtrl.push('VisitTextPage', { v: this.v, prob: false });
  }

  select(type: string) {
    if (this.readonly)
      return;

    switch (type) {
      case 'team':
        this.modalSelector(SelectorType.CommissionTeam, true, d => {
          this.v.team_id = d.id;
          this.v.team_name = d.name;
        });
        break;
      case 'member':
        this.modalSelector(SelectorType.Member, true, d => {
          this.v.member_id = d.id;
          this.v.member_name = d.name;
          this.v.mobile = d.display_mobile;
          this.v.shop_name = d.shop_name;
        });
        break;
      case 'operate':
        if (!this.v.member_id) {
          this.showToast('请选择会员');
          return;
        }
        this.modalSelector(SelectorType.VisitOperate, true, d => {
          this.v.operate_id = d.id;
          this.v.operate_name = d.name;
          this.v.operate_create_date = d.create_date;
          this.v.consume_amount = d.now_amount;
        }, this.v.member_id);
        break;
      case 'question':
        this.modalSelector(SelectorType.VisitQuestion, false, d => {
          this.v.operate_question_ids = d;
          this.v.question_names = this.v.operate_question_ids.map(i => i.name).join(',');
        });
        break;
      case 'user':
        this.modalSelector(SelectorType.User, true, d => {
          this.v.authorizer_id = d.id;
          this.v.authorizer_name = d.name;
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

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
