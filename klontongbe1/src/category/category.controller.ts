import { Controller, Post, Body, UploadedFile, UseInterceptors, Res, Get, Query, Param, Put, Delete, HttpException, HttpStatus } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { CategoryService } from './category.service';
import { ObjectId } from 'mongodb';
import { Response } from 'express';
import { Category } from './schema/category.schema';

@Controller('category')
export class CategoryController {
  constructor(private readonly categoryService: CategoryService) {}

  @Post()
  // @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor('image'))
  async create(
    @UploadedFile() file: Express.Multer.File & { _id: ObjectId },
    @Body() createCategoryDto: { name: string; color: string },
    @Res() res: Response,
  ) {
    const fileId = new ObjectId(file._id);
    const color = createCategoryDto.color.split(',').map(e => +e);
    const category = await this.categoryService.create({
      ...{
        name: createCategoryDto.name,
        color,
      },
      icon: fileId.toString(),
    }, file);
    return res.status(category ? 201 : 500).send();
  }

  @Get()
  async findAll(@Body() data: { page: number; limit: number }, @Res() response: Response) {
    const result = await this.categoryService.findAll(data?.page ?? 1, data?.limit ?? 10);
    return response.status(200).json({
      data: result,
    }).send();
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.categoryService.findById(id);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return this.categoryService.delete(id);
  }

  @Get('search')
  async search(@Query('name') name: string, @Query('page') page: number = 1, @Query('limit') limit: number = 10) {
    return this.categoryService.searchByName(name, page, limit);
  }

  @Put()
  @UseInterceptors(FileInterceptor('image'))
  async update(
    @Param('id') id: string,
    @Body() updateItemDto: Partial<Category>,
    @UploadedFile() file?: Express.Multer.File & { _id: ObjectId },
  ) {
    const existingCategory = await this.categoryService.findById(id);
    if (!existingCategory) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    return this.categoryService.update(id, updateItemDto, file, existingCategory);
  }

  @Get('icons/:id')
  async displayImage(@Param('id') id: string, @Res() res: Response) {
    const file = await this.categoryService.getIcon(id);
    if (!file || file.length === 0) {
      throw new HttpException('File not found', HttpStatus.NOT_FOUND);
    }
    const imageFile = file[0];
    res.set({
      'Content-Type': imageFile.contentType,
    });
    const fileStream = await this.categoryService.downloadIcon(id);
    fileStream.pipe(res);
  }
}
