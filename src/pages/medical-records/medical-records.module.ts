import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalRecords } from './medical-records';

@NgModule({
  declarations: [
    MedicalRecords,
  ],
  imports: [
    IonicPageModule.forChild(MedicalRecords),
  ],
  exports: [
    MedicalRecords
  ]
})
export class MedicalRecordsModule {}
