import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalHospitalizedLine } from './medical-hospitalized-line';

@NgModule({
  declarations: [
    MedicalHospitalizedLine,
  ],
  imports: [
    IonicPageModule.forChild(MedicalHospitalizedLine),
  ],
  exports: [
    MedicalHospitalizedLine
  ]
})
export class MedicalHospitalizedLineModule {}
