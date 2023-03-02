name: Request a Package
description: Request an RPM package to be included in the base image
labels: [package-request]

body:
  - type: markdown
    attributes:
      value: |
        Thank you for taking the time to fill out this request!
  - type: textarea
    id: describe-bug
    attributes:
      label: Describe the package
      description: Include why you feel this should be on the image
      placeholder: Tell us what you need
      value: "I'd like to request the package `vim` on the main image"
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
    validations:
      required: true
