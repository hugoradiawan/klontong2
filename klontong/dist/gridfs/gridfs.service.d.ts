import { Connection } from 'mongoose';
export declare class GridFsService {
    private readonly connection;
    private gridFsBucket;
    constructor(connection: Connection);
    findById(id: string): Promise<import("mongodb").GridFSFile[]>;
    openDownloadStream(id: string): import("mongodb").GridFSBucketReadStream;
    deleteFile(id: string): Promise<String>;
}
