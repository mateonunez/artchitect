import { MeResponse } from 'pages/api/users/me';

export default async function resolveUser(): Promise<MeResponse> {
  const { BASE_URL } = process.env;

  console.log(`http://${BASE_URL}/auth/api/users/me`);
  
  const response = await fetch(`http://${BASE_URL}/auth/api/users/me`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  });

  const data: MeResponse = await response.json();

  if (!response.ok) {
  }

  return data;
}
