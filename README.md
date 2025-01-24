# MoldMe

MoldMe is a cross-platform software with a C# .NET backend, SQL Server database, and frontends built using Ionic for Android and Flutter for the web.

## Table of Contents
- [Getting Started](#getting-started)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [.NET SDK](https://dotnet.microsoft.com/download)
- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- [Ionic CLI](https://ionicframework.com/docs/cli)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/pedroteixeira2002/moldme.git
    cd moldme
    ```

2. Set up the backend:
    ```sh
    cd backend
    dotnet restore
    dotnet build
    dotnet run
    ```

3. Set up the Ionic frontend:
    ```sh
    cd moldme_frontend
    npm install
    ionic serve
    ```

4. Set up the Flutter frontend:
    ```sh
    cd moldme_flutter
    flutter pub get
    flutter run
    ```

## Technologies Used

- **Dart**: 52.9%
- **C#**: 40.1%
- **C++**: 3.2%
- **CMake**: 1.8%
- **HTML**: 0.8%
- **Objective-C**: 0.4%
- **Other**: 0.8%

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
