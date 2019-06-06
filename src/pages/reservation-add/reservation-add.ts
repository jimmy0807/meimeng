import { Component } from '@angular/core';
import { PopoverController, ToastController, AlertController, NavParams, ActionSheetController, NavController, ModalController, ViewController } from 'ionic-angular';
import { ReservationProductPage } from '../reservation-product/reservation-product';
import { ReservationData, Reservation, ReservationTime, Time } from '../../providers/reservation-data';
import { AppGlobal } from '../../app-global';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';
import { ReservationTimePage } from '../reservation-time/reservation-time';

@Component({
  selector: 'page-reservation-add',
  templateUrl: 'reservation-add.html'
})
export class ReservationAddPage {

  isSubmit: boolean = false;
  model = 'add';
  reservation: Reservation = {};
  medical = false;
  member: any;
  minDate: string;
  minStart: string;
  minEnd: string;
  startDate: string;
  startTime: string;
  endTime: string;
  bookTime: number;
  timesList: ReservationTime[];
  allTimes: Time[] = [];
  hasConflict = false;
  state_dict = {
    draft: '草稿',
    approved: '确认生效',
    refuse: '预约失败',
    billed: '已到店',
    done: '已开单消费',
    cancel: '已取消'
  }

  changing = false;
  cache: string;

  get times() {
    if (!this.timesList)
      return [];
    let index = this.timesList.findIndex(t => t.time === this.startDate);
    if (index < 0)
      return [];
    return this.timesList[index].events;
  }

  constructor(public navParams: NavParams,
    public navCtrl: NavController,
    public viewCtrl: ViewController,
    public actionSheetCtrl: ActionSheetController,
    public popoverCtrl: PopoverController,
    public reservationData: ReservationData,
    public asCtrl: ActionSheetController,
    public alertCtrl: AlertController,
    private toastCtrl: ToastController,
    public modalCtrl: ModalController) {
    this.medical = AppGlobal.getInstance().groupMedical;
    this.bookTime = AppGlobal.getInstance().user.book_time;

    this.reservation.state_display = '新增';
    this.reservation.state = 'draft';
    this.reservation.name = '';
    this.reservation.id = 0;

    if (navParams.data && navParams.data.id) {
      this.reservation = navParams.data;
      this.model = 'edit';
    } else {
      if (navParams.data) {
        this.reservation.telephone = navParams.data.telephone;
        this.reservation.member_id = navParams.data.member_id;
        this.reservation.member_name = navParams.data.member_name;
      }
      this.model = 'add';
    }

    let now = new Date();
    this.startTime = this.getTimeStr(now);
    this.minStart = this.startTime;
    this.startDate = this.getDateStr(now);
    this.minDate = this.startDate;
    this.startChanged();
    if (this.model === 'edit') {
      let d = new Date(this.reservation.start_date.replace(/\-/g, "/"));
      this.startDate = this.getDateStr(d);
      this.startTime = this.getTimeStr(d);
      d = new Date(this.reservation.end_date.replace(/\-/g, "/"));
      this.endTime = this.getTimeStr(d);
      this.getEmployeeTimes();
    }
  }

  ngAfterViewInit() {

  }

  async getEmployeeTimes() {
    try {
      if (!(this.reservation.technician_id))
        return;
      let r = await this.reservationData.getEmployeeTimes(this.reservation.technician_id);
      if (r.errcode === 0) {
        this.timesList = r.data;
        for (let rt of this.timesList) {
          for (let t of rt.events)
            this.allTimes.push(t);
        }
      }
    } catch (e) {

    }
  }

  async dateChanged() {
    if (this.startDate > this.minDate) {
      this.minStart = '00:00';
    }
    else {
      let now = new Date();
      this.minStart = this.getTimeStr(now);
      if (this.startTime < this.minStart)
        this.startTime = this.minStart;
    }
    await this.getEmployeeTimes();
  }

