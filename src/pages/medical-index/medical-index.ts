import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { MedicalAdvisoryPage } from '../medical-advisory/medical-advisory';
import { MedicalCustomerPage } from '../medical-customer/medical-customer';
import { MedicalSplitPage } from '../medical-split/medical-split';
import { EmployeeListPage } from '../employee-list/employee-list';
import { PartnerPage } from '../partner/partner';

@Component({
  selector: 'page-medical-index',
  templateUrl: 'medical-index.html'
})
export class MedicalIndexPage {
  segment = 'adv';
  constructor(public navCtrl: NavController,
    public navParams: NavParams) { }

  show(type) {
    switch (type) {
      case 'cus': this.navCtrl.push(MedicalCustomerPage); break;
      case 'adv': this.navCtrl.push(MedicalAdvisoryPage); break;
      case 'spl': this.navCtrl.push(MedicalSplitPage); break;

      case 'doc': this.navCtrl.push(EmployeeListPage, { cat: 'doctors' }); break;
      case 'nur': this.navCtrl.push(EmployeeListPage, { cat: 'operater' }); break;
      case 'war': this.navCtrl.push("MedicalWard"); break;
      case 'bed': this.navCtrl.push("MedicalBed"); break;
      case 'hos': this.navCtrl.push("MedicalHospitalized"); break;
      case 'records': this.navCtrl.push("MedicalRecords"); break;
      case 'ope': this.navCtrl.push('MedicalOperate'); break;

      case 'par': this.navCtrl.push(PartnerPage); break;
      case 'com': this.navCtrl.push("CommissionLevel"); break;

      case 'act': this.navCtrl.push("MedicalWorkflowActivity"); break;
      case 'flw': this.navCtrl.push("MedicalWorkflow"); break;
      case 'dep': this.navCtrl.push("MedicalDepartment"); break;

      case 'lev': this.navCtrl.push('MedicalVisitLevel'); break;
      case 'cat': this.navCtrl.push("MedicalAdvisoryCategory"); break;
      case 'tag': this.navCtrl.push("MedicalTags"); break;
      case 'typ': this.navCtrl.push("MedicalType"); break;

      case 'prescription': this.navCtrl.push("MedicalPrescription"); break;
      case 'pharmacy': this.navCtrl.push("MedicalPharmacy"); break;
    }
  }
}
