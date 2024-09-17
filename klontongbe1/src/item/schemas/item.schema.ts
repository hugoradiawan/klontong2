import { Schema, Document } from 'mongoose';

export const ItemSchema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  sku: { type: String, required: true, unique: true },
  categoryName: { type: String, required: true },
  categoryId: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
  image: { type: String },
  weight: { type: Number, required: false },
  width: { type: Number, required: false },
  length: { type: Number, required: false },
  height: { type: Number, required: false },
  harga: { type: Number, required: true },
});

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