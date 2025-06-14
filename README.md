# Audio-Video to Text API

A Rails API that converts audio and video files to text using AssemblyAI's transcription service.

## Requirements

* Ruby 3.1.2
* Rails 7.0.4
* SQLite3

## Setup

1. Clone the repository
2. Install dependencies:
```bash
bundle install
```
3. Set up the database:
```bash
rails db:create db:migrate
```
4. Add your AssemblyAI API key in `app/controllers/api/v1/transcription_service.rb`

## API Endpoints

### Authentication
The API uses Devise JWT for authentication. Include the JWT token in request headers:
```
Authorization: Bearer <your-jwt-token>
```

### Audio Endpoints

#### POST /api/v1/audios
Upload and transcribe an audio file.
- Request: `multipart/form-data` with `audio_file` parameter
- Response: Transcribed text and file information

#### GET /api/v1/audios
Get all audio transcriptions for the current user.

#### GET /api/v1/audios/:id
Get a specific audio transcription.

#### DELETE /api/v1/audios/:id
Delete an audio transcription.

## Features

- Audio file transcription
- User authentication with JWT
- Flagged word detection
- User blocking after 3 flagged words
