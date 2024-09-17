"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategorySchema = void 0;
const mongoose_1 = require("mongoose");
exports.CategorySchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    icon: { type: String },
    color: { type: [Number], required: true },
});
//# sourceMappingURL=category.schema.js.map