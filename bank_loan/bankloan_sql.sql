USE BankloanDB
/*tong quan cac chi so*/
--Tong so don xin vay
SELECT COUNT(id) AS total_loan_application
FROM bank_loan_data;
--So luong don xin dang ky khoan vay theo ngay hang thang(MTD)
SELECT	issue_date,
		total_loan_application,
		SUM(total_loan_application) OVER (PARTITION BY MONTH(issue_date) ORDER BY issue_date) AS MTD
FROM
(SELECT	issue_date,
		COUNT(id) AS total_loan_application
FROM bank_loan_data
GROUP BY issue_date) sub;
--Ti le thay doi don xin vay hang thang(MoM)
WITH summary_table  AS (SELECT	month_num,
		total_loan_application,
		LAG(total_loan_application,1,total_loan_application) OVER (ORDER BY month_num) as prev_tla
FROM
(SELECT	MONTH(issue_date) AS month_num,
		COUNT(id) AS total_loan_application
FROM bank_loan_data
GROUP BY MONTH(issue_date)
) sub)

SELECT	st.*,
		(st.total_loan_application - st.prev_tla)*100/st.prev_tla AS MoM_Growth
FROM summary_table st;
--Tong so tien giai ngan
SELECT SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data;
--So tien giai ngan theo ngay hang thang(MTD)
SELECT	issue_date,
		total_funded_amount,
		SUM(total_funded_amount) OVER (PARTITION BY MONTH(issue_date) ORDER BY issue_date) AS MTD
FROM
(SELECT	issue_date,
		SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY issue_date) sub;
--Ti le thay doi so tien giai ngan hang thang(MoM)
WITH summary_table  AS (
SELECT	month_num,
		total_funded_amount,
		LAG(total_funded_amount,1,total_funded_amount) OVER (ORDER BY month_num) AS prev_tfa
FROM
(SELECT	MONTH(issue_date) AS month_num,
		SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY MONTH(issue_date)
) sub)

SELECT	st.*,
		(st.total_funded_amount - st.prev_tfa)*100/st.prev_tfa AS MoM_Growth
FROM summary_table st;
--Tong so tien da thu hoi
SELECT SUM(total_payment) AS total_amount_received
FROM bank_loan_data;
--Tong so tien da thu hoi theo ngay hang thang(MTD)
SELECT	issue_date,
		total_amount_received,
		SUM(total_amount_received) OVER (PARTITION BY month(issue_date) ORDER BY issue_date) AS MTD
FROM
(SELECT	issue_date,
		SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY issue_date) sub;
--ti le thay doi so tien thu hoi hang thang(MoM)
WITH summary_table  AS (
SELECT	month_num,
		total_amount_received,
		LAG(total_amount_received,1,total_amount_received) OVER (ORDER BY month_num) AS prev_tar
FROM
(SELECT	MONTH(issue_date) AS month_num,
		SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY MONTH(issue_date)
) sub)

SELECT	st.*,
		(st.total_amount_received - st.prev_tar)*100/st.prev_tar AS MoM_Growth
FROM summary_table st;
--Lai suat trung binh
SELECT ROUND(AVG(int_rate)*100,2) AS avg_interest_rate
FROM bank_loan_data;
--Lai suat trung binh theo ngay hang thang(MTD)
WITH summary_tb AS(
SELECT	issue_date,
		SUM(interest_rate) OVER (PARTITION BY MONTH(issue_date) ORDER BY issue_date) AS total_interest_rate,
		SUM(num_loan_application) OVER (PARTITION BY MONTH(issue_date) ORDER BY issue_date) AS total_loan_applicaiton
FROM (SELECT	issue_date,
		SUM(int_rate) AS interest_rate,
		COUNT(id) AS num_loan_application
FROM bank_loan_data
GROUP BY issue_date) sub)

SELECT	issue_date,
		ROUND(total_interest_rate/total_loan_applicaiton*100,2) AS avg_interest_rate
FROM summary_tb;
--Ti le thay doi lai suat hang thang(MoM)
WITH summary_table  AS (
SELECT	month_num,
		avg_int_rate,
		LAG(avg_int_rate,1,avg_int_rate) OVER (ORDER BY month_num) AS prev_avg_int
FROM
(SELECT	MONTH(issue_date) AS month_num,
		AVG(int_rate) AS avg_int_rate
FROM bank_loan_data
GROUP BY MONTH(issue_date)
) sub)

