import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalPharmacy } from './medical-pharmacy';

@NgModule({
  declarations: [
    MedicalPharmacy,
  ],
  imports: [
    IonicPageModule.forChild(MedicalPharmacy),
  ],
  exports: [
    MedicalPharmacy
  ]
})
export class MedicalPharmacyModule {}
