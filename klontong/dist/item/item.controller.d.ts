import { Response } from 'express';
import { ObjectId } from 'mongodb';
import { GridFsService } from '../gridfs/gridfs.service';
import { ItemService } from './item.service';
export declare class ItemController {
    private readonly itemService;
    private readonly gridFsService;
    private gfs;
    constructor(itemService: ItemService, gridFsService: GridFsService);
    create(file: Express.Multer.File & {
        _id: ObjectId;
    }, createItemDto: {
        name: string;
        description: string;
        sku: string;
        categoryName: string;
        categoryId: string;
        weight?: number;
        width?: number;
        length?: number;
        height?: number;
        harga: number;
    }, res: Response): Promise<Response<any, Record<string, any>>>;
    findAll(data: {
        page?: number;
        limit?: number;
    }, response: Response): Promise<Response<any, Record<string, any>>>;
    findOne(id: string): Promise<import("./schemas/item.schema").Item>;
    remove(id: string): Promise<any>;
    search(name: string, page?: number, limit?: number): Promise<import("./schemas/item.schema").Item[]>;
    update(id: string, updateItemDto: Partial<{
        name: string;
        description: string;
        sku: string;
        categoryName: string;
        categoryId: string;
        weight?: number;
        width?: number;
        length?: number;
        height?: number;
        harga: number;
    }>, file?: Express.Multer.File & {
        _id: ObjectId;
    }): Promise<import("./schemas/item.schema").Item>;
    displayImage(id: string, res: Response): Promise<void>;
}
