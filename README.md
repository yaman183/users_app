# users_app

This project was developed as part of a task to display a users list and user details using Flutter and the ReqRes API.

## Project Overview
The main requirements of the task were:
- Fetch users data from an API
- Display a users list with search and filter options (All / Active / Inactive)
- Show a user details screen
- Handle loading, error, and empty states properly

## Issue We Faced
During development, we faced an issue while fetching data from the API.
Some requests were returning a **403 Forbidden** error.

This error usually means that the server is rejecting the request, which can happen when:
- Required headers are missing
- The request is not recognized as coming from a valid client

## How We Solved It
To solve this issue:
- We used **Dio** for handling API requests
- Added proper request headers such as:
  - `User-Agent`
  - `Accept`
  - `Content-Type`
- Configured request timeouts to handle slow responses

After these changes, the API requests worked correctly and data was fetched without errors.

## Notes
- Riverpod is used for state management
- Loading, error, and empty states are handled in the UI
- User active/inactive status is stored locally to keep the state consistent
