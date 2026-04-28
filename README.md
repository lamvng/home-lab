# Home Lab

## Purpose

- Hosting [Firefly III](https://github.com/firefly-iii/firefly-iii), a personal finance management app.
- Hosting a local LLM model via Ollama, with agents to simplify interactions with Firefly:
  - Registering transactions using natural language.
  - Personal financial analysis.
- Other technical components: ArgoCD, CertManager, GPU Operator...

## Technical Context

- The stack is hosted on a laptop, which may be turned on and off regularly.
- The Firefly III database is the most critical component. It is backed up regularly to local disk and to Google Drive.
- The rest of the stack can be torn down and set up from scratch without issues.

# Bootstrap

Set up Pyenv: https://github.com/pyenv/pyenv?tab=readme-ov-file#linuxunix

Install a newer Python version and create a virtualenv:

```
pyenv_latest=$(pyenv latest -k 3)
pyenv install $pyenv_latest
pyenv local $pyenv_latest
python -m venv $HOME/homelab_venv
```

# On-demand commands or cron jobs

Set up the laptop:

```
ansible-playbook ansible/playbooks/setup_laptop.yml --ask-become-pass
```

Set up the cluster:

```shell
ansible-playbook ansible/playbooks/bootstrap.yml --ask-become-pass
```

Backup Firefly DB:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags backup
```

Restore Firefly DB:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags restore
```

Remove K3S:

```shell
ansible-playbook ansible/playbooks/remove_k3s.yml --ask-become-pass
```

# TODO

- [x] Fix a bug where K3s crashes at startup because of node IP changes.
- [ ] Migrate to Gateway API.
- [ ] Introduce proper secret management.
- [ ] Use `kubernetes` module for related bootstrapping Ansible tasks.
