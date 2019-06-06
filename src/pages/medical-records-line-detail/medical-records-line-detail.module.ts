import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalRecordsLineDetail } from './medical-records-line-detail';

@NgModule({
  declarations: [
    MedicalRecordsLineDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalRecordsLineDetail),
  ],
  exports: [
    MedicalRecordsLineDetail
  ]
})
export class MedicalRecordsLineDetailModule {}
