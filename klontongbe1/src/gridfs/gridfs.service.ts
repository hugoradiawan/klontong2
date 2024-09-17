import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { GridFSBucket, ObjectId } from 'mongodb';
import { Connection } from 'mongoose';

@Injectable()
export class GridFsService {
  private gridFsBucket: GridFSBucket;

  constructor(@InjectConnection() private readonly connection: Connection) {
    this.gridFsBucket = new GridFSBucket(this.connection.db, { bucketName: 'icons' });
  }

  async findById(id: string) {
    const objectId = new ObjectId(id);
    return this.gridFsBucket.find({ _id: objectId}).toArray();
  }

  openDownloadStream(id: string) {
    const objectId = new ObjectId(id);
    return this.gridFsBucket.openDownloadStream(objectId);
  }

  async deleteFile(id: string): Promise<String> {
    const objectId = new ObjectId(id);
    await this.gridFsBucket.delete(objectId);
    return objectId.toString();
  }
}