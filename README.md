# Terraform Beginner Bootcamp 2023

# WEEK 0

## 1. Semantic Versioning

Semantic versioning is a versioning scheme for software that aims to convey meaning about the underlying changes in a release. Semantic versioning consists of three main components: **MAJOR, MINOR, and PATCH** versions, often written as X.Y.Z(For example: `0.1.0`) 

Here's what each component means:

- **MAJOR version**: This is typically incremented when there are incompatible changes that require modifications in the way the software interacts with other components. This might include breaking changes to the API or fundamental changes in functionality. For example, going from version `1.0.0` to `2.0.0`

- **MINOR version**: This is incremented when new capabilities have been introduced without disrupting existing integrations. For instance, upgrading from version `1.2.0` to `1.3.0`

- **PATCH version**: This is incremented when you make backward compatible bug fixes or minor improvements that do not introduce new features.  For example, moving from version `1.2.3` to `1.2.4`


### 1.1 How to delete tags locally and remotely
In order to delete a local Git tag, use the “git tag” command with the “-d” option.

```
$ git tag -d <tag_name>

Example: git tag -d 0.1.0 
```

In order to delete a remote Git tag(from github repo), use the “git push” command with the “–delete” option and specify the tag name.
```
$ git push --delete origin tagname

Example: git push --delete origin 0.1.0
```

### 1.2 How to have a graph view of branch

Sometimes you need see an icon for graph view. In order to have that please install `git log --graph` plugin.