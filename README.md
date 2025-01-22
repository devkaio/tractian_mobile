
# Tractian Mobile

[![codecov](https://codecov.io/gh/devkaio/tractian_mobile/graph/badge.svg?token=N6UN8B17ML)](https://codecov.io/gh/devkaio/tractian_mobile)

## Features
**1. Home Page**
- [x] Navigate between different companies and access their assets.

**2. Asset Page**
- [x] The Asset Tree is the core feature, offering a visual Tree representation of the company's asset hierarchy.

- **Sub-Features:**
    1. **Visualization**
        - [x] Present a dynamic tree structure displaying components, assets, and locations.
    2. **Filters**
        **Text Search**
        - [x] Users can search for specific components/assets/locations within the asset hierarchy.
        **Energy Sensors**
        - [x] Implement a filter to isolate energy sensors within the tree.
        **Critical Sensor Status**
        - [x] Integrate a filter to identify assets with critical sensor status.
        - [x] When the filters are applied, the asset parents **can't** be hidden. The user must know the entire asset path.
        - [x] The items that are not related to the asset path, must be hidden.

**3. Future improvements**
- [ ] Create a custom tree view for performance improvements and better user experience.
- [ ] Improve BlueCapped design system components
- [ ] Add integration tests

## Installation
1. Clone the repository
2. To install Flutter, visit the [official documentation](https://flutter.dev/docs/get-started/install) 
3. Run `flutter pub get` to install the dependencies
4. Run `flutter run` to start the application

## Codecov Secrets Instructions
- 1. If you cloned this repository, you need to setup the CODECOV_TOKEN secret in your repository.
- 2. Check the [Codecov Documentation](https://docs.codecov.com/docs/quick-start) to setup the secrets.