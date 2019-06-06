import { Component } from '@angular/core';
import { NavController, FabContainer, NavParams, ToastController, ViewController, ModalController } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';
import { SMS } from '@ionic-native/sms';
import { CallNumber } from '@ionic-native/call-number';
import { ReservationAddPage } from '../reservation-add/reservation-add';

declare var window;

@Component({
  selector: 'page-kpi-record',
  templateUrl: 'kpi-record.html'
})
export class KpiRecordPage {

  kpi: any;
  weather = 'sunny';
  note = '';
  type = 'call';

  member: {
    id?: number,
    name?: string,
    gender?: string,
    mobile?: string,
    create_date?: number,
    last_date?: string,
  } = {};

  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    private toastCtrl: ToastController,
    public modalCtrl: ModalController,
    public kpiData: KpiData,
    public sms:SMS,
    public callNumber:CallNumber,
    public viewCtrl: ViewController) {
    if (navParams.data != undefined) {
      this.kpi = navParams.data;
    }
  }

  ngAfterViewInit() {
    this.getKpiMemberinfo();
  }

  getKpiMemberinfo() {
    let param = {
      'mid': this.kpi.member_id,
    };

    this.kpiData.getKpiMemberinfo(param).then(
      info => {
        let result: any = info;
        if (result.errcode === 0) {
          this.member = result.data;
        }
      }
    )
  }

  saveKpiRecord(is_success) {
    if (this.note === '' && is_success === 0) {
      this.showToastWithCloseButton('请输入本次预约跟进结果信息');
      return;
    }


    if (is_success == 1) {
      let item = {
        'member_id': this.member.id,
        'member_name': this.member.name,
        'telephone': this.member.mobile
      }
      let modal = this.modalCtrl.create(ReservationAddPage, item);
      modal.onDidDismiss(data => {
        if (data != undefined) {
          console.info(data);
          let param = {
            'is_success': is_success,
            'note': this.note,
            'type': this.type,
            'planning_id': this.kpi.id,
            'reservation_id': data.id,
          }
          this.kpiData.saveKpiRecord(param).then(
            info => {
              let result: any = info;
              console.info(result);
              if (result.errcode === 0) {
                this.viewCtrl.dismiss(result.data);
              }else{
                this.showToastWithCloseButton(result.errmsg)
              }
            }
          )
        }
      });
      modal.present();

    }else{
      let param = {
        'is_success': is_success,
        'note': this.note,
        'type': this.type,
        'planning_id': this.kpi.id,
        'reservation_id': 0,
      }
      this.kpiData.saveKpiRecord(param).then(
        info => {
          let result: any = info;
          console.info(result);
          if (result.errcode === 0) {
            this.viewCtrl.dismiss(result.data);
          }else{
            this.showToastWithCloseButton(result.errmsg)
          }
        }
      )
      this.viewCtrl.dismiss();
    }


  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

  call(fab: FabContainer) {
    this.callNumber.callNumber(this.member.mobile, true);
    fab.close();
  }

  message(fab: FabContainer) {
    this.sms.send(this.member.mobile, '', {
      android: {
        intent: 'INTENT'
      },
    });
    fab.close();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
