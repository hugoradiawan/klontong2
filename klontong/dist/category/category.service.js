"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoryService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongodb_1 = require("mongodb");
const mongoose_2 = require("mongoose");
const node_stream_1 = require("node:stream");
let CategoryService = class CategoryService {
    constructor(categoryModel, connection) {
        this.categoryModel = categoryModel;
        this.connection = connection;
        this.gfs = new mongodb_1.GridFSBucket(this.connection.db, {
            bucketName: 'icons',
        });
    }
    async create(createCategoryDto, file) {
        const readStream = new node_stream_1.Readable();
        readStream._read = () => { };
        readStream.push(file.buffer);
        readStream.push(null);
        const newCategory = new this.categoryModel(createCategoryDto);
        const uploadStream = this.gfs.openUploadStream(file.originalname, {
            contentType: file.mimetype,
            id: new mongodb_1.ObjectId(createCategoryDto.icon),
        });
        readStream.pipe(uploadStream);
        return newCategory.save();
    }
    async findAll(page, limit) {
        return this.categoryModel
            .find()
            .skip((page - 1) * limit)
            .limit(limit)
            .exec();
    }
    async findById(id) {
        return this.categoryModel.findById(id).exec();
    }
    async downloadIcon(id) {
        const objectId = new mongodb_1.ObjectId(id);
        return this.gfs.openDownloadStream(objectId);
    }
    async getIcon(id) {
        const objectId = new mongodb_1.ObjectId(id);
        return this.gfs.find({ _id: objectId }).toArray();
    }
    async update(id, updateCategoryDto, file, existingCategory) {
        let updatedImageId = existingCategory.icon;
        if (file) {
            const newImageId = file._id.toString();
            if (existingCategory.icon) {
                await this.gfs.delete(new mongodb_1.ObjectId(newImageId));
            }
            updatedImageId = newImageId;
            const readStream = new node_stream_1.Readable();
            readStream._read = () => { };
            readStream.push(file.buffer);
            readStream.push(null);
            const uploadStream = this.gfs.openUploadStream(file.originalname, {
                contentType: file.mimetype,
            });
            readStream.pipe(uploadStream);
        }
        return this.categoryModel.findByIdAndUpdate(id, {
            ...updateCategoryDto,
            icon: updatedImageId,
        }, { new: true }).exec();
    }
    async delete(id) {
        return this.categoryModel.findByIdAndDelete(id).exec();
    }
    async searchByName(name, page, limit) {
        return this.categoryModel
            .find({ name: { $regex: name, $options: 'i' } })
            .skip((page - 1) * limit)
            .limit(limit)
            .exec();
    }
};
exports.CategoryService = CategoryService;
exports.CategoryService = CategoryService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Category')),
    __param(1, (0, mongoose_1.InjectConnection)()),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Connection])
], CategoryService);
//# sourceMappingURL=category.service.js.map