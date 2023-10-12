import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.setGlobalPrefix('/swagger-testing-2');

  const config = new DocumentBuilder()
    .setTitle('Swagger Testing 2')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('/swagger-testing-2/docs', app, document);

  await app.listen(3001);
}
bootstrap();
