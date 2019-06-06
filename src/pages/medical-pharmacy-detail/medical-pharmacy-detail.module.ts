import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalPharmacyDetail } from './medical-pharmacy-detail';

@NgModule({
  declarations: [
    MedicalPharmacyDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalPharmacyDetail),
  ],
  exports: [
    MedicalPharmacyDetail
  ]
})
export class MedicalPharmacyDetailModule {}