  checkTime() {
    let times = this.times;
    let t: Time;
    for (var i = 0; i < times.length; i++) {
      t = times[i];
      if (t.id === this.reservation.id)
        continue;
      if ((this.startTime >= t.start && this.startTime < t.end) || (this.endTime > t.start && this.endTime <= t.end))
        return false;
    }
    return true;
  }

  startChanged() {
    this.minEnd = this.startTime;
    let t = this.startTime.split(':');
    let m = Number(t[0]) * 60 + Number(t[1]) + (this.bookTime || 30);
    this.endTime = `${this.padLeft(Math.floor(m / 60))}:${this.padLeft(m % 60)}`;
    if (this.endTime > '23:59')
      this.endTime = '23:59';
  }

  padLeft(num) {
    if (num < 10)
      return '0' + String(num);
    return String(num);
  }

  getTimeStr(d: Date) {
    return `${this.padLeft(d.getHours())}:${this.padLeft(d.getMinutes())}`;
  }

  getDateStr(d: Date) {
    return `${d.getFullYear()}-${this.padLeft(d.getMonth() + 1)}-${this.padLeft(d.getDate())}`;
  }

  onSelectProduct() {
    if (!this.reservation.products)
      this.reservation.products = [];
    if (!this.reservation.product_ids)
      this.reservation.product_ids = [];

    let modal = this.modalCtrl.create(ReservationProductPage, this.reservation);
    modal.onDidDismiss(data => {
      if (data) {
        let arr: any[] = data;
        arr.forEach(a => {
          if (this.reservation.product_ids.indexOf(a.id) < 0) {
            this.reservation.products.push(a);
          }
        })
        this.reservation.product_ids = this.reservation.products.map(i => i.id);
        this.reservation.product_names = this.reservation.products.map(i => i.name).join();
      }
    });
    modal.present();
  }

