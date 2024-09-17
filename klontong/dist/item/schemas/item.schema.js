"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ItemSchema = void 0;
const mongoose_1 = require("mongoose");
exports.ItemSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    sku: { type: String, required: true, unique: true },
    categoryName: { type: String, required: true },
    categoryId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Category', required: true },
    image: { type: String },
    weight: { type: Number, required: false },
    width: { type: Number, required: false },
    length: { type: Number, required: false },
    height: { type: Number, required: false },
    harga: { type: Number, required: true },
});
//# sourceMappingURL=item.schema.js.map