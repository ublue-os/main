name: Bug Report
description: Report an issue about using `main`
labels: [kind/bug]

body:
  - type: markdown
    attributes:
      value: |
        Thank you for taking the time to fill out this bug report!
  - type: textarea
    id: describe-bug
    attributes:
      label: Describe the bug
      description: A clear and concise description of what the bug is.
      placeholder: Tell us what happened!
      value: "When I entered 2 + 2, I got the answer 6."
    validations:
      required: true
  - type: textarea
    id: expected-bahavior
    attributes:
      label: What did you expect to happen?
      description: A clear and concise description of what you expected to happen.
      placeholder: What were you expecting to happen?
      value: "I expected 2 + 2 to equal 4, but instead 2 + 2 equaled 6!"
    validations:
      required: true
  - type: dropdown
    id: image
    attributes:
      label: Image
      description: Which specific image do you want?
      options:
        - Bazzite
        - Kinoite
        - LXQt
        - Mate
        - Silverblue
        - Ubuntu
        - Vauxite
    validations:
      required: true
  - type: textarea
    id: status
    attributes:
      label: System packaging status
      description: Please run `rpm-ostree status -v` and paste the output here.
      render: shell
  - type: textarea
    id: policy
    attributes:
      label: Policy
      description: Please copy and paste the policy you are trying to run if applicable. Please exclude any account/sensitive information. Your response will be automatically formatted into YAML, so code-formatting markdown is not necessary.
      render: shell
  - type: textarea
    id: logs
    attributes:
      label: Relevant log/traceback output
      description: Please copy and paste any relevant log output. Please exclude any account/sensitive information. Your response will be automatically formatted into YAML, so code-formatting markdown is not necessary.
      render: shell
  - type: textarea
    id: extra-context
    attributes:
      label: Extra information or context
      description: Add any other context about the problem here.
