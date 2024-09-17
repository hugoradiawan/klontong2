import { Injectable } from '@nestjs/common';
import { InjectConnection, InjectModel } from '@nestjs/mongoose';
import { GridFSBucket, ObjectId } from 'mongodb';
import { Connection, Model } from 'mongoose';
import { Readable } from 'node:stream';
import { Item } from './schemas/item.schema';

@Injectable()
export class ItemService {
  private gfs!: GridFSBucket;
  constructor(
    @InjectModel('Item') private itemModel: Model<Item>,
    @InjectConnection() private readonly connection: Connection
  ) {
    this.gfs = new GridFSBucket(this.connection.db, {
      bucketName: 'items',
    });
  }

  async create(createItemDto: Partial<Item>, file: Express.Multer.File & { _id: ObjectId }): Promise<Item> {
    const readStream = new Readable();
    readStream._read = () => {};
    readStream.push(file.buffer);
    readStream.push(null);
    const newItem = new this.itemModel(createItemDto);
    const uploadStream = this.gfs.openUploadStream(file.originalname, {
      contentType: file.mimetype,
      id: new ObjectId(createItemDto.image),
    });
    readStream.pipe(uploadStream);
    return newItem.save();
  }

  async findAll(page: number, limit: number): Promise<Item[]> {
    return this.itemModel
      .find()
      .skip((page - 1) * limit)
      .limit(limit)
      .exec();
  }

  async findById(id: string): Promise<Item | null> {
    return this.itemModel.findById(id).exec();
  }

  async update(id: string, updateItemDto: Partial<Item>): Promise<Item | null> {
    return this.itemModel.findByIdAndUpdate(id, updateItemDto, { new: true }).exec();
  }

  async delete(id: string): Promise<any> {
    return this.itemModel.findByIdAndDelete(id).exec();
  }

  async searchByName(name: string, page: number, limit: number): Promise<Item[]> {
    return this.itemModel
      .find({ name: { $regex: name, $options: 'i' } })
      .skip((page - 1) * limit)
      .limit(limit)
      .exec();
  }

  async getImage(id: string) {
    const objectId = new ObjectId(id);
    return this.gfs.find({ _id: objectId}).toArray();
  }

  async downloadImage(id: string) {
    const objectId = new ObjectId(id);
    return this.gfs.openDownloadStream(objectId);
  }
}