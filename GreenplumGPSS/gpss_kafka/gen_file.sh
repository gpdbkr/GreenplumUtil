cat tpch.customer.json | egrep "op#1" | head -n 10 > tpch.customer.json.s1.insert
cat tpch.customer.json | egrep "op#1|op#2" | head -n 10 > tpch.customer.json.s2.insert_update
cat tpch.customer.json | egrep "op#1|op#2|op#3" | head -n 10 > tpch.customer.json.s3.insert_update_delete
cat tpch.customer.json | egrep "op#1|op#2|op#3|op#4" | head -n 10 > tpch.customer.json.s4.insert_update_delete_insert
cat tpch.customer.json | egrep "op#1|op#2|op#3|op#4|op#5" | head -n 20 > tpch.customer.json.s5.insert_update_delete_insert_multi_update
cat tpch.customer.json | egrep "op#1|op#6|op#7" | head -n 20 > tpch.customer.json.s6.insert_1update_1update
