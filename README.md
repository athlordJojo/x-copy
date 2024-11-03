# Login into aws via cli

```
aws login
```

Here provide the accesskey and secret. 

(source)[https://medium.com/@prateek.malhotra004/mastering-aws-cli-a-comprehensive-guide-to-command-line-power-ca2260167839]

## Troubleshooting

### An error occurred (InvalidToken) when calling the ListBuckets operation: The provided token is malformed or otherwise invalid.

The cause may be a previous logged in session. Delete the previous one:

```
rm -rf .aws
```
