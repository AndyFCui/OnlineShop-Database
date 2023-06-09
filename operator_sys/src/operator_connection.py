import pymysql


class DatabaseConnection:
    """
    # Content:
    # This project design for online Robot shop operator system.
    # Group: (name, email)
    # Member name:
    ** Andy(Xiang-Yu) Cui：cui.xiangyu@northeastern.edu
    ** Shu-Hao Liu：liu.shuha@northeastern.edu
    """

    def __init__(self):
        self.cur = None  # cur is the cursor of the database (MySQL)
        self.cnx = None  # cnx is the connection of the database (MySQL)
        self.status = False
        self.default_account = 'root'  # 'default_account'
        self.default_passwd = 'Db@5822900'  # 'rbstore_guest'
        self.cnx_connection()
        self.current_operator = None

    def cnx_connection(self):
        try:
            self.cnx = pymysql.connect(
                host='localhost',
                user=self.default_account,
                password=self.default_passwd,
                db='rbstore',
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            self.cur = self.cnx.cursor()
            self.status = True
            print('[Status] Connect To Database Successful.')

        except pymysql.err.OperationalError as e:
            # Access denied error
            if e.args[0] == 1045:
                print('Invalid username or password, please try again.')
                self.login(self)
            else:
                self.status = False
                print('[ERROR] Connection Failed, Error: %d: %s' % (e.args[0], e.args[1]))
                print('[Status] Connection Failed:{}'.format(e))
                self.login(self)

    def sign_up(self):
        print('Please Enter Info For Sign Up:')
        new_user = input('new_user: ', )
        new_password = input('passwd: ')
        new_name = input('your name: ')
        new_address = input('your address: ')
        new_phone = input('your phone number: ')
        new_sex = input('your sex: ')
        new_date_birth = input('your birth(year-mm-dd): ')
        try:
            self.cur.callproc('create_account',
                              [new_user,
                               new_password,
                               new_name,
                               new_address,
                               new_phone,
                               new_sex,
                               new_date_birth])
            self.cnx.commit()
            print(f"User '{new_user}' created with password '{new_password}'.")
        except Exception as e:
            print(f"Error: {e}")
            print([new_user], 'Already Exist, Please Try Another One.')
            print('Keep Sign Up?')
            print('[1]: Yes, Keep Sign Up.')
            print('[2]: Switch To Log In')
            print('[3]: Exit System.')
            user_select = input('->')
            match user_select:
                case '1':
                    self.sign_up()
                case '2':
                    self.login(self)
                case '3':
                    self.cur.close()
                    self.cnx.close()
                    exit()
                case _:
                    print('Error Select, Please Select Again.')
                    self.sign_up()

        # Close guest account, and prepare to connect new account
        self.status = False
        self.cur.close()
        self.cnx.close()

        # Login new account
        self.login(self)

    @staticmethod
    def prompt_user_interface(self):
        if self.status is True:
            print('------------ Welcome To Sale System ------------')
            print('Please Enter Number To Goto Your Windows:')
            print('[1]: Sign Up (If You Do Not Have A Account.)')
            print('[2]: Login')

    def user_choice(self):
        user_input = input('Enter your choice: ')
        match user_input:
            case '1':
                self.sign_up()
            case '2':
                self.login(self)
            case _:
                print('Error Select, Please Select Again. (ONLY [1] and [2] OPTIONS.)')
                self.prompt_user_interface(self)
                self.user_choice()

        return user_input

    @staticmethod
    def welcome(user_name):
        print("[%s] Welcome to use Robot Sale System" % user_name)
        print("You have successfully logged in.")

    @staticmethod
    def login(self):
        print("### Please Login With Your Username and Password ###")
        user_name = input("username: ")
        passwd = input("password: ")

        self.default_account = user_name
        self.default_passwd = passwd
        self.cnx_connection()

        if self.status is True:
            self.welcome(user_name)
            self.current_operator = user_name
            self.control_panel()

    def control_panel(self):
        print('###########################################')
        print('####-- Robot Sale Sys Control Panel  --####')
        print('###########################################')
        print('->[1] Order                               #')
        print('->[2] View Order                          #')
        print('->[3] Return Order                        #')
        print('->[4] Data Management                     #')
        print('->[5] Exit System                         #')
        print('###########################################')

        self.control_panel_function()

    def control_panel_function(self):
        print('Please Enter Number To Select Operate:'
              '(Please with out [], ONLY NUMBER.)')
        user_select = input("->")
        match user_select:
            case '1':
                self.order()
                self.control_panel()
            case '2':
                self.view_order()
                self.control_panel()
            case '3':
                self.return_order_list()
                self.control_panel()
            case '4':
                self.management_list()
            case '5':
                self.cur.close()
                self.cnx.close()
                exit()
            case _:
                print('Error Select, Please Select Again. '
                      '(ONLY [1] [2] and [3] OPTIONS.)')
                self.control_panel()

    def view_order(self):
        print('Please Enter Order ID To View Order:')
        order_id = input('Order ID:')

        try:
            # Call the stored procedure
            self.cur.callproc('view_order', [order_id])

            # Fetch the result and print it
            print(f"Order Information for Order ID '{order_id}':")
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print("No order with the given ID found.")
            else:
                for row in rows:
                    print(f"order_id: {row['order_id']}")
                    print(f"order_date: {row['order_date']}")
                    print(f"order_status: {row['order_status']}")
                    print(f"preference: {row['deliver_preference']}")
                    print(f"customer_id: {row['operator_id']}")
                    print(f"operator_id: {row['customer_id']}")
                    print()

            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def order(self):
        print('Please Enter Order Info:')
        order_date = input('Order Date:')
        print('Please Enter Order Status:')
        print('Status: `Order`, `Return Request`')
        order_status = input('Status:')
        print('Please Enter Order Preference:')
        print('Preference: `Overnight Delivery`, `Regular Delivery`')
        preference = input('Preference:')

        customer_name = input('Customer Name:')

        self.cur.callproc('get_id_for_out', [self.current_operator])
        result = self.cur.fetchone()
        operator_id = result['operator_id']
        # print(operator_id)
        self.cnx.commit()

        # Call the 'order_create' stored procedure with required parameters
        try:
            self.cur.callproc('order_create', [
                order_date,
                order_status,
                preference,
                operator_id,
                customer_name
            ])
            result_order_id = self.cur.fetchone()
            order_id = result_order_id['order_no']
            self.cnx.commit()
            print("Order created successfully.")
        except Exception as e:
            print(f"Error: {e}")

        self.fill_order(order_id)

    def fill_order(self, order_no):
        print('Please Add Your Product Into Your Shopping Cart:')
        in_goods_id = input('Goods ID:')
        price = input('Price:')

        try:
            self.cur.callproc('order_fill', [
                order_no,
                in_goods_id,
                price
            ])
            self.cnx.commit()
            print("Products add to shopping cart Successfully.")
        except Exception as e:
            print(f"Error: {e}")

        print(f'Current Added Order ID is: {order_no}')
        print('Do You Want Keep Shopping.')
        print('[1]: Yes      [2]: No')
        user_select = input('->')
        match user_select:
            case '1':
                self.fill_order(order_no)
            case '2':
                self.control_panel()

    def return_order_list(self):
        print('###########################################')
        print('####-- Robot Sale Sys Order Panel  --####')
        print('###########################################')
        print('->[1] Refund                              #')
        print('->[2] Refund & Return Product             #')
        print('->[3] Exchange                            #')
        print('->[4] Back Last Menu                      #')
        print('->[5] Back Main Menu                      #')
        print('###########################################')

        self.return_order_options()

    def return_order_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.refund()
                self.return_order_list()
            case '2':
                self.refund_and_products()
                self.return_order_list()
            case '3':
                self.exchange()
                self.return_order_list()
            case '4':
                self.control_panel()
                self.control_panel_function()
            case '5':
                self.control_panel()
                self.control_panel_function()
            case _:
                print('Error Select, Please Select Again.')
                self.return_order_list()

    def refund(self):
        print('Please Enter Request Return Order Information:')
        return_order_id = input('Order ID:')
        return_goods_id = input('Goods ID:')

        try:
            # Call the stored procedure
            self.cur.callproc('return_payment', [
                return_order_id,
                return_goods_id,
            ])

            # Fetch the result
            result = self.cur.fetchone()
            out_message = result['message']
            # Commit the transaction
            self.cnx.commit()

            print(f"Message: {out_message}")
        except Exception as e:
            print(f"Error: {e}")

    def refund_and_products(self):
        print('Please Enter Request Return Order Information:')
        return_order_id = input('Order ID:')
        return_goods_id = input('Goods ID:')

        try:
            # Call the stored procedure
            self.cur.callproc('return_payment_and_goods', [
                return_order_id,
                return_goods_id,
            ])

            # Fetch the result
            result = self.cur.fetchone()
            out_message = result['message']

            # Commit the transaction
            self.cnx.commit()

            print(f"Message: {out_message}")
        except Exception as e:
            print(f"Error: {e}")

    def exchange(self):
        print('Please Enter Request Return Order Information:')
        return_order_id = input('Order ID:')
        return_goods_id = input('Goods ID:')

        try:
            # Call the stored procedure
            self.cur.callproc('return_exchange', [
                return_order_id,
                return_goods_id,
            ])

            # Fetch the result
            result = self.cur.fetchone()
            out_message = result['message']

            # Commit the transaction
            self.cnx.commit()

            print(f"Message: {out_message}")
        except Exception as e:
            print(f"Error: {e}")

    def management_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('###########################################')
        print('->[1] Storage Management                  #')
        print('->[2] Edit Operator Info                  #')
        print('->[3] Edit Customer Info                  #')
        print('->[4] Edit Robot Info                     #')
        print('->[5] Back Last Menu                      #')
        print('->[6] Back Main Menu                      #')
        print('###########################################')

        self.management_options()

    def edit_customer_info(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('##-- Edit Customer Info  --##')
        print('###########################################')
        print('->[1] Create                              #')
        print('->[2] Update                              #')
        print('->[3] Delete                              #')
        print('->[4] Add Card                            #')
        print('->[5] View Card                           #')
        print('->[6] View Customer                       #')
        print('->[7] Back Last Menu                      #')
        print('->[8] Back Main Menu                      #')
        print('###########################################')

        self.customer_info_options()

    """
    This function is work for customer options.
    """
    def customer_info_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.create_cus_info()
                self.edit_customer_info()
            case '2':
                self.update_customer_info_list()
                self.edit_customer_info()
            case '3':
                self.del_cus_info()
                self.edit_customer_info()
            case '4':
                self.create_add_card()
                self.edit_customer_info()
            case '5':
                self.view_card()
                self.edit_customer_info()
            case '6':
                self.cus_view()
                self.edit_customer_info()
            case '7':
                self.management_list()
            case '8':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_customer_info()

    def update_customer_info_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('##-- Update Customer Info  --##')
        print('###########################################')
        print('->[1] Update Customer Name                #')
        print('->[2] Update Customer Address             #')
        print('->[3] Update Customer Phone Number        #')
        print('->[4] Back Last Menu                      #')
        print('->[5] Back Main Menu                      #')
        print('###########################################')

        self.update_customer_info_options()

    def update_customer_info_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.update_cus_name()
                self.update_customer_info_list()
            case '2':
                self.update_cus_addr()
                self.update_customer_info_list()
            case '3':
                self.update_cus_cell()
                self.update_customer_info_list()
            case '4':
                self.management_list()
            case '5':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_customer_info()

    def view_card(self):
        print('Please Enter Card Holder Name:')
        c_name = input('Holder Name(Customer Name):')

        try:
            # Call the stored procedure
            self.cur.callproc('view_card', [c_name])

            # Fetch the result and print it
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print(f"No credit cards found for the customer '{c_name}'.")
            else:
                # Get the column names
                column_names = [desc[0] for desc in self.cur.description]

                print(f"Credit Card Information for '{c_name}':")
                for row in rows:
                    row_dict = {column_name: value for column_name, value in zip(column_names, row.values())}
                    for key, value in row_dict.items():
                        print(f"{key}: {value}")
                    print()

            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def create_add_card(self):
        print('Please Enter Customer Credit Card')
        c_name = input('Customer Name:')
        c_card = input('Credit Card No:')
        print('Card Type: VISA/Master/AmericaExpress/Discover')
        c_card_type = input('Card Type:')
        expire_date = input('Expire Date(YYYY-MM-DD):')
        try:
            self.cur.callproc('insert_credit_card', [
                c_name,
                c_card,
                c_card_type,
                expire_date
            ])
            self.cnx.commit()
            print("Credit Card information created successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def cus_view(self):
        print('Please Enter Info Of Customer To View:')
        c_name = input('Customer Name:')

        try:
            # Call the stored procedure
            self.cur.callproc('view_customer', [c_name])

            # Fetch the result and print it
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print(f"No customer with the name '{c_name}' found.")
            else:
                # Get the column names
                column_names = [desc[0] for desc in self.cur.description]

                print(f"Customer Information for '{c_name}':")
                print('--------------------------------------------------')
                for row in rows:
                    row_dict = {column_name: value for column_name, value in zip(column_names, row.values())}
                    for key, value in row_dict.items():
                        print(f"{key}: {value}")
                    print()
                print('--------------------------------------------------')
            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def update_cus_addr(self):
        print('Please Enter Request Update Customer Information:')
        cus_name = input('Customer Name:')
        cus_addr_new = input('Customer New Address:')

        try:
            self.cur.callproc('update_customer_address', [
                cus_name,
                cus_addr_new
            ])
            self.cnx.commit()
            print("Customer information updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def update_cus_cell(self):
        print('Please Enter Request Update Customer Information:')
        cus_name = input('Customer Name:')
        cus_cell_new = input('Customer New Phone Number:')

        try:
            self.cur.callproc('update_customer_phone_number', [
                cus_name,
                cus_cell_new
            ])
            self.cnx.commit()
            print("Customer information updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def update_cus_name(self):
        print('Please Enter Request Update Customer Information:')
        cus_name = input('Customer Name:')
        cus_name_new = input('Customer New Name:')

        try:
            self.cur.callproc('update_customer_name', [
                cus_name,
                cus_name_new
            ])
            self.cnx.commit()
            print("Customer information updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def create_cus_info(self):
        print('Please Enter Customer Information:')
        customer_id = input('Customer ID:')
        customer_name = input('Customer Name:')
        customer_addr = input('Customer Address:')
        customer_cell = input('Customer Phone Number:')
        customer_sex = input('Customer Legal Sex(Male/Female):')
        customer_dob = input('Customer Date Of Birth(YYYY-MM-DD):')

        try:
            self.cur.callproc('insert_customer', [
                customer_id,
                customer_name,
                customer_addr,
                customer_cell,
                customer_sex,
                customer_dob
            ])
            self.cnx.commit()
            print("Customer information created successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def del_cus_info(self):
        print('Please Enter Customer Information:')
        customer_id = input('Customer ID:')

        try:
            self.cur.callproc('delete_customer', [customer_id])
            self.cnx.commit()
            print("Customer information deleted successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def edit_robot_info_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('##-- Edit Robot Info                  --##')
        print('###########################################')
        print('->[1] Edit Robot Model                    #')
        print('->[2] Edit Robot Software                 #')
        print('->[3] Back Last Menu                      #')
        print('->[4] Back Main Menu                      #')
        print('###########################################')

        self.edit_robot_select()

    def edit_model_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('##-- Edit Robot Model Info            --##')
        print('###########################################')
        print('->[1] Create Robot Model                  #')
        print('->[2] Delete Robot Model                  #')
        print('->[3] View Robot Model                    #')
        print('->[4] Back Last Menu                      #')
        print('->[5] Back Main Menu                      #')
        print('###########################################')

        self.edit_model_options()

    def edit_model_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.create_model()
                self.edit_model_list()
            case '2':
                self.delete_model()
                self.edit_model_list()
            case '3':
                self.view_model()
                self.edit_model_list()
            case '4':
                self.edit_robot_info_list()
            case '5':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_model_list()

    def view_model(self):
        print('Please Enter Model Of Robot:')
        m_name = input('Model Name:')

        try:
            # Call the stored procedure
            self.cur.callproc('view_model', [m_name])

            # Fetch the result and print it
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print(f"No model found for the given Model Name '{m_name}'.")
            else:
                # Get the column names
                column_names = [desc[0] for desc in self.cur.description]

                print(f"Model Information for Model Name '{m_name}':")
                for row in rows:
                    row_dict = {column_name: value for column_name, value in zip(column_names, row.values())}
                    for key, value in row_dict.items():
                        print(f"{key}: {value}")
                    print()

            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def create_model(self):
        print('Please Enter Robot Information:')
        model_id = input('Model ID:')
        model_name = input('Model Name:')

        try:
            self.cur.callproc('insert_robot_model', [
                model_id,
                model_name
            ])
            self.cnx.commit()
            print("Robot model information created successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def delete_model(self):
        print('Please Enter Robot Information:')
        model_id = input('Model ID:')

        try:
            self.cur.callproc('delete_robot_model', [model_id])
            self.cnx.commit()
            print("Robot model deleted successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def edit_robot_select(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.edit_model_list()
            case '2':
                self.edit_software_list()
            case '3':
                self.management_list()
                self.management_options()
            case '4':
                self.control_panel()
                self.control_panel_function()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_robot_info_list()
                self.edit_robot_select()

    def edit_software_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('##-- Edit Robot Software Info         --##')
        print('###########################################')
        print('->[1] Create Robot Software               #')
        print('->[2] Delete Robot Software               #')
        print('->[3] View Robot Software                 #')
        print('->[4] Back Last Menu                      #')
        print('->[5] Back Main Menu                      #')
        print('###########################################')

        self.edit_software_options()

    def edit_software_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.create_software()
                self.edit_software_list()
            case '2':
                self.delete_software()
                self.edit_software_list()
            case '3':
                self.software_view()
                self.edit_software_list()
            case '4':
                self.edit_robot_info_list()
            case '5':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_software_list()

    def software_view(self):
        print('Please Enter Software Info:')
        ed_software = input('Software Edition:')

        try:
            # Call the stored procedure
            self.cur.callproc('view_software', [ed_software])

            # Fetch the result and print it
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print(f"No software found for the given Software Edition '{ed_software}'.")
            else:
                # Get the column names
                column_names = [desc[0] for desc in self.cur.description]

                print(f"Software Information for Software Edition '{ed_software}':")
                for row in rows:
                    row_dict = {column_name: value for column_name, value in zip(column_names, row.values())}
                    for key, value in row_dict.items():
                        print(f"{key}: {value}")
                    print()

            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def create_software(self):
        print('Please Enter Robot Software Information:')
        edition = input('Edition:')
        description = input('Software Description:')
        release = input('Release Date(YYYY-MM-DD):')

        try:
            self.cur.callproc('insert_software_edition', [
                edition,
                description,
                release
            ])
            self.cnx.commit()
            print("Robot software information created successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def delete_software(self):
        print('Please Enter Robot Software Delete Information:')
        edition = input('Edition:')

        try:
            self.cur.callproc('delete_software', [
                edition,
            ])
            self.cnx.commit()
            print("Robot software information deleted successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def view_software(self):
        print('Please Enter Robot Software View Information:')
        edition = input('Edition:')
        # Create a new cursor for the result set
        result_cursor = self.cnx.cursor()
        try:
            result_cursor.callproc('view_software', [edition])

            # Fetch and print the result
            print("\nResults:")
            print(
                f"{'Software ID':<15}{'Edition':<20}{'Other Column':<20}")
            # Add more column names here as per your table schema
            print("-" * 55)

            for result in result_cursor.stored_results():
                for row in result.fetchall():
                    print(f"{row[0]:<15}{row[1]:<20}{row[2]:<20}")  # Add more row indexes here as per your table schema
            print("-" * 55)
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")
        finally:
            result_cursor.close()

    def management_options(self):
        """
        This method work for the management options, which is main panel.
        """
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.storage_management()
            case '2':
                self.edit_operator_list()
            case '3':
                self.edit_customer_info()
            case '4':
                self.edit_robot_info_list()
            case '5':
                self.control_panel()
                self.control_panel_function()
            case '6':
                self.control_panel()
                self.control_panel_function()
            case _:
                print('Error Select, Please Select Again.')
                self.management_list()
                self.management_options()

    def storage_management(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel   --##')
        print('##-- Storage Management  --##')
        print('###########################################')
        print('->[1] Add Goods                           #')
        print('->[2] Update In Stock                     #')
        print('->[3] Delete Goods                        #')
        print('->[4] View Goods                          #')
        print('->[5] Back Last Menu                      #')
        print('->[6] Back Main Menu                      #')
        print('###########################################')

        self.storage_select()

    def storage_select(self):
        user_select = input('->')
        match user_select:
            case '1':
                self.goods_add()
                self.storage_management()
            case '2':
                self.goods_update()
                self.storage_management()
            case '3':
                self.goods_delete()
                self.storage_management()
            case '4':
                self.goods_view()
                self.storage_management()
            case '5':
                self.management_list()
            case '6':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.storage_select()

    def goods_add(self):
        print('Please Enter Goods Information:')
        goods_id = input('Goods ID:')
        goods_stock = input('In Stock Value:')
        produced_date = input('Produced Date(YYYY-MM-DD):')
        software_ed = input('Software Edition:')
        price = input('Purchased Price:')
        model_id = input('Model ID:')

        try:
            self.cur.callproc('insert_goods', [
                goods_id,
                goods_stock,
                produced_date,
                software_ed,
                price,
                model_id
            ])
            self.cnx.commit()
            print("Goods information added successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def goods_update(self):
        print('Please Enter Goods Information:')
        goods_id = input('Goods ID:')
        goods_stock = input('In Stock Change Value:')

        try:
            self.cur.callproc('update_goods_stock', [
                goods_id,
                goods_stock
            ])
            self.cnx.commit()
            print("Goods stock updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def goods_delete(self):
        print('Please Enter Goods Information:')
        goods_id = input('Goods ID:')

        try:
            self.cur.callproc('delete_goods', [
                goods_id,
            ])
            self.cnx.commit()
            print("Goods deleted successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def goods_view(self):
        print('Please Enter Goods Info To View:')
        g_id = input('Goods ID:')

        try:
            # Call the stored procedure
            self.cur.callproc('view_goods', [g_id])

            # Fetch the result and print it
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print(f"No goods found for the given Goods ID '{g_id}'.")
            else:
                # Get the column names
                column_names = [desc[0] for desc in self.cur.description]

                print(f"Goods Information for Goods ID '{g_id}':")
                for row in rows:
                    row_dict = {column_name: value for column_name, value in zip(column_names, row.values())}
                    for key, value in row_dict.items():
                        print(f"{key}: {value}")
                    print()

            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def edit_operator_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel   --##')
        print('##-- Storage Management  --##')
        print('###########################################')
        print('->[1] Operator Update                     #')
        print('->[2] Operator View                       #')
        print('->[3] Back Last Menu                      #')
        print('->[4] Back Main Menu                      #')
        print('###########################################')

        self.edit_operator_select()

    def edit_operator_select(self):
        user_select = input('->')
        match user_select:
            case '1':
                self.operator_update_list()
                self.edit_operator_list()
            case '2':
                self.operator_view()
                self.edit_operator_list()
            case '3':
                self.management_list()
            case '4':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_operator_list()

    def operator_view(self):
        print('Please Enter Operator Info To View:')
        o_name = input('Operator Name:')

        try:
            # Call the stored procedure
            self.cur.callproc('view_operator', [o_name])

            # Fetch the result and print it
            print(f"Operator Information for Operator Name '{o_name}':")
            rows = self.cur.fetchall()
            if len(rows) == 0:
                print("No operator with the given name found.")
            else:
                for row in rows:
                    print(f"operator_id: {row['operator_id']}")
                    print(f"operator_name: {row['name']}")
                    print(f"operator_address: {row['address']}")
                    print(f"phone_number: {row['phone_number']}")
                    print(f"legal_sex: {row['legal_sex']}")
                    print(f"date_of_birth: {row['date_of_birth']}")
                    print(f"user_id: {row['user_id']}")
                    print(f"user_password: {row['user_password']}")
                    print()

            # Commit the transaction
            self.cnx.commit()
        except Exception as e:
            print(f"Error: {e}")

    def operator_update_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel   --##')
        print('##-- Update Operator Options  --##')
        print('###########################################')
        print('->[1] Update Name                         #')
        print('->[2] Update Address                      #')
        print('->[3] Update Phone                        #')
        print('->[4] Update User ID                      #')
        print('->[5] Update password                     #')
        print('->[6] Back Last Menu                      #')
        print('->[7] Back Main Menu                      #')
        print('###########################################')

        self.operator_update_select()

    def operator_update_select(self):
        user_select = input('->')
        match user_select:
            case '1':
                self.operator_update_name()
                self.operator_update_list()
            case '2':
                self.operator_update_address()
                self.operator_update_list()
            case '3':
                self.operator_update_phone()
                self.operator_update_list()
            case '4':
                self.operator_update_user_id()
                self.operator_update_list()
            case '5':
                self.operator_update_password()
                self.operator_update_list()
            case '6':
                self.management_list()
            case '7':
                self.control_panel()
            case _:
                print('Error Select, Please Select Again.')
                self.operator_update_list()

    def operator_update_name(self):
        print('Please Enter Operator Information:')
        operator_name = input('Operator Name:')
        new_name = input('Operator New Name:')

        try:
            self.cur.callproc('update_operator_name', [
                operator_name,
                new_name
            ])
            self.cnx.commit()
            print("Operator name updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def operator_update_address(self):
        print('Please Enter Operator Information:')
        o_name = input('Operator Name:')
        new_address = input('Operator New Address:')

        try:
            self.cur.callproc('update_operator_address', [
                o_name,
                new_address
            ])
            self.cnx.commit()
            print("Operator address updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def operator_update_phone(self):
        print('Please Enter Operator Information:')
        operator_phone = input('Operator Phone:')
        new_phone = input('Operator New Phone:')

        try:
            self.cur.callproc('update_operator_phone', [
                operator_phone,
                new_phone
            ])
            self.cnx.commit()
            print("Operator phone updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def operator_update_user_id(self):
        print('Please Enter Operator Information:')
        o_name = input('Operator Name:')
        new_user_id = input('Operator New User ID:')

        try:
            self.cur.callproc('update_operator_user_id', [
                o_name,
                new_user_id
            ])
            self.cnx.commit()
            print("Operator user ID updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def operator_update_password(self):
        print('Please Enter Operator Information:')
        operator_name = input('User Name:')
        new_passwd = input('Operator New Password:')

        try:
            self.cur.callproc('update_operator_user_password', [
                operator_name,
                new_passwd
            ])
            self.cnx.commit()
            print("Operator password updated successfully.")
        except Exception as e:
            print(f"Error: {e}")

    def main(self):
        self.prompt_user_interface(self)
        if self.status is True:
            self.user_choice()
            self.control_panel_function()


if __name__ == '__main__':
    database = DatabaseConnection()
    database.main()