SELECT	summary_table.*,
		ROUND((avg_int_rate-prev_avg_int)*100/prev_avg_int,2) as MoM_growth
FROM summary_table;
--DTI trung binh
SELECT ROUND(AVG(dti)*100,2) AS avg_dti
FROM bank_loan_data;
--DTI trung binh theo ngay hang thang(MTD)
WITH summary_tb AS(
SELECT	issue_date,
		SUM(total_dti) OVER (PARTITION BY MONTH(issue_date) ORDER BY issue_date) AS total_dti_rate,
		SUM(num_loan_application) OVER (PARTITION BY MONTH(issue_date) ORDER BY issue_date) AS total_loan_applicaiton
FROM (
SELECT	issue_date,
		SUM(dti) AS total_dti,
		COUNT(id) AS num_loan_application
FROM bank_loan_data
GROUP BY issue_date) sub)

SELECT	issue_date,
		ROUND(total_dti_rate/total_loan_applicaiton*100,2) AS avg_interest_rate
FROM summary_tb;
-- Ti le thay doi chi so DTI hang thang(MoM)
WITH summary_table  AS (
SELECT	month_num,
		avg_dti_rate,
		LAG(avg_dti_rate,1,avg_dti_rate) OVER (ORDER BY month_num) AS prev_avg_dti
FROM
(SELECT	MONTH(issue_date) AS month_num,
		AVG(dti) AS avg_dti_rate
FROM bank_loan_data
GROUP BY MONTH(issue_date)
) sub)

SELECT	summary_table.*,
		ROUND((avg_dti_rate-prev_avg_dti)*100/prev_avg_dti,2) AS MoM_growth
FROM summary_table;
/*khoan vay tot va khoan vay xau*/
--Ti le khoan vay tot
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;
--So luong khoan vay tot
SELECT COUNT(id) AS Good_Loan_Applications 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
--So tien giai ngan tu khoan vay tot
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
--So tien da thu hoi tu khoan vay tot
SELECT SUM(total_payment) AS Good_Loan_amount_received 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
--Ti le khoan vay xau
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;
--So luong khoan vay xay
SELECT COUNT(id) AS Bad_Loan_Applications 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';
--So tien da giai ngaan tu khoan vay xau
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';
--So tien da thu hoi tu khoan vay xau
SELECT SUM(total_payment) AS Bad_Loan_amount_received 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';
/*Phan tich cac chi so theo trang thai khoan vay*/
--Tinh so luong don xin vay, so tien da giai ngan, so tien da thu hoi, lai suat trung binh, DTI trung binh
SELECT	loan_status,
		COUNT(id) AS Total_Loan_Application,
		SUM(total_payment) AS Total_Amount_Received,
		SUM(loan_amount) AS Total_Funded_Amount,
		AVG(int_rate * 100) AS AVG_Interest_Rate,
		AVG(dti * 100) AS AVG_DTI
FROM bank_loan_data
GROUP BY loan_status;
--Tinh tong so tien da giai ngan va so tien da thu hoi theo ngay hang thang
SELECT	loan_status,
		issue_date,
		SUM(Total_Funded_amount) OVER (PARTITION BY loan_status, MONTH(issue_date) ORDER BY loan_status, issue_date) AS MTD_Funded_Amount,
		SUM(Total_Amount_Received) OVER (PARTITION BY loan_status, MONTH(issue_date) ORDER BY loan_status, issue_date) AS MTD_Amount_Received
FROM (
SELECT	loan_status,
		issue_date,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY loan_status, issue_date) sub;
/*bao cao tong quan*/
--Theo thang
SELECT	MONTH(issue_date) AS Month_Munber, 
		DATENAME(MONTH, issue_date) AS Month_name, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);
--Theo bang
SELECT	address_state AS State, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;
--Theo thoi han
SELECT	term AS Term, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;
--Theo so nam lam viec
SELECT	emp_length AS Employee_Length, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;
--Theo muc dich su dung
SELECT	purpose AS PURPOSE, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;
--Theo tinh trang so huu nha
SELECT	home_ownership AS Home_Ownership, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;