import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalPrescriptionDetail } from './medical-prescription-detail';

@NgModule({
  declarations: [
    MedicalPrescriptionDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalPrescriptionDetail),
  ],
  exports: [
    MedicalPrescriptionDetail
  ]
})
export class MedicalPrescriptionDetailModule {}
