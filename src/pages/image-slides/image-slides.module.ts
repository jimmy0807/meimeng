import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { ImageSlidesPage } from './image-slides';

@NgModule({
  declarations: [
    ImageSlidesPage,
  ],
  imports: [
    IonicPageModule.forChild(ImageSlidesPage),
  ],
  exports: [
    ImageSlidesPage
  ]
})
export class ImageSlidesPageModule {}
