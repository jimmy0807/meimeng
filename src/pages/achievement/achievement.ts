import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, Refresher } from 'ionic-angular';
import { CommissionData, TeamLine, Achievement } from '../../providers/commission-data';
import { AppGlobal } from '../../app-global';

@IonicPage()
@Component({
  selector: 'page-achievement',
  templateUrl: 'achievement.html',
})
export class AchievementPage {
  segment = '';
  dayList: Achievement[] = [];
  monthList: Achievement[] = [];
  rangeList: Achievement[] = [];
  teams: TeamLine[] = [];
  eid;

  daySStr: string;
  dayEStr: string;
  dayEt: number[] = [];
  dayOffset = 0;
  dayRange: string;

  monthSStr: string;
  monthEStr: string;
  monthEt: number[] = [];
  monthOffset = 0;
  monthRange: string;

  rangeSt: string;
  rangeEt: string;
  rangeMax: string;
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public commissionData: CommissionData,
    public navParams: NavParams) {
    this.eid = AppGlobal.getInstance().user.eid;
    let d = new Date();
    this.dayEt = [d.getFullYear(), d.getMonth(), d.getDate() + 1];
    this.monthEt = [d.getFullYear(), d.getMonth() + 1, 1];

    this.dayEStr = this.getDate(this.dayEt).toLocaleDateString();
    this.monthEStr = this.getDate(this.monthEt).toLocaleDateString();

    this.rangeEt = this.rangeMax = this.getDateStr(this.getDate(this.dayEt));
    this.rangeSt = this.getDateStr(new Date(d.getFullYear(), d.getMonth(), 1));
  }

  async ngAfterViewInit() {
    this.segment = 'day';
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    try {
      await this.getTeams();
      await this.getDay();
      await this.getMonth();
    }
    catch (e) {

    }
    finally {
      loader.dismiss();
    }
  }

  tabChange() {

  }

  getDate(arr: number[]) {
    return new Date(arr[0], arr[1], arr[2]);
  }

  async doRefresh(refresher: Refresher) {
    try {
      this.dayOffset = 0;
      this.monthOffset = 0;
      await this.getTeams();
      await this.getDay();
      await this.getMonth();
    }
    catch (e) {

    }
    finally {
      refresher.complete();
    }
  }

  async getTeams() {
    let r = await this.commissionData.getCommissionTeams();
    if (r.errcode === 0) {
      this.teams = r.data;
      for (let t of this.teams) {
        t.visible = t.manager_ids.indexOf(this.eid) >= 0;
        t.detail = t.employee_ids.length > 0;
      }
      this.teams.unshift({ amount: 0, id: 0, visible: false, manager_ids: [], name: '其他', parent_ids: [0], detail: false });
    }
  }

  createDict() {
    let d: TeamLine[] = new Array();
    for (let t of this.teams) {
      d[t.id] = {
        amount: 0,
        id: t.id,
        parent_ids: t.parent_ids,
        name: t.name,
        visible: t.visible,
        detail: t.detail,
        sequence: t.sequence,
      };
    }
    return d;
  }

  async getDay(refresh = true) {
    let st = new Date(this.dayEt[0], this.dayEt[1] - this.dayOffset - 1, this.dayEt[2]);
    let et = new Date(this.dayEt[0], this.dayEt[1] - this.dayOffset, this.dayEt[2]);
    let r = await this.commissionData.achievementDay(this.getDateStr(st), this.getDateStr(et));
    if (r.errcode === 0) {
      let arr = this.getAchievementList(r.data);
      this.dayList = refresh ? arr : this.dayList.concat(arr);
      this.daySStr = st.toLocaleDateString();
      this.dayOffset++;
    }
  }

  async lastMonth() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try { await this.getDay(false); }
    catch (e) { }
    finally { loader.dismiss(); }
  }

  async lastYear() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try { await this.getMonth(false); }
    catch (e) { }
    finally { loader.dismiss(); }
  }

  getAchievementList(list: Achievement[]) {
    let result: Achievement[] = [];
    for (let a of list) {
      let dict = this.createDict();
      for (let i of a.items) {
        for (let id of dict[i.id].parent_ids)
          dict[id].amount += i.amount;
      }
      let lines = dict.filter(t => t.amount && t.visible).sort((a, b) => a.sequence - b.sequence);
      if (lines.length || a.person) {
        result.push({
          date: a.date,
          items: lines,
          person: a.person,
          people: a.people
        });
      }
    }
    return result;
  }

  async getRange() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      let r = await this.commissionData.achievementRange(this.rangeSt, this.rangeEt);
      if (r.errcode === 0) {
        let arr = this.getAchievementList(r.data);
        this.rangeList = arr;
      }
    }
    catch (e) { }
    finally { loader.dismiss(); }
  }

  async getMonth(refresh = true) {
    let st = new Date(this.monthEt[0] - this.monthOffset - 1, this.monthEt[1], 1);
    let et = new Date(this.monthEt[0] - this.monthOffset, this.monthEt[1], 1);
    let r = await this.commissionData.achievementMonth(this.getDateStr(st), this.getDateStr(et));
    if (r.errcode === 0) {
      let arr = this.getAchievementList(r.data);
      this.monthList = refresh ? arr : this.monthList.concat(arr);
      this.monthSStr = st.toLocaleDateString();
      this.monthOffset++;
    }
  }

  getDateStr(d: Date) {
    return `${d.getFullYear()}-${this.padZero(d.getMonth() + 1)}-${this.padZero(d.getDate())}`;
  }

  padZero(n: number) {
    return n < 10 ? '0' + String(n) : String(n);
  }

  showTeamAchieve(a: Achievement, t: TeamLine) {
    if (!t.detail)
      return;
    let team = this.teams.find(d => d.id == t.id);
    t.employee_ids = team.employee_ids;
    this.navCtrl.push('AchievementDetailPage', { a: a, t: t });
  }
}
