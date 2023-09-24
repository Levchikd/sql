create table customers
(
	customer_id int auto_increment,
    first_name varchar(255),
    last_name varchar(255),
    email_address varchar(255),
    naumber_of_complaints int,
primary key (customer_id)
);

alter table customers
add column gender enum('m','f') after last_name;

insert into customers (first_name, last_name, gender, email_address, naumber_of_complaints)
values ('John', 'Mackinley', 'M', 'john.mckinley@365careers.com', 0);

create table companies 
(
    company_id varchar(255),
    company_name varchar(255),
    headquarters_phone_number varchar(255) default 'X',
    primary key (company_id),
    unique key (headquarters_phone_number)
);

drop table companies;

CREATE TABLE companies (
    company_id VARCHAR(255),
    company_name VARCHAR(255),
    headquarters_phone_number VARCHAR(255) DEFAULT 'X',
    PRIMARY KEY (company_id),
    UNIQUE KEY (headquarters_phone_number)
);

alter table companies
modify headquarters_phone_number varchar(255) null;

alter table companies
change column headquarters_phone_number headquarters_phone_number varchar(255) not null;
    