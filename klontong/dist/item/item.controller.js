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
exports.ItemController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const mongodb_1 = require("mongodb");
const gridfs_service_1 = require("../gridfs/gridfs.service");
const item_service_1 = require("./item.service");
let ItemController = class ItemController {
    constructor(itemService, gridFsService) {
        this.itemService = itemService;
        this.gridFsService = gridFsService;
    }
    async create(file, createItemDto, res) {
        const fileId = new mongodb_1.ObjectId(file._id);
        const item = await this.itemService.create({
            ...createItemDto,
            image: fileId.toString(),
        }, file);
        return res.status(item ? 201 : 500).send();
    }
    async findAll(data, response) {
        const result = await this.itemService.findAll(data?.page ?? 1, data?.limit ?? 10);
        console.log(result);
        return response.status(200).json({
            data: result,
        }).send();
    }
    async findOne(id) {
        return this.itemService.findById(id);
    }
    async remove(id) {
        return this.itemService.delete(id);
    }
    async search(name, page = 1, limit = 10) {
        return this.itemService.searchByName(name, page, limit);
    }
    async update(id, updateItemDto, file) {
        const existingItem = await this.itemService.findById(id);
        if (!existingItem) {
            throw new Error('Item not found');
        }
        let updatedImageId = existingItem.image;
        if (file) {
            const newImageId = file._id.toString();
            if (existingItem.image) {
                await this.gridFsService.deleteFile(existingItem.image);
            }
            updatedImageId = newImageId;
        }
        return this.itemService.update(id, {
            ...updateItemDto,
            image: updatedImageId,
        });
    }
    async displayImage(id, res) {
        const file = await this.itemService.getImage(id);
        if (!file || file.length === 0) {
            throw new common_1.HttpException('File not found', common_1.HttpStatus.NOT_FOUND);
        }
        const imageFile = file[0];
        res.set({
            'Content-Type': imageFile.contentType,
        });
        const fileStream = await this.itemService.downloadImage(id);
        fileStream.pipe(res);
    }
};
exports.ItemController = ItemController;
__decorate([
    (0, common_1.Post)(),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('image')),
    __param(0, (0, common_1.UploadedFile)()),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, Object]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "findOne", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "remove", null);
__decorate([
    (0, common_1.Get)('search'),
    __param(0, (0, common_1.Query)('name')),
    __param(1, (0, common_1.Query)('page')),
    __param(2, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Number, Number]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "search", null);
__decorate([
    (0, common_1.Put)(),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.UploadedFile)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object, Object]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "update", null);
__decorate([
    (0, common_1.Get)('images/:id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], ItemController.prototype, "displayImage", null);
exports.ItemController = ItemController = __decorate([
    (0, common_1.Controller)('item'),
    __metadata("design:paramtypes", [item_service_1.ItemService,
        gridfs_service_1.GridFsService])
], ItemController);
//# sourceMappingURL=item.controller.js.map