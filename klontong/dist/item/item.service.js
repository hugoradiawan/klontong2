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
exports.ItemService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongodb_1 = require("mongodb");
const mongoose_2 = require("mongoose");
const node_stream_1 = require("node:stream");
let ItemService = class ItemService {
    constructor(itemModel, connection) {
        this.itemModel = itemModel;
        this.connection = connection;
        this.gfs = new mongodb_1.GridFSBucket(this.connection.db, {
            bucketName: 'items',
        });
    }
    async create(createItemDto, file) {
        const readStream = new node_stream_1.Readable();
        readStream._read = () => { };
        readStream.push(file.buffer);
        readStream.push(null);
        const newItem = new this.itemModel(createItemDto);
        const uploadStream = this.gfs.openUploadStream(file.originalname, {
            contentType: file.mimetype,
            id: new mongodb_1.ObjectId(createItemDto.image),
        });
        readStream.pipe(uploadStream);
        return newItem.save();
    }
    async findAll(page, limit) {
        return this.itemModel
            .find()
            .skip((page - 1) * limit)
            .limit(limit)
            .exec();
    }
    async findById(id) {
        return this.itemModel.findById(id).exec();
    }
    async update(id, updateItemDto) {
        return this.itemModel.findByIdAndUpdate(id, updateItemDto, { new: true }).exec();
    }
    async delete(id) {
        return this.itemModel.findByIdAndDelete(id).exec();
    }
    async searchByName(name, page, limit) {
        return this.itemModel
            .find({ name: { $regex: name, $options: 'i' } })
            .skip((page - 1) * limit)
            .limit(limit)
            .exec();
    }
    async getImage(id) {
        const objectId = new mongodb_1.ObjectId(id);
        return this.gfs.find({ _id: objectId }).toArray();
    }
    async downloadImage(id) {
        const objectId = new mongodb_1.ObjectId(id);
        return this.gfs.openDownloadStream(objectId);
    }
};
exports.ItemService = ItemService;
exports.ItemService = ItemService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Item')),
    __param(1, (0, mongoose_1.InjectConnection)()),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Connection])
], ItemService);
//# sourceMappingURL=item.service.js.map