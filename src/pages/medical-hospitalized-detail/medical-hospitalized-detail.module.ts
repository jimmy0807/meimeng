import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalHospitalizedDetail } from './medical-hospitalized-detail';

@NgModule({
  declarations: [
    MedicalHospitalizedDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalHospitalizedDetail),
  ],
  exports: [
    MedicalHospitalizedDetail
  ]
})
export class MedicalHospitalizedDetailModule {}
