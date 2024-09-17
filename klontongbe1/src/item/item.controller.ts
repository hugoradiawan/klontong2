import { Body, Controller, Delete, Get, HttpException, HttpStatus, Param, Post, Put, Query, Res, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { GridFSBucket, ObjectId } from 'mongodb';
import { GridFsService } from '../gridfs/gridfs.service';
import { ItemService } from './item.service';

@Controller('item')
export class ItemController {
  private gfs!: GridFSBucket;

  constructor(
    private readonly itemService: ItemService,
    private readonly gridFsService: GridFsService,
  ) {
  }

  @Post()
  // @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor('image'))
  async create(
    @UploadedFile() file: Express.Multer.File & { _id: ObjectId },
    @Body() createItemDto: { name: string; description: string; sku: string; categoryName: string; categoryId: string; weight?: number; width?: number; length?: number; height?: number; harga: number },
    @Res() res: Response,
  ) {
    const fileId = new ObjectId(file._id);
    const item = await this.itemService.create({
      ...createItemDto,
      image: fileId.toString(),
    }, file);
    return res.status(item ? 201 : 500).send();
  }

  @Get()
  async findAll(@Body() data: { page?: number; limit?: number }, @Res() response: Response) {
    const result = await this.itemService.findAll(data?.page ?? 1, data?.limit ?? 10);
    console.log(result);
    return response.status(200).json({
      data: result,
    }).send();
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.itemService.findById(id);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return this.itemService.delete(id);
  }

  @Get('search')
  async search(@Query('name') name: string, @Query('page') page: number = 1, @Query('limit') limit: number = 10) {
    return this.itemService.searchByName(name, page, limit);
  }

  @Put()
  async update(
    @Param('id') id: string,
    @Body() updateItemDto: Partial<{ name: string; description: string; sku: string; categoryName: string; categoryId: string; weight?: number; width?: number; length?: number; height?: number; harga: number }>,
    @UploadedFile() file?: Express.Multer.File & { _id: ObjectId },  // Now this is last
  ) {
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

  @Get('images/:id')
  async displayImage(@Param('id') id: string, @Res() res: Response) {
    const file = await this.itemService.getImage(id);
    if (!file || file.length === 0) {
      throw new HttpException('File not found', HttpStatus.NOT_FOUND);
    }
    const imageFile = file[0];
    res.set({
      'Content-Type': imageFile.contentType,
    });
    const fileStream = await this.itemService.downloadImage(id);
    fileStream.pipe(res);
  }
}