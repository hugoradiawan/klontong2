import { Schema, Document } from 'mongoose';
export declare const CategorySchema: Schema<any, import("mongoose").Model<any, any, any, any, any, any>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, {
    name: string;
    color: number[];
    icon?: string;
}, Document<unknown, {}, import("mongoose").FlatRecord<{
    name: string;
    color: number[];
    icon?: string;
}>> & import("mongoose").FlatRecord<{
    name: string;
    color: number[];
    icon?: string;
}> & {
    _id: import("mongoose").Types.ObjectId;
}>;
export interface Category extends Document {
    name: string;
    icon?: string;
    color: number[];
}
