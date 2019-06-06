import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalWorkflowActivity } from './medical-workflow-activity';

@NgModule({
  declarations: [
    MedicalWorkflowActivity,
  ],
  imports: [
    IonicPageModule.forChild(MedicalWorkflowActivity),
  ],
  exports: [
    MedicalWorkflowActivity
  ]
})
export class MedicalWorkflowActivityModule {}
