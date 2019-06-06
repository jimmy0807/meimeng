import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MemberPlanProductPage } from './member-plan-product';

@NgModule({
  declarations: [
    MemberPlanProductPage,
  ],
  imports: [
    IonicPageModule.forChild(MemberPlanProductPage),
  ],
  exports: [
    MemberPlanProductPage
  ]
})
export class MemberPlanProductPageModule {}
