import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, ModalController, ViewController } from 'ionic-angular';
import { MemberData, Card, PadOrder, PadOrderLine, CardLine } from '../../providers/member-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';
import { AppGlobal } from '../../app-global';

@IonicPage()
@Component({
  selector: 'page-member-plan',
  templateUrl: 'member-plan.html',
})
export class MemberPlanPage {
  mid: number;
  title: string;
  cards: Card[] = [];
  p: PadOrder = {};
  list: PadOrder[] = [];
  constructor(public navCtrl: NavController,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public memberData: MemberData,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    let u = AppGlobal.getInstance().user;

    this.list = navParams.data.list;
    if (navParams.data.order) {
      this.p = navParams.data.order;
      this.mid = this.p.member_id;
      this.title = this.p.member_name;
    }
    else {
      this.mid = navParams.data.mid;
      this.title = navParams.data.name;
      this.p = {
        member_id: this.mid,
        member_name: this.title,
        lines: [],
        card_lines: [],
        pad_order_line_ids: [],
      }
      if (u.ecat === 'designers') {
        this.p.designers_id = u.eid;
        this.p.designers_name = u.ename;
      }
    }
  }

  ngAfterViewInit() {

  }

  async save() {
    if (!this.p.card_lines.length && !this.p.lines.length && !this.p.remark) {
      this.showToast('请选择项目或填写备注');
      return;
    }

    try {
      let r = await this.memberData.savePadOrder(this.p);
      this.showToast(r.errmsg);
      if (r.errcode === 0) {
        this.p.no = r.data.no;
        this.p.line_names = r.data.line_names;
        if (!this.p.id) {
          this.p.id = r.data.id;
          if (this.list)
            this.list.unshift(this.p);
          if (this.navParams.data.p)
            this.navParams.data.p.is_consume = true;
        }
        this.dismiss();
      }
    }
    catch (e) {
      this.showToast();
    }
  }

  add() {
    let m = this.modalCtrl.create('MemberPlanProductPage', { mid: this.mid });
    m.onDidDismiss(data => {
      if (data) {
        let clines = <CardLine[]>data.card;
        let lines = <CardLine[]>data.prd;

        for (var i = 0; i < clines.length; i++) {
          this.addCardItem(this.p.card_lines, clines[i]);
        }

        for (var i = 0; i < lines.length; i++) {
          this.addItem(this.p.lines, lines[i]);
        }
      }
    });
    m.present();
  }

  addCardItem(list: PadOrderLine[], line: CardLine) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].born_product_id === line.id) {
        list[i].qty++;
        return;
      }
    }
    list.push({
      born_product_id: line.id,
      product_id: line.product_id,
      qty: 1,
      open_price: line.price_unit,
      name: line.name,
      limit: line.remain_qty,
    });
  }

  addItem(list: PadOrderLine[], line: CardLine) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].product_id === line.id) {
        list[i].qty++;
        return;
      }
    }
    list.push({
      born_product_id: 0,
      product_id: line.id,
      qty: 1,
      open_price: line.lst_price,
      name: line.name,
    });
  }

  addQty(i: PadOrderLine) {
    if (i.limit && i.qty == i.limit)
      return;
    i.qty++;
  }

  minusQty(i: PadOrderLine) {
    i.qty--;
    if (i.qty === 0) {
      if (i.born_product_id) {
        let index = this.p.card_lines.indexOf(i);
        this.p.card_lines.splice(index, 1);
      }
      else {
        let index = this.p.lines.indexOf(i);
        this.p.lines.splice(index, 1);
      }
    }
  }

  select(type: string) {
    switch (type) {
      case 'employee':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.p.employee_id = d.id;
          this.p.employee_name = d.name;
        });
        break;
      case 'designers':
        this.modalSelector(SelectorType.Designer, true, d => {
          this.p.designers_id = d.id;
          this.p.designers_name = d.name;
        });
        break;
      case 'doctor':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.p.doctor_id = d.id;
          this.p.doctor_name = d.name;
        });
        break;
      case 'director':
        this.modalSelector(SelectorType.Director, true, d => {
          this.p.director_employee_id = d.id;
          this.p.director_employee_name = d.name;
        });
        break;
      case 'department':
        this.modalSelector(SelectorType.Department, true, d => {
          this.p.departments_id = d.id;
          this.p.departments_name = d.name;
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
    let toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
