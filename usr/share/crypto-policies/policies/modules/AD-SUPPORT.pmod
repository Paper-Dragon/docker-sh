# AD-SUPPORT subpolicy is intended to be used in Active Directory environments.
# This subpolicy is provided for enabling aes256-cts-hmac-sha1-96,
# the strongest Kerberos encryption type interoperable with Active Directory.

cipher@kerberos = AES-256-CBC+
mac@kerberos = HMAC-SHA1+
