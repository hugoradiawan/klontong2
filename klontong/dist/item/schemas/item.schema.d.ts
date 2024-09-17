import { Schema, Document } from 'mongoose';
export declare const ItemSchema: Schema<any, import("mongoose").Model<any, any, any, any, any, any>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, {
    name: string;
    description: string;
    sku: string;
    categoryName: string;
    categoryId: import("mongoose").Types.ObjectId;
    harga: number;
    length?: number;
    image?: string;
    weight?: number;
    width?: number;
    height?: number;
}, Document<unknown, {}, import("mongoose").FlatRecord<{
    name: string;
    description: string;
    sku: string;
    categoryName: string;
    categoryId: import("mongoose").Types.ObjectId;
    harga: number;
    length?: number;
    image?: string;
    weight?: number;
    width?: number;
    height?: number;
}>> & import("mongoose").FlatRecord<{
    name: string;
    description: string;
    sku: string;
    categoryName: string;
    categoryId: import("mongoose").Types.ObjectId;
    harga: number;
    length?: number;
    image?: string;
    weight?: number;
    width?: number;
    height?: number;
}> & {
    _id: import("mongoose").Types.ObjectId;
}>;
export interface Item extends Document {
    name: string;
    description: string;
    sku: string;
    categoryName: string;
    categoryId: string;
    image?: string;
    weight?: number;
    width?: number;
    length?: number;
    height?: number;
    harga: number;
}
