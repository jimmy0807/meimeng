import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MemberSourceinfoPage } from './member-sourceinfo';

@NgModule({
  declarations: [
    MemberSourceinfoPage,
  ],
  imports: [
    IonicPageModule.forChild(MemberSourceinfoPage),
  ],
  exports: [
    MemberSourceinfoPage
  ]
})
export class MemberSourceinfoPageModule {}
