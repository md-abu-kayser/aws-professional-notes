# Contributing to AWS Professional Notes

Thanks for your interest in improving this repository! Whether you're
fixing a typo, adding a new topic, or contributing a real-world
project, here's how to get started.

## Ways to contribute

- **Fix errors** — typos, outdated screenshots, broken commands, or
  services that have changed behavior.
- **Expand notes** — flesh out a `TODO` section with more detail,
  diagrams, or examples.
- **Add code snippets** — CloudFormation templates, CDK constructs,
  Lambda functions, or CLI scripts under `18-code-snippets/`.
- **Add a real-world project** — a new end-to-end guided build under
  `17-real-world-projects/`.
- **Improve cheatsheets** — keep `19-resources-cheatsheets/` current
  with the latest best practices and interview questions.

## Workflow

1. **Fork** the repository and create a new branch:
   ```bash
   git checkout -b add-notes-on-topic-x
   ```
2. **Follow the existing structure** — place new notes in the
   appropriate numbered folder, and follow the existing naming
   convention (`NN-kebab-case-title.md`).
3. **Use the note template** — each markdown note follows this rough
   shape: Overview → Key Concepts → Hands-on/CLI Examples → Exam/
   Interview Tips → References. Keep new notes consistent with this
   format.
4. **Test code snippets** before submitting — CLI scripts should run
   without errors, and CloudFormation/CDK templates should validate
   (`aws cloudformation validate-template` or `cdk synth`).
5. **Never commit secrets** — no account IDs, access keys, or
   passwords, even in examples. Use placeholders like
   `<YOUR_ACCOUNT_ID>`.
6. **Open a Pull Request** using the provided template, describing
   what changed and why.

## Style guidelines

- Use clear, concise language — this is a reference, not a novel.
- Prefer bullet points and short code blocks over long paragraphs.
- Link to official AWS documentation for anything that may change
  over time (pricing, limits, quotas).
- Keep diagrams in `assets/diagrams/` and screenshots in
  `assets/screenshots/`, referenced with relative paths.

## Reporting issues

Please use the issue templates under `.github/ISSUE_TEMPLATE/`:

- **Bug report** — for errors, typos, or outdated content.
- **Feature request** — for new topics or services you'd like to see
  covered.

## Code of conduct

Be respectful and constructive. This project exists to help people
learn — please keep contributions welcoming to beginners and experts
alike.
