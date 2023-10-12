import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.setGlobalPrefix('/swagger-testing-1');

  const config = new DocumentBuilder()
    .setTitle('Swagger Testing 1')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('/swagger-testing-1/docs', app, document);

  await app.listen(3000);
}
bootstrap();
