import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MemberPlanPage } from './member-plan';

@NgModule({
  declarations: [
    MemberPlanPage,
  ],
  imports: [
    IonicPageModule.forChild(MemberPlanPage),
  ],
  exports: [
    MemberPlanPage
  ]
})
export class MemberPlanPageModule {}
