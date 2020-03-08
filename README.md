# aeatDB
Quick and dirty™ invoice database with stored procedures for MariaDB/MySQL that I made to save time when filling in Spanish tax forms as a sole proprietor. It currently supports the quarterly and yearly forms for the **Value Added Tax**, the yearly declaration of **operations with third parties** and the declaration of **operations with intra-Community traders**.

**DISCLAIMER:** I am aware that many things could have been done better -such as index or query optimization- and many form fields are missing but it would have been stupid to spend minutes of human life adding features I didn't use or making queries and procedures run a few milliseconds faster when they needed to be run only once in a quarter or once in a year. If there is anything you don't like feel free to fork, fix and issue a pull request.

## Setup
Create a database and import the SQL files to it with administrator privileges:

```sh
$ echo "CREATE DATABASE 'aeatdb' DEFAULT CHARACTER SET utf8; USE aeatdb; " | cat - *.sql | mysql -u root -p
```

Put your Fiscal Identification Number/VAT Number (NIF) in the *config* table and the currencies and countries you trade with in the *divisa*, and *pais* tables. The *ue* column represents whether that country is in the European Union. Put also the different VAT rates on the *tipusIVA* table:

```sql
INSERT INTO config (k, v) VALUES ('NIF', '00000000-X');
INSERT INTO divisa (iso) VALUES ('EUR'), ('USD');
INSERT INTO pais (iso, ue) VALUES ('FR', true), ('US', false), ('ES', true);
INSERT INTO tipusIva (tipus) VALUES (0.04), (0.1), (0.21);
```

At last add yourself as a provider in the *proveidor* table with the *idPais* value of your country in the *pais* table:

```sql
INSERT INTO proveidor (nif, raoSocial, idPais) VALUES ('00000000-X', 'Individual or Company Name', 3);
```

## Usage
When you receive or issue an invoice add it to the *factura* table, if the seller or buyer is not present, add it to the *proveidor* table before adding the invoice. The values of the *factura* table are the following:

| Column | Value |
| --- | --- |
| idProveidor | *idProveidor* value in the *proveidor* table of the **seller**. |
| idComprador | *idProveidor* value in the *proveidor* table of the **buyer**. |
| ref | Invoice **reference number**. |
| data | **Issue date** of the invoice. |
| import | **Total** amount of the invoice **before taxes** in **its own currency**. |
| idDivisa | *idDivisa* value in the *divisa* table corresponding to the **invoice's currency**. |
| baseImp | **Total** value of the invoice **before taxes** in **your currency** at the time of payment. |
| iva | **True** when invoice **includes VAT** or for **goods imports**, **False** when it doesn't (e.g. between companies of two different EU member states). |
| idTipusIva | *idTipusIva* value in the *tipusIva* table corresponding to the **VAT rate of the products** on the invoice. |
| esServei | **True** if the invoiced items are **services**, **False** if they are **goods**. |

```sql
INSERT INTO factura (idProveidor, idComprador, ref, data, import, idDivisa, baseImp, iva, idTipusIva, esServei)
VALUES (2, 1, 'XX12345-2020', '20-10-2020', 15.00, 2, 13.23, true, 3, false);
```

When the time to file tax declarations comes, simply execute the stored procedure for that particular form passing the **fiscal year** as a paramater and additionally the **quarter** for the forms that need to be filed quarterly:

```sql
call get303(2019, 1);
call get390(2019);
call get349(2019, 1);
call get347(2019);
```

You can also **list** the **issued** or **received invoices** with the `getFactures()` stored procedure and the **expenses** or **turnover** with `getTotal()`. Set the **quarter parameter to 0** to get the result for the entire **fiscal year**. Set the **last** parameter as **True** for the expenses or received invoices and **False** for the turnover or issued invoices:

```sql
call getFactures(2019, 1, TRUE);
call getTotal(2019, 3, FALSE);
```
