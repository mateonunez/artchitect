import { MeResponse } from 'pages/api/users/me';

export default async function resolveUser(): Promise<MeResponse> {
  const response = await fetch(`/auth/api/users/me`, {
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
