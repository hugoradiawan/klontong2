import { Injectable } from '@nestjs/common';
import { InjectConnection, InjectModel } from '@nestjs/mongoose';
import { GridFSBucket, ObjectId } from 'mongodb';
import { Connection, Model } from 'mongoose';
import { Readable } from 'node:stream';
import { Category } from './schema/category.schema';

@Injectable()
export class CategoryService {
  private gfs!: GridFSBucket;
  constructor(
    @InjectModel('Category') private categoryModel: Model<Category>,
    @InjectConnection() private readonly connection: Connection
  ) {
    this.gfs = new GridFSBucket(this.connection.db, {
      bucketName: 'icons',
    });
  }

  async create(createCategoryDto: { name: string; icon: string; color: number[] }, file: Express.Multer.File & { _id: ObjectId }): Promise<Category> {
    const readStream = new Readable();
    readStream._read = () => {};
    readStream.push(file.buffer);
    readStream.push(null);
    const newCategory = new this.categoryModel(createCategoryDto);
    const uploadStream = this.gfs.openUploadStream(file.originalname, {
      contentType: file.mimetype,
      id: new ObjectId(createCategoryDto.icon),
    });
    readStream.pipe(uploadStream);
    return newCategory.save();
  }

  async findAll(page: number, limit: number): Promise<Category[]> {
    return this.categoryModel
      .find()
      .skip((page - 1) * limit)
      .limit(limit)
      .exec();
  }

  async findById(id: string): Promise<Category | null> {
    return this.categoryModel.findById(id).exec();
  }

  async downloadIcon(id: string) {
    const objectId = new ObjectId(id);
    return this.gfs.openDownloadStream(objectId);
  }

  async getIcon(id: string) {
    const objectId = new ObjectId(id);
    return this.gfs.find({ _id: objectId}).toArray();
  }

  async update(id: string, updateCategoryDto: Partial<Category>, file: Express.Multer.File & { _id: ObjectId }, existingCategory: Category): Promise<Category | null> {
    let updatedImageId = existingCategory.icon;
    if (file) {
      const newImageId = file._id.toString();
      if (existingCategory.icon) {
        await this.gfs.delete(new ObjectId(newImageId));
      }

      updatedImageId = newImageId;
      const readStream = new Readable();
      readStream._read = () => {};
      readStream.push(file.buffer);
      readStream.push(null);
      const uploadStream = this.gfs.openUploadStream(file.originalname, {
        contentType: file.mimetype,
      });
      readStream.pipe(uploadStream);
    }
    return this.categoryModel.findByIdAndUpdate(id, {
      ...updateCategoryDto,
      icon: updatedImageId,
    }, { new: true }).exec();
  }

  async delete(id: string): Promise<any> {
    return this.categoryModel.findByIdAndDelete(id).exec();  // Use findByIdAndDelete
  }

  async searchByName(name: string, page: number, limit: number): Promise<Category[]> {
    return this.categoryModel
      .find({ name: { $regex: name, $options: 'i' } })  // Case-insensitive search
      .skip((page - 1) * limit)
      .limit(limit)
      .exec();
  }
}