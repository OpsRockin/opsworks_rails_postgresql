Rails with postgresql for rails with Opsworks
===================

Supports
-----------

- Ubuntu

Layer Settings requirements
------------

### OS Packages

- postgresql-server-dev-9.1
- postgresql-9.1
- postgresql-contrib-9.1

### Custom Chef Recipes

#### Setup
- postgresql::default

#### Configure

#### Deploy


### Chef custom json sample


```
{
  "postgresql" : {
  "password" : "your_password",
  "extentions" : [
    "hstore"
    ]
  },
  "deploy": {
    "app_name": {
      "database": {
        "adapter": "postgresql",
        "username": "app_name",
        "database": "app_name_production"
        "password": "your_password"
      },
      "migrate": true,
      "auto_bundle_on_deploy": true
    }
  }
}
```



Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
