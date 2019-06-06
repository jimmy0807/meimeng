import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalRecordsDetail } from './medical-records-detail';

@NgModule({
  declarations: [
    MedicalRecordsDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalRecordsDetail),
  ],
  exports: [
    MedicalRecordsDetail
  ]
})
export class MedicalRecordsDetailModule {}