  onChangeMobile(data) {
    if (this.changing)
      return;
    if (this.cache == data)
      return;
    this.cache = data;
    if (data.length == 11) {
      this.reservationData.getMemberInfo(data, null).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.changing = true;
            this.member = data.data;
            this.reservation.member_id = this.member.id;
            this.reservation.member_name = this.member.name;
            this.reservation.technician_id = this.member.technician_id;
            this.reservation.technician_name = this.member.technician_name;
            this.reservation.product_ids = this.member.product_ids;
            this.reservation.product_names = this.member.product_names;
            this.changing = false;
          }
        }
      )
    }
  }

  onChangeName(data) {
    if (this.changing)
      return;
    if (this.cache == data)
      return;
    this.cache = data;
    this.reservationData.getMemberInfo(null, data).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.changing = true;
          this.member = data.data;
          this.reservation.member_id = this.member.id;
          this.reservation.telephone = this.member.mobile;
          this.reservation.technician_id = this.member.technician_id;
          this.reservation.technician_name = this.member.technician_name;
          this.reservation.product_ids = this.member.product_ids;
          this.reservation.product_names = this.member.product_names;
          this.changing = false;
        }
      }
    )
  }

  update() {
    this.reservation.start_date = `${this.startDate} ${this.startTime}:00`;
    this.reservation.end_date = `${this.startDate} ${this.endTime}:00`;
    this.reservationData.saveReservation(this.reservation).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.reservation.id = data.data.id;
          this.model = 'edit';
          this.showToast(data.errmsg);
          this.viewCtrl.dismiss(data.data);
        }
      }
    )
  }

  save() {
    if (this.isSubmit) {
      return;
    }

    if (!this.reservation.technician_id) {
      this.showToast('请选择预约对象');
      return;
    }

    this.reservation.start_date = `${this.startDate} ${this.startTime}:00`;
    this.reservation.end_date = `${this.startDate} ${this.endTime}:00`;

    if (!this.reservation.telephone) {
      this.showToast('请输入手机号码');
      return;
    }
    if (!/^1\d{10}$/.test(this.reservation.telephone)) {
      this.showToast("请输入正确的手机号码");
      return;
    }
    if (!this.reservation.member_name) {
      this.showToast('请输入客户姓名');
      return;
    }
    if (!this.reservation.start_date) {
      this.showToast('请选择预约时间');
      return;
    }
    if (!this.checkTime()) {
      this.showToast('预约时间存在冲突');
      return;
    }
    this.isSubmit = true;
    this.reservationData.saveReservation(this.reservation).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.reservation.id = data.data.id;
          this.reservation.state_display = '已审核';
          this.reservation.state = 'approved';
          this.model = 'edit';
          this.showToast(data.errmsg);
          this.viewCtrl.dismiss(data.data);
          this.isSubmit = false;
        } else {
          this.showToast(data.errmsg);
          this.isSubmit = false;
        }
      }
    )
  }

  updateState(id, state) {
    let data: any = { sid: 1, id: id, state: state }
    this.reservationData.updateReservationState(data).then(
      info => {
        let result: any = info;
        if (result.errcode === 0) {
          this.reservation.state = state;
          this.reservation.state_display == this.state_dict[state];
        }
        this.showToast(result.errmsg);
      },
      error => {
        alert(error);
      })
  }

  present() {
    let buttons = []
    if (this.reservation.state == 'draft') {
      buttons = [
        {
          text: '确认生效',
          handler: () => {
            this.updateState(this.reservation.id, 'approved')
          }
        },
        {
          text: '设置为无效',
          handler: () => {
            this.updateState(this.reservation.id, 'cancel')
          }
        },
        {
          text: '取消',
          handler: () => {
          }
        }
      ]

    } else if (this.reservation.state == 'approved') {
      buttons = [
        {
          text: '取消预约',
          handler: () => {
            this.updateState(this.reservation.id, 'cancel')
          }
        },
        {
          text: '设置为已到店',
          handler: () => {
            this.updateState(this.reservation.id, 'billed')
          }
        },
        {
          text: '设置为已开单消费',
          handler: () => {
            this.updateState(this.reservation.id, 'done')
          }
        },
        {
          text: '取消',
          handler: () => {
          }
        }
      ]
    }

    let actionSheet = this.asCtrl.create({
      title: '请选择操作类型',
      buttons: buttons,
    });

    actionSheet.present();
  }

  select(type: string) {
    switch (type) {
      case 'designer':
        this.modalSelector(SelectorType.Designer, true, d => {
          this.reservation.designers_id = d.id;
          this.reservation.designers_name = d.name;
        });
        break;
      case 'designers_service':
        this.modalSelector(SelectorType.Designer, true, d => {
          this.reservation.designers_service_id = d.id;
          this.reservation.designers_service_name = d.name;
        });
        break;
      case 'director':
        this.modalSelector(SelectorType.Director, true, d => {
          this.reservation.director_employee_id = d.id;
          this.reservation.director_employee_name = d.name;
        });
        break;
      case 'doctor':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.reservation.doctor_id = d.id;
          this.reservation.doctor_name = d.name;
        });
        break;
      case 'employee':
        this.modalSelector(SelectorType.BookEmployee, true, d => {
          this.reservation.technician_id = d.id;
          this.reservation.technician_name = d.name;
          this.bookTime = d.book_time || 30;
          this.startChanged();
          this.getEmployeeTimes();
        });
        break;
    }
  }

  showTimes() {
    if (!this.reservation.technician_id) {
      this.showToast('请选择预约对象');
      return;
    }
    let m = this.modalCtrl.create(ReservationTimePage, { date: this.startDate, times: this.times }, {
      showBackdrop: true,
      enableBackdropDismiss: true,
      cssClass: 'modal-half',
    });
    m.onDidDismiss(d => {
      if (d) {
        this.startTime = d;
        this.startChanged();
      }
    })
    m.present();
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
  }

  showToast(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }


  dismiss() {
    this.viewCtrl.dismiss();
  }
}
