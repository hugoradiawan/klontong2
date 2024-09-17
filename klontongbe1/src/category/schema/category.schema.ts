import { Schema, Document } from 'mongoose';

export const CategorySchema = new Schema({
  name: { type: String, required: true },
  icon: { type: String },
  color: { type: [Number], required: true },
});

export interface Category extends Document {
  name: string;
  icon?: string;
  color: number[];
}