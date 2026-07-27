# Contributing Guidelines - Banking Loan Management System (BLMS)

Thank you for your interest in contributing to the Banking Loan Management System!

---

## 1. Code Standards
- **Apex**: Must follow Enterprise Apex Patterns (Service, Selector, Handler). All classes must enforce `with sharing` and `WITH USER_MODE`. No SOQL/DML in loops. Unit test coverage must exceed 85%.
- **LWC**: Follow SLDS styling guidelines, reactive wire patterns, and include proper error boundaries.
- **Prettier & ESLint**: Run formatting verification before submitting pull requests:
  ```bash
  npm run prettier
  npm run lint
  ```

---

## 2. Gitflow Branching Model
1. Branch from `develop` for features: `feature/feature-name`.
2. Branch from `main` for hotfixes: `hotfix/fix-name`.
3. Commit messages must follow Conventional Commits:
   - `feat: add eligibility slider LWC`
   - `fix: resolve null check in EMI batch`
   - `docs: update deployment guide`

---

## 3. Submitting Pull Requests
1. Ensure all local Apex unit tests pass (`sf apex run test`).
2. Ensure PMD static code analysis passes.
3. Open a Pull Request targeting `develop` or `main`.
