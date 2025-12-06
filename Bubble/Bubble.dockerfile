FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -r linux-x64 --self-contained false -o /app

FROM base AS final
WORKDIR /app
COPY --from=build /app .
COPY CBD/ca.pem /app/CBD/ca.pem
ENTRYPOINT ["dotnet", "Bubble.dll"]
