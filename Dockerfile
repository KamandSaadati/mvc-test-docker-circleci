# First we add a dotnet SDK image to build our app inside the container
FROM microsoft/dotnet:3.1-sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Here we use ASP.NET Core runtime to build runtime image
FROM microsoft/dotnet:3.1-aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "NetCoreExample.dll"]
CMD dotnet NetCoreExample.dll