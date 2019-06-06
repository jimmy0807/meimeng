import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalWardDetail } from './medical-ward-detail';

@NgModule({
  declarations: [
    MedicalWardDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalWardDetail),
  ],
  exports: [
    MedicalWardDetail
  ]
})
export class MedicalWardDetailModule {}
