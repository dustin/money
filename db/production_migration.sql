-- Start with fixtures applied so my account works.

delete from allowance_logs;
delete from allowance_tasks;
delete from categories;
delete from group_user_map;
delete from groups;
delete from money_accounts;
delete from money_transactions;
delete from roles;
delete from user_roles_map;
delete from users where id != 1;

insert into users(id, login, name, email, crypted_password, salt, created_at)
	select user_id, username, name, 'unknown@example.com', 'np', 'pepper',
		current_timestamp
	from public.money_users
	where user_id != 1
;

insert into groups select * from public.money_groups;
insert into group_user_map select * from public.money_group_xref;

insert into categories select * from public.money_categories;

insert into roles(id, name)
	select role_id, 'admin' from public.money_roles
		where role_name = 'superuser'
;

insert into user_roles_map(role_id, user_id)
	select role_id, user_id from public.money_user_role_map
; 

insert into money_accounts select * from public.money_accounts;

insert into money_transactions(
	id, user_id, money_account_id, category_id, descr, amount, ds,
		reconciled, deleted_at, ts)
	select transaction_id, user_id, acct_id, cat_id, descr, amount,
		ds, reconciled,
			case deleted
				when true then current_timestamp
				else null
			end, ts
		from public.money_transactions
;
