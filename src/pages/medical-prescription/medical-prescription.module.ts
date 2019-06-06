import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalPrescription } from './medical-prescription';

@NgModule({
  declarations: [
    MedicalPrescription,
  ],
  imports: [
    IonicPageModule.forChild(MedicalPrescription),
  ],
  exports: [
    MedicalPrescription
  ]
})
export class MedicalPrescriptionModule {}
