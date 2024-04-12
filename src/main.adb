procedure main is
   package String_Lists is new Indefinite_Doubly_Linked_Lists (String);
   use String_Lists;

   procedure Starter (Manage_Capacity : in Integer; Total_Productss : in Integer;
                      Total_Producers : in Integer; Total_Consumers : in Integer) is
      Manage : List;

      Access_Manage : Counting_Semaphore (1, Default_Ceiling);
      Full_Manage   : Counting_Semaphore (Manage_Capacity, Default_Ceiling);
      Empty_Manage  : Counting_Semaphore (0, Default_Ceiling);

      task Producer;
      task type Producer_Arr is array (1 .. Total_Producers) of Producer;

      task Consumer;
      task type Consumer_Arr is array (1 .. Total_Consumers) of Consumer;

      task body Producer is
      begin
         for i in 1 .. Total_Productss loop
            Full_Manage.Seize;
            Access_Manage.Seize;

            Manage.Append ("produced " & i'Img);
            Put_Line ("Producer produced " & i'Img);

            Access_Manage.Release;
            Empty_Manage.Release;
            delay 1.0;
         end loop;
      end Producer;

      task body Consumer is
      begin
         for i in 1 .. Total_Productss loop
            Empty_Manage.Seize;
            Access_Manage.Seize;

            declare
               Product : String := First_Element (Manage);
            begin
               Put_Line ("Consumer consumed " & Product);
            end;

            Manage.Delete_First;

            Access_Manage.Release;
            Full_Manage.Release;

            delay 2.0;
         end loop;
      end Consumer;

      Producers : Producer_Arr;
      Consumers : Consumer_Arr;

   begin
      null;
   end Starter;

begin
   Starter (3, 10, 2, 3); 
end main;
