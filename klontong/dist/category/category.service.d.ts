import { ObjectId } from 'mongodb';
import { Connection, Model } from 'mongoose';
import { Category } from './schema/category.schema';
export declare class CategoryService {
    private categoryModel;
    private readonly connection;
    private gfs;
    constructor(categoryModel: Model<Category>, connection: Connection);
    create(createCategoryDto: {
        name: string;
        icon: string;
        color: number[];
    }, file: Express.Multer.File & {
        _id: ObjectId;
    }): Promise<Category>;
    findAll(page: number, limit: number): Promise<Category[]>;
    findById(id: string): Promise<Category | null>;
    downloadIcon(id: string): Promise<import("mongodb").GridFSBucketReadStream>;
    getIcon(id: string): Promise<import("mongodb").GridFSFile[]>;
    update(id: string, updateCategoryDto: Partial<Category>, file: Express.Multer.File & {
        _id: ObjectId;
    }, existingCategory: Category): Promise<Category | null>;
    delete(id: string): Promise<any>;
    searchByName(name: string, page: number, limit: number): Promise<Category[]>;
}
