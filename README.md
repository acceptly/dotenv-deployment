# dotenv-deployment

**The original gem [dotenv-deployment](https://github.com/bkeepers/dotenv-deployment) is deprecated and no longer maintained.**

### Loading order

Given a `development` environment, here is the loading order (every stage overide values from the previous one):

1. `.env`
2. `.env.development`
3. `.env.development.mine`
4. `ENV`

`*.mine` files are git-ignored and allow the developer to overwrite defaults values for a given env.


#### Example:

For the following files:

`.env`
```
A=1
B=1
C=1
D=1
```

`.env.development`
```
A=2
B=2
C=2
```

`.env.development.mine`
```
A=3
B=3
```

Used with `RACK_ENV=development A=4 tux`, the values would be:

```
ENV['A'] == 4
ENV['B'] == 3
ENV['C'] == 2
ENV['D'] == 1
```
