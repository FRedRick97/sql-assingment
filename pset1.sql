
SELECT 
	u_name, p_name, 
	quantity, 
	amt_paid, 
	last_transaction,
	quantity  * cost - amt_paid AS Balance
FROM (
	SELECT
		u_name, p_name,
		SUM(product.cost) / COUNT(product.cost) AS cost,
		SUM(CASE WHEN transaction_type = 'Order' Then transaction_amt Else 0 END) AS quantity, 
		SUM(CASE WHEN transaction_type = 'Payment' Then transaction_amt Else 0 END) AS amt_paid,
		MAX(transaction_date) AS last_transaction
		FROM t_transactions
		INNER JOIN product ON product.p_id = t_transactions.p_id
		INNER JOIN users ON users.u_id = t_transactions.u_id GROUP BY u_name,p_name
) s1;
