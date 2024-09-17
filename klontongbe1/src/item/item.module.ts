import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ItemService } from './item.service';
import { ItemController } from './item.controller';
import { ItemSchema } from './schemas/item.schema';
import { GridFsService } from '../gridfs/gridfs.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Item', schema: ItemSchema }]),
  ],
  providers: [ItemService, GridFsService],
  controllers: [ItemController],
})
export class ItemModule {}