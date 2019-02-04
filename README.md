# ContactMaskBatch

This SF APEX will run a batch to mask Contact Email addresses. Email Addresses are masked with `.sandboxname`.

This includes a `SandboxPostCopy` implementation and Unit Test.

## Error Handling

Contacts are updated allowing partial success/fail. Any contacts that fail to update will be emailed to the running user.
