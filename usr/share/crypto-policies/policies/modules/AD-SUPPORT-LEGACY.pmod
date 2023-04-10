# AD-SUPPORT-LEGACY subpolicy is intended to be used in Active Directory
# environments where either accounts or trusted domain objects were not yet
# migrated to AES or future encryption types.
# This subpolicy enables all AES and RC4 Kerberos encryption types
# to maximize Active Directory interoperability at the expense of security.

cipher@kerberos = AES-256-CBC+ AES-128-CBC+ RC4-128+
mac@kerberos = HMAC-SHA2-384+ HMAC-SHA2-256+ HMAC-SHA1+
hash@kerberos = MD5+
