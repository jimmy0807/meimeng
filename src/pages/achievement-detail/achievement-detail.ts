import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { Achievement, TeamLine } from '../../providers/commission-data';
@IonicPage()
@Component({
  selector: 'page-achievement-detail',
  templateUrl: 'achievement-detail.html',
})
export class AchievementDetailPage {
  title = '';
  a: Achievement;
  t: TeamLine;
  list = [];
  constructor(public navCtrl: NavController,
    public navParams: NavParams) {
    this.a = navParams.data.a;
    this.t = navParams.data.t;
    this.title = this.t.name;
  }

  ngAfterViewInit() {
    let list = [];
    for (let e of this.t.employee_ids) {
      list.push({
        name: e.name,
        amount: this.a.people['e_' + e.id] || 0
      });
    }
    this.list = list.sort((a, b) => b.amount - a.amount);
  }
}
