This project is set up to build Flutter Web and deploy to GitHub Pages using GitHub Actions.

What the workflow does
- Runs on push to `main` or manual dispatch.
- Installs Flutter, enables web, runs `flutter pub get`.
- Builds `flutter build web --release`.
- Publishes `build/web` to the `gh-pages` branch using `peaceiris/actions-gh-pages`.

How to use
1. Commit and push your code to `main`.
2. On GitHub: go to Actions -> select "Build and Deploy Flutter Web to GitHub Pages" -> monitor run.
3. When succeeded, enable GitHub Pages in repository settings (Settings -> Pages):
   - Source: `gh-pages` branch
   - Folder: `/ (root)`

Notes
- Workflow uses the `GITHUB_TOKEN` automatically provided by Actions; no extra secret required.
- If you prefer another branch or directory, edit `.github/workflows/flutter_web.yml` accordingly.
- For private repositories, Pages may require extra configuration.
