import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalDepartmentDetail } from './medical-department-detail';

@NgModule({
  declarations: [
    MedicalDepartmentDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalDepartmentDetail),
  ],
  exports: [
    MedicalDepartmentDetail
  ]
})
export class MedicalDepartmentDetailModule {}
