CREATE TABLE customer_detail (
    "id" TEXT,
	"registered_date" DATE
)

CREATE TABLE payment_detail (
      "id" INT,
	"payment_method" TEXT
)

CREATE TABLE sku_detail (
    "id" TEXT,
    "sku_name" TEXT,
    "base_price" FLOAT,
    "cogs" FLOAT,
    "category" TEXT
)

CREATE TABLE order_detail (
    "id" TEXT,
    "customer_id" TEXT,
    "order_date" DATE,
    "sku_id" TEXT,
    "price" INT,
    "qty_ordered" INT,
    "before_discount" FLOAT,
    "discount_amount" FLOAT,
    "after_discount" FLOAT,
    "is_gross" INT,
    "is_valid" INT,
    "is_net" INT,
    "payment_id" INT
)