# Rate Limiter

Python package to create rate-limiting rules based on Apache “Combined Log Format”. The rules determine when a certain IP address is banned and unbanned given some pre-defined conditions.

Conditions implemented:

## Prerequisites

#### # Docker

Please make sure docker is installed. For more info, you can visit the [official ](https://docs.docker.com/get-docker/) docker website for instructions.

#### # File to parse (optional)

You can optionally pass your own file to parse and print out the resulting rules. The file should be in the same directory as this README.

Alternatively, if you wish to use ProdE-TestQ2.log. You do not need to download and file. The file will be downloaded from a public S3 bucket.

## Usage

### Using ProdE-TestQ2.log

#### # Windows using git bash

```bash
docker run -it --rm --name rate-limiter -v *currDir*:/usr/src/myapp -w "//usr/src/myapp" pypy:3 pypy3 -m rate_limiter
```

You need to replace `*currDir*` by the path to current directory similar to this:

```
//c/Users/User/Desktop/Crypto/rate-limiter
```

#### # Linux

```bash
docker run -it --rm --name rate-limiter -v $(pwd):/usr/src/myapp -w /usr/src/myapp pypy:3 pypy3 -m rate_limiter
```

### Using a local downloaded file

You need to download the file into the same directory as this README and reference it in commands below where it says **_name_of_file.log_**.

#### # Windows using git bash

```bash
docker run -it --rm --name rate-limiter -v *currDir*:/usr/src/myapp -w "//usr/src/myapp" pypy:3 pypy3 -m rate_limiter --file_path ./name_of_file.log
```

You need to replace `*currDir*` by a path similar to this:

```
//c/Users/User/Desktop/Crypto/rate-limiter
```

#### # Linux

```bash
docker run -it --rm --name rate-limiter -v $(pwd):/usr/src/myapp -w /usr/src/myapp pypy:3 pypy3 -m rate_limiter --file_path ./name_of_file.log
```

## Output

```
1546271816,BAN,58.236.203.13
1546277422,BAN,221.17.254.20
1546281159,UNBAN,221.17.254.20
1546285800,BAN,210.133.208.189
1546293521,UNBAN,210.133.208.189
1546297454,BAN,221.17.254.20
1546301067,UNBAN,221.17.254.20
1546310823,UNBAN,58.236.203.13
```

The output above is not exactly equal to the expected output but it is very close. It's probably related to different handling of edge limits in the algorithms.

## License

[MIT](https://choosealicense.com/licenses/mit/)
