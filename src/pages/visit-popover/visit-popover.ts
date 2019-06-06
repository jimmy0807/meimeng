import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController } from 'ionic-angular';
import { VisitList } from '../visit-list/visit-list';
import { VisitFilter } from '../../providers/visit-data';

@IonicPage()
@Component({
  selector: 'page-visit-popover',
  templateUrl: 'visit-popover.html',
})
export class VisitPopoverPage {
  page: VisitList;
  f: VisitFilter = {};
  items: Item[] = [];
  keys = ['m', 'l', 't', 'e', 'p', 's'];
  todayStr: string;
  states = {
    draft: '待回访',
    done: '已回访',
    unapprove: '待修改',
    sure: '已修改',
    finish: '已完成',
    cancel: '已取消',
  }
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.page = navParams.data;
    this.f = this.page.filters;

    let j = window.localStorage.getItem('filters');
    if (j)
      this.items = JSON.parse(j);
    let d = new Date();
    this.todayStr = `${d.getFullYear()}-${this.padZero(d.getMonth() + 1)}-${this.padZero(d.getDate())}`;
  }

  ngAfterViewInit() {
  }

  clear() {
    for (let key in this.f)
      this.f[key] = null;
  }

  done() {
    this.viewCtrl.dismiss(this.f);
    this.saveFilter();
  }

  saveFilter() {
    for (let k of this.keys) {
      if (this.f[k]) {
        let v = this.f[k];
        this.items.unshift({
          key: k,
          value: v,
          display: k === 's' ? this.states[v] : v
        });
      }
    }
    let dict: string[] = [];
    let result = [];
    for (let i of this.items) {
      if (dict.indexOf(i.key + i.value) < 0) {
        result.push(i);
        dict.push(i.key + i.value);
      }
    }
    result = result.slice(0, 7);
    window.localStorage.setItem('filters', JSON.stringify(result));
  }

  hotTap(i: Item) {
    this.f[i.key] = i.value;
  }

  today() {
    this.clear();
    this.f.ds = this.todayStr;
    this.f.de = this.todayStr;
  }

  defer() {
    this.clear();
    this.f.s = 'draft';
    this.f.de = this.todayStr;
  }

  padZero(n) {
    return n < 10 ? '0' + String(n) : String(n);
  }
}

export interface Item {
  key: string;
  value: string;
  display: string;
}
