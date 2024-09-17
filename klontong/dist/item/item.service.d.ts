import { ObjectId } from 'mongodb';
import { Connection, Model } from 'mongoose';
import { Item } from './schemas/item.schema';
export declare class ItemService {
    private itemModel;
    private readonly connection;
    private gfs;
    constructor(itemModel: Model<Item>, connection: Connection);
    create(createItemDto: Partial<Item>, file: Express.Multer.File & {
        _id: ObjectId;
    }): Promise<Item>;
    findAll(page: number, limit: number): Promise<Item[]>;
    findById(id: string): Promise<Item | null>;
    update(id: string, updateItemDto: Partial<Item>): Promise<Item | null>;
    delete(id: string): Promise<any>;
    searchByName(name: string, page: number, limit: number): Promise<Item[]>;
    getImage(id: string): Promise<import("mongodb").GridFSFile[]>;
    downloadImage(id: string): Promise<import("mongodb").GridFSBucketReadStream>;
}
