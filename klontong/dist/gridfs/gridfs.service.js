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
exports.GridFsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongodb_1 = require("mongodb");
const mongoose_2 = require("mongoose");
let GridFsService = class GridFsService {
    constructor(connection) {
        this.connection = connection;
        this.gridFsBucket = new mongodb_1.GridFSBucket(this.connection.db, { bucketName: 'icons' });
    }
    async findById(id) {
        const objectId = new mongodb_1.ObjectId(id);
        return this.gridFsBucket.find({ _id: objectId }).toArray();
    }
    openDownloadStream(id) {
        const objectId = new mongodb_1.ObjectId(id);
        return this.gridFsBucket.openDownloadStream(objectId);
    }
    async deleteFile(id) {
        const objectId = new mongodb_1.ObjectId(id);
        await this.gridFsBucket.delete(objectId);
        return objectId.toString();
    }
};
exports.GridFsService = GridFsService;
exports.GridFsService = GridFsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectConnection)()),
    __metadata("design:paramtypes", [mongoose_2.Connection])
], GridFsService);
//# sourceMappingURL=gridfs.service.js.map