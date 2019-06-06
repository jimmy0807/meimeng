import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { CommissionLevel } from './commission-level';

@NgModule({
  declarations: [
    CommissionLevel,
  ],
  imports: [
    IonicPageModule.forChild(CommissionLevel),
  ],
  exports: [
    CommissionLevel
  ]
})
export class CommissionLevelModule {}
