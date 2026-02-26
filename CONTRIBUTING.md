# Contributing

If you want to contribute to this project, create an Issue or a Pull Request.

## Tests

To update the golden file for testing the UI of the PopupCard run:

```bash
flutter test --update-goldens
```

## GitHub Actions CI/CD

This repository includes two workflows:

- `.github/workflows/ci.yml`: runs `flutter analyze` and `flutter test` on pull requests to `main`.
- `.github/workflows/publish.yml`: on version tags (for example `v0.0.8`), runs analyze/tests and then publishes to pub.dev.

To publish a new version push a tag (version should match in `pubspec.yaml`):

```bash
git tag v0.0.8
git push origin v0.0.8
```
