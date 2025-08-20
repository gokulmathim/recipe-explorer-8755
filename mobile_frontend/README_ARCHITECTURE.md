# Recipe Explorer - Mobile Frontend

This Flutter app provides:
- Bottom navigation with Home, Search, and Favorites tabs
- Card-based recipe grid and detailed recipe pages
- User login/registration via REST
- Favorites/bookmarking persisted locally
- Modern light theme with brand colors

## Architecture
- lib/services/api_service.dart: REST client with token support (reads API_BASE_URL from .env)
- lib/models/recipe.dart: Recipe model
- lib/providers/auth_provider.dart: Auth state, token persistence, login/register
- lib/providers/recipe_provider.dart: Listing, search, detail fetching
- lib/providers/favorites_provider.dart: Bookmark management (SharedPreferences)
- lib/screens: UI pages (auth, home, search, favorites, detail)
- lib/widgets/recipe_card.dart: Reusable recipe card for grid

## Environment
Create .env from example:
cp .env.example .env
Edit API_BASE_URL to point to your backend.

## Running
flutter pub get
flutter run
