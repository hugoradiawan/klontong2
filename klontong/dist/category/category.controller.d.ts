import { CategoryService } from './category.service';
import { ObjectId } from 'mongodb';
import { Response } from 'express';
import { Category } from './schema/category.schema';
export declare class CategoryController {
    private readonly categoryService;
    constructor(categoryService: CategoryService);
    create(file: Express.Multer.File & {
        _id: ObjectId;
    }, createCategoryDto: {
        name: string;
        color: string;
    }, res: Response): Promise<Response<any, Record<string, any>>>;
    findAll(data: {
        page: number;
        limit: number;
    }, response: Response): Promise<Response<any, Record<string, any>>>;
    findOne(id: string): Promise<Category>;
    remove(id: string): Promise<any>;
    search(name: string, page?: number, limit?: number): Promise<Category[]>;
    update(id: string, updateItemDto: Partial<Category>, file?: Express.Multer.File & {
        _id: ObjectId;
    }): Promise<Category>;
    displayImage(id: string, res: Response): Promise<void>;
}
