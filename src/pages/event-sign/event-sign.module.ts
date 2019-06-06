import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { EventSignPage } from './event-sign';
import { SafePipe } from '../../pipes/safe/safe';

@NgModule({
  declarations: [
    EventSignPage,
    SafePipe,
  ],
  imports: [
    IonicPageModule.forChild(EventSignPage),
  ],
  exports: [
    EventSignPage
  ]
})
export class EventSignPageModule { }
