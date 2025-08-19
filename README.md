# Home Lab

- Hosting: [Firefly III](https://github.com/firefly-iii/firefly-iii), a personal finance manager app.
- Playground for testing.

# Commands

1. Set up the cluster:

```
ansible-playbook ansible/playbooks/bootstrap/playbook.yml --ask-become-pass
```

2. Backup Firefly DB:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup.yml --ask-become-pass --tags backup
```

3. Restore Firefly DB:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup.yml --ask-become-pass --tags restore
```
