import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController } from 'ionic-angular';
import { VisitPlan, Visit, VisitData } from '../../providers/visit-data';

@IonicPage()
@Component({
  selector: 'page-visit-text',
  templateUrl: 'visit-text.html',
})
export class VisitTextPage {
  title = '';
  probMode = true;
  p: VisitPlan;
  v: Visit;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public visitData: VisitData,
    public navParams: NavParams) {
    this.probMode = navParams.data.prob;
    this.v = navParams.data.v;
    this.p = navParams.data.p || {};
    if (!this.p.visit_date) {
      let d = new Date();
      this.p.visit_date = `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;
    }
    this.title = this.probMode ? '问题客应对方案' : '审核确认';
  }

  ngAfterViewInit() {
  }

  async save() {
    if (this.p.id) {
      let r = await this.visitData.saveVisitPlan(this.p);
      this.showToast(r.errmsg);
      if (r.errcode == 0)
        this.dismiss();
    }
    else if (this.v.id) {
      this.p.visit_id = this.v.id;
      let r = await this.visitData.saveVisitPlan(this.p);
      this.showToast(r.errmsg);
      if (r.errcode == 0) {
        this.p.id = r.data.id;
        this.v.plan_ids.push(this.p);
        this.dismiss();
      }
    }
    else {
      if (this.v.plan_ids.indexOf(this.p) < 0)
        this.v.plan_ids.push(this.p);
      this.viewCtrl.dismiss();
    }
  }

  async done() {
    let r = await this.visitData.finishVisit(this.v);
    if (r.errcode === 0) {
      this.v.state = 'finish';
      this.v.state_name = '已完成';
      this.viewCtrl.dismiss();
    }
    else {
      this.showToast(r.errmsg);
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
