class BuildingsController < ApplicationController
    before_action :authenticate_user!
    

    def index
        @buildings = Building.where(user_id: current_user.id).last(5)
    end
     
    def show
        @building = Building.find(params[:id])
        @windows =  Window.where(building_id: params[:id])
    end

    def new 
        if params[:windows].present? && params[:title].present?
            @window_groub = []
            session[:title] = params[:title]
            for a in 1..params[:windows].to_i do
     
                window = {
                     "window_width" => 0,
                     "window_height" => 0,
                     "window_watage_width" => 0,
                     "window_wastage_height" => 0,
                     "window_instllation_pice" => 0,
                     "window_roll_width" => 0,
                     "window_roll_height" => 0,
                     "window_message" => "",
                     "window_useful_height" => 0,
                     "window_useful_width" => 0,
                     "window_wastage_pice" => 0
                }
                @window_groub.append(window)
                 
            end
            # render new_building_path
       else
        flash[:alert] = "Enter a Valid Info"
       end
    end

    def create
        @window_groub = []
        @title = session[:title]
        
        build = params.require(:buildings)
        len = build.count() / 2
        index_window = 0
        window_width = 0 
        window_height = 0

        totalusefulWasteHeight = 0
        totalUsefulWasteWidth = 0
        totalWasteWidth = 0
        totalWasteHeight = 0
        linerMeter = 0
        sqMeter = 0
        windowWidthForCost = 0
        multiWidthInHeight = 0
        for a in 0..(len - 1) do
            index_window = index_window + 1 if index_window != 0
            window_width =  build[index_window].to_i 
            index_window = index_window +1
            window_height = build[index_window].to_i 
        
            window = {
                "id" => a+1,
                "window_width" => window_width.to_i,
                "window_height" => window_height.to_i,
                "window_watage_width" => 0,
                "window_wastage_height" => 0,
                "window_instllation_pice" => 0,
                "window_roll_width" => 0,
                "window_roll_height" => 0,
                "window_message" => "",
                "window_useful_height" => 0,
                "window_useful_width" => 0,
                "window_wastage_pice" => 0
            }
            @window_groub.append(window)
                 
        end
        
        arr_window_wastage = window_waste(@window_groub)
        arr_reverse = arr_window_wastage.reverse()
        arr_result = start(arr_window_wastage,arr_reverse)
        
        
        for window in arr_result
            
            totalusefulWasteHeight = totalusefulWasteHeight + window["window_useful_height"]
            totalUsefulWasteWidth = totalUsefulWasteWidth + window["window_useful_width"]
            totalWasteWidth = totalWasteWidth + window["window_watage_width"]
            totalWasteHeight = totalWasteHeight + window["window_wastage_height"]

            linerMeter = linerMeter + (window["window_roll_height"] * window["window_instllation_pice"])

            windowWidthForCost = window["window_height"] * window["window_width"]
            multiWidthInHeight = multiWidthInHeight + windowWidthForCost
    

        end
        # CM to M

        totalusefulWasteHeight = totalusefulWasteHeight.to_f
        totalusefulWasteHeight = totalusefulWasteHeight / 100;

        totalUsefulWasteWidth = totalUsefulWasteWidth.to_f
        totalUsefulWasteWidth = totalUsefulWasteWidth / 100;

        totalWasteWidth = totalWasteWidth.to_f
        totalWasteWidth = totalWasteWidth / 100;

        totalWasteHeight = totalWasteHeight.to_f
        totalWasteHeight = totalWasteHeight / 100;

        linerMeter = linerMeter.to_f
        linerMeter = linerMeter /100
        multiWidthInHeight = multiWidthInHeight.to_f
        sqMeter = multiWidthInHeight / 10000

        
        
        new_building = Building.create(total_useful_wastage_height: totalusefulWasteHeight, total_useful_wastage_width: totalUsefulWasteWidth, total_wastage_height: totalWasteHeight, total_wastage_width: totalWasteWidth, liner_meter: linerMeter, sq_meter: sqMeter, user_id: current_user.id,title: @title)
        new_building.save

        for window in arr_result
            building_windows = Window.create(window_width: window["window_width"], window_height: window["window_height"], window_watage_width: window["window_watage_width"], window_wastage_height: window["window_wastage_height"], window_instllation_pice: window["window_instllation_pice"], window_roll_width: window["window_roll_width"], window_roll_height: window["window_roll_height"], window_message: window["window_message"], window_useful_height: window["window_useful_height"], window_useful_width: window["window_useful_width"], window_wastage_pice: window["window_wastage_pice"], building_id: Building.last.id)
            building_windows.save
        end
        redirect_to buildings_path
        
    end
    

    def window_waste(windowsGroup)
        windowsListAfterAddWaste = []
        for windowInfo in windowsGroup
          
            windowInformation = {
            "id" => windowInfo["id"],
            "window_width" => windowInfo["window_width"],
            "window_height" => windowInfo["window_height"],
            "window_watage_width" => windowInfo["window_watage_width"],
            "window_wastage_height" => windowInfo["window_wastage_height"],
            "window_instllation_pice" => windowInfo["window_instllation_pice"],
            "window_roll_width" => windowInfo["window_roll_width"],
            "window_roll_height" => windowInfo["window_roll_height"],
            "window_message" => windowInfo["window_message"],
            "window_useful_height" => windowInfo["window_useful_height"],
            "window_useful_width" => windowInfo["window_useful_width"],
            "window_wastage_pice" => windowInfo["window_wastage_pice"],
            "Donaition" => true
            }
            totalOfPis = 0
            sumOfHfiftyTo = 0
            sumOperation = 0
            totalWidth = 0
            divTotalWidthSumOfHfiftyTO = 0
            totalOfWastage = 0

            if windowInformation["window_width"] < 152 && windowInformation["window_height"] < 152 || windowInformation["window_width"] < 152 && windowInformation["window_height"] > 152
                windowInformation["window_watage_width"] = 152 - windowInformation["window_width"]
                windowInformation["window_wastage_height"] = windowInformation["window_height"]
                windowInformation["window_message"] ="The window will be installed in one piece and it Have waste : #{(152 - windowInformation["window_width"])}"
                windowInformation["window_instllation_pice"] = 1
                windowInformation["window_roll_width"] =  152
                windowInformation["window_roll_height"] = windowInfo["window_height"]
                windowInformation["window_wastage_pice"] = 1
                
            elsif windowInfo["window_width"] > 152 && windowInfo["window_height"] < 152 
                windowInformation["window_watage_width"] = 152 - windowInformation["window_height"]
                windowInformation["window_wastage_height"] = windowInformation["window_width"]
                windowInformation["window_message"] ="The window will be installed in reverse "
                windowInformation["window_instllation_pice"] = 1
                windowInformation["window_wastage_pice"] = 1
                
                
            elsif windowInfo["window_width"] > 152 && windowInfo["window_height"] > 152
                
                j = 0 
                while sumOfHfiftyTo <= windowInfo["window_width"]
                    sumOfHfiftyTo = sumOfHfiftyTo + 152
                    sumOperation = j + 1
                    j +=1
                end
    

                totalWidth = sumOfHfiftyTo - windowInfo["window_width"]
                divTotalWidthSumOfHfiftyTO = totalWidth / sumOperation
                totalOfPis = 152 - divTotalWidthSumOfHfiftyTO

                totalOfWastage = 152 - totalOfPis

                windowInformation["window_watage_width"] = totalOfWastage
                windowInformation["window_wastage_height"] = windowInfo["window_height"]
                windowInformation["window_message"] ="The window will be installed on more than one piece and the number of pieces is : #{sumOperation}" 
                windowInformation["window_instllation_pice"] = sumOperation
                windowInformation["window_wastage_pice"] = sumOperation
                
            elsif windowInfo["window_width"] > 152 && windowInfo["window_height"] == 152
                windowInformation["window_watage_width"] = 0
                windowInformation["window_wastage_height"] = 0
                windowInformation["window_message"] ="The window will be installed without any waste , The window will be installed in reverse "
                windowInformation["window_instllation_pice"] = 1
                windowInformation["window_wastage_pice"] = 1
                
                
                
            else
                windowInformation["window_watage_width"] = 0
                windowInformation["window_wastage_height"] = 0
                windowInformation["window_message"] ="-- The window will be installed without any waste --"
                windowInformation["window_instllation_pice"] = 1
                windowInformation["window_wastage_pice"] = 1
                

            
            end
            windowsListAfterAddWaste.append(windowInformation)
        end
    

    
        return windowsListAfterAddWaste
        
    end

    def start(windowArray,reverseWindowArray)
        for smallWindow in windowArray 
            wastageSuptractFromWindowWidth = 0
            wastageSuptractFromHeight = 0
            newState = " "
            stateFatherWindow = " "
            windowPeiceTakeWastage = 0
            wastagePieceUpdate = 0
                 
            for bigWindow in reverseWindowArray
                if smallWindow["id"] != bigWindow["id"]
                    windowPeiceTakeWastage = bigWindow["window_wastage_pice"]
                        #  if the width <= wastage Width , and hight <= wastage Height and the samll not
                        #  give any one any thing
                    if smallWindow["window_width"] <= bigWindow["window_watage_width"] && smallWindow["window_height"] <= bigWindow["window_wastage_height"] && smallWindow["window_roll_width"] != 0 && smallWindow["Donaition"] == true
                        if bigWindow["window_wastage_pice"] > 1
                            wastageSuptractFromWindowWidth = ( bigWindow["window_watage_width"]* bigWindow["window_wastage_pice"] ) - smallWindow["window_width"]
                            wastageSuptractFromHeight = (bigWindow["window_wastage_height"]* bigWindow["window_wastage_pice"]) - smallWindow["window_height"]
                        else
                            wastageSuptractFromWindowWidth = (bigWindow["window_watage_width"]* bigWindow["window_wastage_pice"])- smallWindow["window_width"]
                                
                            if wastageSuptractFromWindowWidth <= 0
                                wastageSuptractFromHeight = (bigWindow["window_wastage_height"]*  bigWindow["window_wastage_pice"])-  smallWindow["window_height"]
                                        
                            else
                                wastageSuptractFromHeight = smallWindow["window_height"]
                            end
                        end
                                    
                                    
                                

                            

                        newState = "The window will be installed from the waste of window No. : #{bigWindow["id"]}"
                        smallWindow["window_watage_width"] = 0
                        smallWindow["window_wastage_height"] = 0
                        smallWindow["window_message"] = newState 
                        smallWindow["window_roll_width"] = 0
                        smallWindow["window_roll_height"] = 0 
                        smallWindow["window_instllation_pice"] = 1
                        smallWindow["window_useful_width"] = smallWindow["window_width"]
                        smallWindow["window_useful_height"] =  smallWindow["window_height"]
                        stateFatherWindow = "And the Children is : #{smallWindow["id"]}"
                        bigWindow["window_message"] =  " #{bigWindow["window_message"]} - #{stateFatherWindow} "
                        bigWindow["window_watage_width"]= wastageSuptractFromWindowWidth 
                        bigWindow["window_wastage_height"] = wastageSuptractFromHeight 
                        bigWindow["Donaition"] = false
                        
                        if windowPeiceTakeWastage > 1
                            wastagePieceUpdate = windowPeiceTakeWastage - 1
                        else
                            wastagePieceUpdate = windowPeiceTakeWastage
                        end
                        bigWindow["window_wastage_pice"] = wastagePieceUpdate
 
                         
 
                    elsif smallWindow["window_width"]  <= bigWindow["window_wastage_height"] && smallWindow["window_height"] <=  bigWindow["window_watage_width"] && smallWindow["window_roll_width"] != 0 && smallWindow["Donaition"] == true
                        if bigWindow["window_wastage_pice"]  > 1
                            wastageSuptractFromwindow_width = (bigWindow["window_wastage_height"] * bigWindow["window_wastage_pice"])- smallWindow["window_width"] 
                            wastageSuptractFromHeight = (bigWindow["window_watage_width"] * bigWindow["window_wastage_pice"])- smallWindow["window_height"]
                            
                        else
                            wastageSuptractFromwindow_width = (bigWindow["window_wastage_height"]*  bigWindow["window_wastage_pice"])-  smallWindow["window_width"]
                                                                    
                            if wastageSuptractFromWindowWidth <= 0 
                                wastageSuptractFromHeight = (bigWindow["window_watage_width"] * bigWindow["window_wastage_pice"])- smallWindow["window_height"]
                                            
                            else
                                wastageSuptractFromHeight = smallWindow["window_height"]
                            end
                        end
                                    
                                    
                                
                                
                                
                                
                                

                            

                        newState = "-- The window will be installed from the waste of window No. : #{smallWindow["id"]}  and will be installation in reverse --"
                        smallWindow["window_watage_width"] = 0
                        smallWindow["window_wastage_height"] = 0
                        smallWindow["window_message"] = newState 
                        smallWindow["window_roll_width"] = 0
                        smallWindow["window_roll_height"] = 0 
                        smallWindow["window_instllation_pice"] = 1
                        smallWindow["window_useful_width"] = smallWindow["window_width"]
                        smallWindow["window_useful_height"] =  smallWindow["window_height"]
                        stateFatherWindow = " And the Children is : #{smallWindow["id"]}"
                        bigWindow["window_message"] =  " #{bigWindow["window_message"]} - #{stateFatherWindow} " 
                        bigWindow["window_watage_width"]= wastageSuptractFromWindowWidth 
                        bigWindow["window_wastage_height"] = wastageSuptractFromHeight
                        bigWindow["Donaition"] = false 
                        if (windowPeiceTakeWastage > 1)
                            wastagePieceUpdate = windowPeiceTakeWastage - 1
                        else
                            wastagePieceUpdate = windowPeiceTakeWastage
                        end
                        bigWindow["window_wastage_pice"] = wastagePieceUpdate 

                    
                         

                    end
                             
 
                end
         
            end
            
        end
        return windowArray
    end



end
