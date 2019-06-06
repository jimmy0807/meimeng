import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalVisitLevel } from './medical-visit-level';

@NgModule({
  declarations: [
    MedicalVisitLevel,
  ],
  imports: [
    IonicPageModule.forChild(MedicalVisitLevel),
  ],
  exports: [
    MedicalVisitLevel
  ]
})
export class MedicalVisitLevelModule {}
