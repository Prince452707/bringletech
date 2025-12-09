# Bringletech – Product Explorer

A Flutter demo application that explores products from the public
[DummyJSON](https://dummyjson.com) API. It showcases a clean architecture
approach with **data / domain / presentation** layers, **GetX** for state
management & DI, and a modern UI built with custom theming, shimmer loading
effects, and smooth transitions.

The app lets you:

- Browse a paginated grid of products.
- Search products with a debounced search field.
- Sort by price or title (ascending/descending).
- View detailed product information, gallery, and reviews.
- Add, edit, and delete products (simulated CRUD via DummyJSON).

> Note: The backend is DummyJSON, which returns mock responses for write
> operations. Add/update/delete calls work for the current session but are not
> persisted on a real backend.

---

## Tech Stack

- **Framework**: Flutter (Dart SDK ^3.10.0)
- **State management & routing**: [GetX](https://pub.dev/packages/get)
- **HTTP client**: [Dio](https://pub.dev/packages/dio)
- **Image loading**: [cached_network_image](https://pub.dev/packages/cached_network_image)
- **Loading effects**: [shimmer](https://pub.dev/packages/shimmer)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Typography**: [google_fonts](https://pub.dev/packages/google_fonts)

---

## Features

- **Product listing**
  - Infinite scroll / load-more pagination.
  - Shimmer placeholders while data is loading.
  - Pull-to-refresh support.

- **Search & sort**
  - Debounced search over products using the DummyJSON `/products/search` API.
  - Sort options: default, price low→high, price high→low, title A→Z, title Z→A.

- **Product details**
  - Hero-animated image transitions from the grid to the detail screen.
  - Full product description and pricing.
  - Additional metadata such as SKU, weight, warranty, shipping, availability,
    return policy, gallery images, and reviews (when provided by the API).

- **Product management (simulated)**
  - Add new products via a simple form.
  - Edit existing products (title, price, description, etc.).
  - Delete products with confirmation dialogs.
  - User feedback via GetX snackbars.

- **Error handling & UX**
  - Centralized error mapping to user-friendly messages.
  - Network/server/unknown failures mapped to custom `Failure` types.
  - Error UI with icons and retry actions on the list screen.

---

## Architecture Overview

The project follows a simple **clean-ish architecture** with clear separation
of concerns:

- **core/**
  - Cross-cutting concerns: error handling, networking, theming.
- **data/**
  - Implements repositories, talks to the HTTP API, and maps JSON to models.
- **domain/**
  - Contains business entities, repository contracts, and use cases.
- **presentation/**
  - UI widgets, screens, controllers, and GetX bindings.

### Layers & Responsibilities

- **API client** – `lib/core/network/api_client.dart`
  - Wraps a configured `Dio` instance with base URL `https://dummyjson.com`.
  - Sets connect/receive timeouts.

- **Domain entities** – `lib/domain/entities/product_entity.dart`
  - `ProductEntity` with rich product information (images, reviews, specs).
  - `ReviewEntity`, `DimensionsEntity` for nested data.

- **Repository contract** – `lib/domain/repositories/product_repository.dart`
  - Abstract interface for product operations:
    - `getProducts`, `searchProducts`, `getCategories`,
      `getProductsByCategory`, `addProduct`, `updateProduct`, `deleteProduct`.

- **Repository implementation** – `lib/data/repositories/product_repository_impl.dart`
  - Uses `ApiClient` + `Dio` to call DummyJSON endpoints:
    - `/products`, `/products/search`, `/products/category-list`,
      `/products/category/{category}`, `/products/add`, `/products/{id}` (PUT),
      `/products/{id}` (DELETE).
  - Maps JSON responses into `ProductModel` which extends `ProductEntity`.
  - Handles network and server errors using custom exceptions.

- **Use cases** – `lib/domain/usecases/`
  - `GetProductsUseCase`
  - `SearchProductsUseCase`
  - `GetCategoriesUseCase`
  - `GetProductsByCategoryUseCase`
  - `ManageProductUseCase` (add/update/delete)

- **Presentation layer** – `lib/presentation/`
  - **Binding**: `presentation/bindings/product_binding.dart`
    - Wires up `ApiClient`, `ProductRepositoryImpl`, all use cases, and the
      `ProductController` using `Get.lazyPut`.
  - **Controller**: `presentation/controllers/product_controller.dart`
    - Holds observable state: product list, categories, loading flags,
      pagination offsets, current sort, selected category, search text, and
      possible `Failure`.
    - Provides methods for fetching, searching, sorting, adding, editing, and
      deleting products.
  - **Pages**: `presentation/pages/`
    - `product_list_screen.dart` – main grid list with search, sort, and
      infinite scrolling.
    - `product_detail_screen.dart` – detailed view with gallery, specs,
      reviews, and edit/delete actions.
    - `add_edit_product_screen.dart` – form to add or edit a product.
  - **Widgets**: `presentation/widgets/product_card.dart`
    - Card used in the grid listing with thumbnail, rating, and price.

---

## Project Structure

```text
bringletech/
├─ lib/
│  ├─ core/
│  │  ├─ error/
│  │  │  ├─ api_exceptions.dart
│  │  │  ├─ error_handler.dart
│  │  │  └─ failures.dart
│  │  ├─ network/
│  │  │  └─ api_client.dart
│  │  └─ theme/
│  │     ├─ app_colors.dart
│  │     └─ app_fonts.dart
│  ├─ data/
│  │  ├─ models/
│  │  │  └─ product_model.dart
│  │  └─ repositories/
│  │     └─ product_repository_impl.dart
│  ├─ domain/
│  │  ├─ entities/
│  │  │  └─ product_entity.dart
│  │  ├─ repositories/
│  │  │  └─ product_repository.dart
│  │  └─ usecases/
│  │     ├─ get_categories_usecase.dart
│  │     ├─ get_products_by_category_usecase.dart
│  │     ├─ get_products_usecase.dart
│  │     ├─ manage_product_usecase.dart
│  │     └─ search_products_usecase.dart
│  ├─ presentation/
│  │  ├─ bindings/
│  │  │  └─ product_binding.dart
│  │  ├─ controllers/
│  │  │  └─ product_controller.dart
│  │  ├─ pages/
│  │  │  ├─ add_edit_product_screen.dart
│  │  │  ├─ product_detail_screen.dart
│  │  │  └─ product_list_screen.dart
│  │  └─ widgets/
│  │     └─ product_card.dart
│  └─ main.dart
├─ pubspec.yaml
└─ README.md
```

---

## Getting Started

### Prerequisites

- Flutter SDK **3.10.0+** (matches the `environment` constraint).
- A working Flutter development setup (Android Studio / VS Code / Xcode).
- An emulator or physical device (Android/iOS) or Chrome for web.

### Install dependencies

```bash
flutter pub get
```

### Run the app

From the project root (`bringletech/`):

```bash
flutter run
```

You can specify a device, for example:

```bash
flutter run -d chrome       # Web
flutter run -d emulator-5554  # Android emulator (example ID)
```

The entry point is `lib/main.dart`, which configures `GetMaterialApp` with
`ProductBinding` and `ProductListScreen` as the initial screen.

---

## Testing

The project currently does not include unit/widget tests, but you can still run
Flutter's test command (it will simply find no tests):

```bash
flutter test
```

You can add tests under the `test/` directory as needed (for example, testing
use cases or the `ProductController`).

---

## Configuration

- **API base URL**: defined in `ApiClient` (`lib/core/network/api_client.dart`).
  - Default: `https://dummyjson.com`.
  - You can change the `baseUrl` argument if you want to point to a different
    backend.

---

## Notes

- Network and server failures are gracefully handled and surfaced to the UI.
- Some advanced fields (dimensions, warranty, shipping, etc.) depend on what
  the DummyJSON API returns for a given product.
- Add/update/delete operations are meant for demo purposes and rely on the
  behavior of DummyJSON's mock API.
