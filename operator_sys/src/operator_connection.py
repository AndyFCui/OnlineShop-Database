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
        print('->[1] Order                          #')
        print('->[2] Return Order                        #')
        print('->[3] Data Management                     #')
        print('->[4] Exit System                         #')
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
                self.return_order_list()
                self.control_panel()
            case '3':
                self.management_list()
                self.control_panel()
            case '4':
                self.cur.close()
                self.cnx.close()
                exit()
            case _:
                print('Error Select, Please Select Again. '
                      '(ONLY [1] [2] and [3] OPTIONS.)')
                self.control_panel()

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

        self.cur.execute("SET @operator_id_out = 0")
        self.cur.callproc('get_id', [self.current_operator, "@operator_id_out"])
        self.cur.execute("SELECT @operator_id_out")
        operator_id = self.cur.fetchone()[0]
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
            self.cnx.commit()
            print("Order created successfully.")
        except Exception as e:
            print(f"Error: {e}")

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

        # Create a new cursor for the result set
        result_cursor = self.cnx.cursor()

        try:
            result_cursor.callproc('return_payment', [
                return_order_id,
                return_goods_id,
                None
            ])

            # Fetch the OUT parameter value
            for result in result_cursor.stored_results():
                out_message = result.fetchone()[0]

            self.cnx.commit()

            print(f"Message: {out_message}")
        except Exception as e:
            print(f"Error: {e}")
        finally:
            result_cursor.close()

    def refund_and_products(self):
        print('Please Enter Request Return Order Information:')
        return_order_id = input('Order ID:')
        return_goods_id = input('Goods ID:')

        # Create a new cursor for the result set
        result_cursor = self.cnx.cursor()

        try:
            result_cursor.callproc('return_payment_and_goods', [
                return_order_id,
                return_goods_id,
                None
            ])

            # Fetch the OUT parameter value
            for result in result_cursor.stored_results():
                out_message = result.fetchone()[0]

            self.cnx.commit()

            print(f"Message: {out_message}")
        except Exception as e:
            print(f"Error: {e}")
        finally:
            result_cursor.close()

    def exchange(self):
        print('Please Enter Request Return Order Information:')
        return_order_id = input('Order ID:')
        return_goods_id = input('Goods ID:')

        # Create a new cursor for the result set
        result_cursor = self.cnx.cursor()

        try:
            result_cursor.callproc('return_exchange', [
                return_order_id,
                return_goods_id,
                None
            ])

            # Fetch the OUT parameter value
            for result in result_cursor.stored_results():
                out_message = result.fetchone()[0]

            self.cnx.commit()

            print(f"Message: {out_message}")
        except Exception as e:
            print(f"Error: {e}")
        finally:
            result_cursor.close()

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
        print('->[6] Back Last Menu                      #')
        print('->[7] Back Main Menu                      #')
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
                self.update_cus_info()
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

    def update_cus_info(self):
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
        print('->[3] Back Last Menu                      #')
        print('->[4] Back Main Menu                      #')
        print('###########################################')

        self.edit_model_options()

    def edit_model_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.create_model()
            case '2':
                self.delete_model()
            case '3':
                self.edit_robot_info_list()
                self.edit_robot_select()
            case '4':
                self.control_panel()
                self.control_panel_function()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_model_list()
                self.edit_model_options()

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
        print('->[3] Back Last Menu                      #')
        print('->[4] Back Main Menu                      #')
        print('###########################################')

        self.edit_software_options()

    def edit_software_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.create_software()
            case '2':
                self.delete_software()
            case '3':
                self.edit_robot_info_list()
                self.edit_robot_select()
            case '4':
                self.control_panel()
                self.control_panel_function()
            case _:
                print('Error Select, Please Select Again.')
                self.edit_software_list()
                self.edit_software_options()

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
            case '2':
                self.goods_update()
            case '3':
                self.goods_delete()
            case '4':
                self.goods_view()
            case '5':
                self.management_list()
                self.management_options()
            case '6':
                self.control_panel()
                self.control_panel_function()
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
        print('To Do Later')

    def edit_operator_list(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel   --##')
        print('##-- Storage Management  --##')
        print('###########################################')
        print('->[1] Operator Update                     #')
        print('->[2] Operator Logoff                     #')
        print('->[3] Back Last Menu                      #')
        print('->[4] Back Main Menu                      #')
        print('###########################################')

        self.edit_operator_select()

    def edit_operator_select(self):
        user_select = input('->')
        match user_select:
            case '1':
                self.operator_update_list()
            case '2':
                self.operator_logoff()
            case '3':
                self.management_list()
                self.management_options()
            case '4':
                self.control_panel()
                self.control_panel_function()
            case _:
                print('Error Select, Please Select Again.')

    def operator_logoff(self):
        print('Please Enter Operator Information:')
        operator_id = input('Operator ID:')

        try:
            self.cur.callproc('update_operator_name', [
                operator_id
            ])
            self.cnx.commit()
            print("Operator logged off successfully.")
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
                self.management_options()
            case '7':
                self.control_panel()
                self.control_panel_function()
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
