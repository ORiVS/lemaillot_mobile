@echo off
echo 🚀 Création de l'architecture Flutter pour LeMaillot...

REM Créer les dossiers
mkdir lib\screens
mkdir lib\models
mkdir lib\services
mkdir lib\providers

REM Créer les fichiers Screens
type nul > lib\screens\login_screen.dart
type nul > lib\screens\register_screen.dart
type nul > lib\screens\home_screen.dart
type nul > lib\screens\product_detail_screen.dart
type nul > lib\screens\cart_screen.dart

REM Créer les fichiers Models
type nul > lib\models\user.dart
type nul > lib\models\product.dart
type nul > lib\models\order.dart

REM Créer le fichier Services
type nul > lib\services\api_service.dart

REM Créer les fichiers Providers
type nul > lib\providers\auth_provider.dart
type nul > lib\providers\product_provider.dart

REM Créer le fichier principal
type nul > lib\main.dart

echo ✅ Dossiers et fichiers créés !

REM Ajouter les dépendances
echo 🚀 Ajout des dépendances (Dio, Riverpod, Freezed)...

flutter pub add flutter_riverpod
flutter pub add dio
flutter pub add freezed_annotation
flutter pub add json_annotation
flutter pub add flutter_dotenv

flutter pub add build_runner --dev
flutter pub add freezed --dev
flutter pub add json_serializable --dev

echo ✅ Dépendances ajoutées avec succès !
echo 🚀 Prêt à coder avec Flutter, Dio, Riverpod et Freezed 🚀
pause
