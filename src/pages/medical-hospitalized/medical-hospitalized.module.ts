import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalHospitalized } from './medical-hospitalized';

@NgModule({
  declarations: [
    MedicalHospitalized,
  ],
  imports: [
    IonicPageModule.forChild(MedicalHospitalized),
  ],
  exports: [
    MedicalHospitalized
  ]
})
export class MedicalHospitalizedModule {}
