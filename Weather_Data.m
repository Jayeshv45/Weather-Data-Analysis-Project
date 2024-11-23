% Import data from CSV
data = readtable('Weather_Data.csv'); 

% Check the current format of the Date column
disp('First few rows of the Date column:');
disp(data.Date(1:5));

% Convert the Date column to text first (if not already text)
data.Date = string(data.Date);

% Display first few rows to confirm conversion
disp('Text Date column:');
disp(data.Date(1:5));

% Attempt to convert to datetime format using multiple possible formats
try
    data.Date = datetime(data.Date, 'InputFormat', 'yyyy-MM-dd');
catch
    try
        data.Date = datetime(data.Date, 'InputFormat', 'dd-MM-yyyy');
    catch
        error('Unable to convert the text to datetime format. Please check the date format in the CSV file.');
    end
end

% Display first few rows to confirm conversion
disp('Converted Date column:');
disp(data.Date(1:5));

% Remove rows with missing values
data = rmmissing(data);

% Display message
disp('Missing values handled');

% Step 2: Basic Data Analysis

% Calculate mean temperature and humidity
avg_temp = mean(data.Temp);
avg_humidity = mean(data.Humidity);

% Display results
fprintf('Average Temperature: %.2f°C\n', avg_temp);
fprintf('Average Humidity: %.2f%%\n', avg_humidity);

% Find maximum and minimum temperature
max_temp = max(data.Temp);
min_temp = min(data.Temp);

% Find maximum and minimum humidity
max_humidity = max(data.Humidity);
min_humidity = min(data.Humidity);

% Display results
fprintf('Maximum Temperature: %.2f°C\n', max_temp);
fprintf('Minimum Temperature: %.2f°C\n', min_temp);
fprintf('Maximum Humidity: %.2f%%\n', max_humidity);
fprintf('Minimum Humidity: %.2f%%\n', min_humidity);

% Step 3: Data Visualization

% Create time series plot for temperature
figure;
plot(data.Date, data.Temp, '-r');
hold on;

% Create time series plot for humidity
plot(data.Date, data.Humidity, '-b');
hold off;

% Customize plot
xlabel('Date');
ylabel('Values');
title('Temperature and Humidity Over Time');
legend('Temperature', 'Humidity');
grid on;

% Extract month and year from date
data.Month = month(data.Date);
data.Year = year(data.Date);

% Group data by month and calculate average temperature and humidity
monthly_data = groupsummary(data, {'Year', 'Month'}, 'mean', {'Temp', 'Humidity'});

% Plot bar chart for average temperature and humidity
figure;
bar(monthly_data.Month, [monthly_data.mean_Temp, monthly_data.mean_Humidity]);

% Customize plot
xlabel('Month');
ylabel('Average Values');
title('Average Temperature and Humidity per Month');
legend('Average Temperature', 'Average Humidity');
grid on;

% Step 4: Summary Report

% Create a new script file named "weather_report.m"
script_name = 'weather_report.m';
fid = fopen(script_name, 'w');

fprintf(fid, '%% Weather Data Analysis Report\n');
fprintf(fid, '%% This report includes data analysis and visualizations of the weather dataset.\n\n');

% Add data analysis results
fprintf(fid, '%% Data Analysis Results\n');
fprintf(fid, 'Average Temperature: %.2f°C\n', avg_temp);
fprintf(fid, 'Average Humidity: %.2f%%\n', avg_humidity);
fprintf(fid, 'Maximum Temperature: %.2f°C\n', max_temp);
fprintf(fid, 'Minimum Temperature: %.2f°C\n', min_temp);
fprintf(fid, 'Maximum Humidity: %.2f%%\n', max_humidity);
fprintf(fid, 'Minimum Humidity: %.2f%%\n', min_humidity);

% Add time series plot
fprintf(fid, '\n%% Time Series Plot\n');
fprintf(fid, 'figure;\n');
fprintf(fid, 'plot(data.Date, data.Temp, ''-r'');\n');
fprintf(fid, 'hold on;\n');
fprintf(fid, 'plot(data.Date, data.Humidity, ''-b'');\n');
fprintf(fid, 'hold off;\n');
fprintf(fid, 'xlabel(''Date'');\n');
fprintf(fid, 'ylabel(''Values'');\n');
fprintf(fid, 'title(''Temperature and Humidity Over Time'');\n');
fprintf(fid, 'legend(''Temperature'', ''Humidity'');\n');
fprintf(fid, 'grid on;\n');

% Add bar chart
fprintf(fid, '\n%% Bar Chart\n');
fprintf(fid, 'figure;\n');
fprintf(fid, 'bar(monthly_data.Month, [monthly_data.mean_Temp, monthly_data.mean_Humidity]);\n');
fprintf(fid, 'xlabel(''Month'');\n');
fprintf(fid, 'ylabel(''Average Values'');\n');
fprintf(fid, 'title(''Average Temperature and Humidity per Month'');\n');
fprintf(fid, 'legend(''Average Temperature'', ''Average Humidity'');\n');
fprintf(fid, 'grid on;\n');

fclose(fid);

% Publish the script as a PDF
publish(script_name, 'pdf');
