# Sun Be Gone

## Overview

Sun Be Gone is a mobile app developed using Flutter that helps users determine the best side to sit on a bus to avoid direct sunlight during their journey.

### Available at Google Play

You can [download](https://play.google.com/store/apps/details?id=com.mkradevrbs.sun_be_gonethe) the app from the Play Store.

## Features

- **Sun Avoidance Prediction:** Utilizes real-time data and user location to suggest the optimal side to sit on based on the position of the sun.
- **User-Friendly Interface:** Simple and intuitive design for easy navigation and usage.

## Installation

### Requirements

- Flutter SDK

### Getting Started

1. Clone the repository: 
```bash
$ git clone https://github.com/moshekravitz/sun_be_gone.git
```
2. Navigate to the project directory:
```bash
$ cd sun_be_gone
```
3. Install dependencies:
```bash
$ flutter pub get
```
4. Run the app:
```bash
$ flutter run
```


## Technology Stack

- **Flutter Framework:** Used for building the mobile application.
- **Bloc Pattern:** Implemented for efficient state management, providing a clear separation between business logic and UI components.
- **Custom Sun Position Calculation Package:** Developed to calculate the sun's position along the bus route and determine the best seating to avoid sunlight.

### Sun Position Calculation Package

This project includes a custom package specifically designed to calculate the position of the sun along a bus route. The package provides functionality for:

- **Sun Position Calculation:** Determining the sun's position based on geographic coordinates and time, aiding in suggesting the best seat to avoid direct sunlight.
    - This part of the package is written using a modified version of the Solar Position Algorithm (SPA)
- **Route Analysis:** Analyzing the bus route to predict the varying angles of sunlight at different times.


## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature`)
6. Create a pull request

## Acknowledgments

This software uses the following open source packages:

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Spa](https://midcdmz.nrel.gov/spa/)
