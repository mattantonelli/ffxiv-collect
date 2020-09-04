## Adding a new collection

1. Add custom inflections if needed
    * Also add custom rules to the `generic_sprite` Application helper and the `collection_name` Characters helper if needed
2. Create the necessary migrations & models
    * Add indexes and validations as necessary
    * Fill out the newly created models
3. Create the rake task to load the new collection
    * Add the new task to update tasks in `all.rake`
4. Create new image directories as needed
    * Add `.keep` files in the public directories and force check in to Git
5. Update `.gitignore` with any new image directories
6. Update the list of `COLLECTIONS` in the Characters controller
7. Add the new collection to the relationship list in the Character model
8. Add the new collection to the routes lists (standard, mod, and api if desired)
    * Add a link to the new route in the navbar
    * Add the new collection to the list on the Mod Dashboard `index` page
9. Copy an existing controller & views and modify as necessary for the new collection
    * Also do this for the API if desired
10. Copy an existing mod controller and modify as necessary for the new collection
11. Add the new collection to the `ownership.rake` model list
12. Update the API documentation in the repo wiki if new endpoints were added

## Deployment

1. Add the new collectable to the appropriate image list in `config/deploy.rb`
2. Create the new image directories in the application's `shared/public/images` directory
3. Set the one-time task in `config/deploy.rb` to the newly created rake task
    * This will allow the new collection to be populated during the deployment
4. Push the latest code changes to GitHub
5. Deploy with Capistrano
6. Set the new collectable sources on the production application via the Mod Dashboard
